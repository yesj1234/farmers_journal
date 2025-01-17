import 'dart:developer';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:logger/logger.dart';

class ExcelRepository {
  final String filePath;
  late final Excel? excel;

  ExcelRepository({
    required this.filePath,
  }) {
    excel = _readExcelFile(filePath);
  }

  Excel _readExcelFile(String filePath) {
    final bytes = File(filePath).readAsBytesSync();
    return Excel.decodeBytes(bytes);
  }
}

class HSCodeRepository extends ExcelRepository {
  HSCodeRepository({required super.filePath}) {
    varieties = _setHSCodeVarieties();
    subCategories = _setHSCodeSubCategories();
  }
  late final List<TextCellValue?> varieties;
  late final List<dynamic> subCategories;

  List<TextCellValue?> _setHSCodeVarieties() {
    if (excel == null) {
      return [];
    } else {
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
          .map((cellValue) => cellValue?.first as TextCellValue)
          .toList();
    }

    return [];
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

// For developing purpose.
void main() {
  // '/Users/yangseungjun/AndroidStudioProjects/farmers_journal/assets/xls/hs_code.xlsx';
  HSCodeRepository hsCodeRepository = HSCodeRepository(
      filePath:
          '/Users/yangseungjun/AndroidStudioProjects/farmers_journal/assets/xls/hs_code.xlsx');
  // hsCodeRepository.readHSCode();
  print(hsCodeRepository.findMatchingVariety(input: '포도'));
  // print(hsCodeRepository.varieties);
  // print(hsCodeRepository.subCategories);
}
