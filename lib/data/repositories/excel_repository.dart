import 'dart:developer';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Base class for Excel repository.
///
class ExcelRepository {
  final String? filePath;
  final FirebaseStorage instance;
  late final Excel? excel;

  ExcelRepository({
    required this.instance,
    required this.filePath,
  });
  Future<void> initialize() async {
    log(filePath.toString());
    if (filePath != null) {
      await _readExcelFile(filePath!);
    }
  }

  Future<void> _readExcelFile(String filePath) async {
    try {
      final bytes = await instance.ref(filePath).getData();
      if (bytes != null) {
        excel = Excel.decodeBytes(bytes);
      } else {
        log('Failed to load Excel file: no data.');
        excel = null;
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}

/// [HScode](https://ko.wikipedia.org/wiki/HS%EC%BD%94%EB%93%9C)(Harmonized System code) excel repository provided by [AT Center](https://at.agromarket.kr/codeInfo/introduce.do).
///
/// * 부류 (Category / Section) : he highest-level classification concept in the HS Code, representing broad groups of agricultural products
/// * 품목 (Item / Subcategory / Heading) : A classification concept that distinguishes specific types of agricultural products, such as grains, fruits, and vegetables.
/// * 품종 (Variety / Cultivar) : A concept that refers to specific varieties within a crop, such as ‘Fuji’ for apples or ‘Shine Muscat’ for grapes.
class HSCodeRepository extends ExcelRepository {
  HSCodeRepository({required super.filePath, required super.instance});
  late final List<TextCellValue?> varieties;
  late final List<dynamic> subCategories;

  @override
  Future<void> initialize() async {
    await super.initialize();
    varieties = _setHSCodeVarieties();
    subCategories = _setHSCodeSubCategories();
  }

  List<TextCellValue?> _setHSCodeVarieties() {
    final currentTable = excel!.tables[excel!.tables.keys.first];
    final startIndex = CellIndex.indexByColumnRow(
        columnIndex: currentTable!.maxColumns - 1, rowIndex: 1);
    final endIndex = CellIndex.indexByColumnRow(
        columnIndex: currentTable.maxColumns - 1,
        rowIndex: currentTable.maxRows - 1);
    return currentTable
        .selectRangeValues(
      startIndex,
      end: endIndex,
    )
        .map((cellValue) {
      return cellValue?.first as TextCellValue;
    }).toList();
  }

  List<List<CellValue?>?> _setHSCodeSubCategories() {
    if (excel == null) {
      return [];
    } else {
      final currentTable = excel!.tables[excel!.tables.keys.first];
      final startIndex = CellIndex.indexByColumnRow(
          columnIndex: currentTable!.maxColumns - 3, rowIndex: 1);
      final endIndex = CellIndex.indexByColumnRow(
          columnIndex: currentTable.maxColumns - 1,
          rowIndex: currentTable.maxRows - 1);

      return currentTable.selectRangeValues(
        startIndex,
        end: endIndex,
      ) as List<List<CellValue?>?>;
    }
  }

  /// Return varieties that might possibly match the [input] string.
  Map<String, List<dynamic>> findMatchingVariety({required String input}) {
    if (input.isEmpty) {
      return {
        'variety': [],
        'subCategory': [],
      };
    } else {
      return {
        'variety': [
          ...varieties
              .where((variety) => variety!.value.text!.contains(input))
              .map((matched) => matched?.value.text),
        ],
        'subCategory': [
          ...subCategories.where((columns) {
            return columns.first.value.text.contains(input);
          }).map((matched) => matched.last.value.text),
        ],
      };
    }
  }

  /// Return HSCode of the variety for later use, such as querying the real time auction price of that variety.
  String? getHsCode({required String variety}) {
    final trimmed = variety.trim();
    final currentTable = excel!.tables[excel!.tables.keys.first];
    final firstMatch = currentTable!.rows.indexWhere((row) {
      final textCellValue = row.last?.value as TextCellValue;
      return textCellValue.value.text == trimmed;
    });
    if (firstMatch < 0) {
      return null;
    } else {
      final matchRow = currentTable.rows[firstMatch];
      final major = matchRow[0]?.value.toString();
      final mid = matchRow[2]?.value.toString();
      final minor = matchRow[4]?.value.toString();

      return '$major$mid$minor';
    }
  }
}
