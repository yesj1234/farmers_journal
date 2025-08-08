import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../domain/model/real_time_auction_info.dart';

class AuctionPriceRepository {
  final String _endPoint = 'http://211.237.50.150:7080/openapi';

  final String? _apiKey = dotenv.env['AUCTION_API_KEY'];

  // possible formats: 'xml', 'json'
  // defaults to 'json'.
  final String _responseFormat = 'json';

  final String _apiUrl = 'Grid_20240625000000000654_1';

  // saleDate: 경락일자
  // whsalcd: 도매시장코드
  // large: 대분류코드
  // mid: 중분류코드
  // small: 소분류코드
  Future<List<AuctionPrice>> getPrice({
    required DateTime saleDate,
    required String whsalcd,
    required String large,
    required String mid,
    required String small,
    required int startRow,
    required int endRow,
  }) async {
    try {
      final String formattedDate = DateFormat('yyMMdd').format(saleDate);

      final String _url =
          "$_endPoint/$_apiKey/$_responseFormat/$_apiUrl/$startRow/$endRow?SALEDATE=20240502&WHSALCD=$whsalcd&LARGE=$large&MID=$mid&SMALL=$small";
      final Uri uri = Uri.parse(_url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map body = jsonDecode(response.body);
        final rows = body[body.keys.first]['row'];

        final auctionPrices = rows
            .map<AuctionPrice>((row) => AuctionPrice.fromJson(row))
            .toList();

        return auctionPrices;
      } else {
        return [];
      }
    } catch (error, stk) {
      throw Exception("$error, $stk ");
    }
  }
}
