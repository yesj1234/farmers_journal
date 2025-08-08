// //| 서비스키   | serviceKey | -   | 필수  | -        | OpenApi 신청 > 로그인 > serviceKey 발급 |
// //| ------ | ---------- | --- | --- | -------- | -------------------------------- |
// //| API유형  | apiType    | 4   | 필수  | json     | xml 또는 json                      |
// //| 페이지 번호 | pageNo     | -   | 필수  | 1        | 페이지 별 1000건 데이터 표출               |
// //| 도매시장코드 | whsalCd    | 6   | 필수  | 110001   | 코드검색 > 도매시장코드 검색                 |
// //| 법인코드   | cmpCd      | 8   | 옵션  | 11000101 | 코드검색 > 법인코드 검색                   |
// //| 대분류코드  | largeCd    | 2   | 옵션  | 06       | 코드검색 > 표준품목코드 검색 > 코드 (1,2자리)    |
// //| 중분류코드  | midCd      | 2   | 옵션  | 01       | 코드검색 > 표준품목코드 검색 > 코드 (3,4자리)    |
// //| 소분류코드  | smallCd    | 2   | 옵션  | 01       | 코드검색 > 표준품목코드 검색 > 코드 (5,6자리)    |
// /// {@category Domain}
// /// TODO: Define fromJson and toJson factory constructor.

class AuctionPrice {
  final String saledate;
  final String whsalcd;
  final String whsalname;
  final String cmpcd;
  final String cmpname;
  final String large;
  final String largename;
  final String mid;
  final String midname;
  final String small;
  final String smallname;
  final String sancd;
  final String sanname;
  final String cost;
  final String qty;
  final String std;
  final String sbidtime;

  AuctionPrice({
    required this.saledate,
    required this.whsalcd,
    required this.whsalname,
    required this.cmpcd,
    required this.cmpname,
    required this.large,
    required this.largename,
    required this.mid,
    required this.midname,
    required this.small,
    required this.smallname,
    required this.sancd,
    required this.sanname,
    required this.cost,
    required this.qty,
    required this.std,
    required this.sbidtime,
  });

  DateTime get parsedDate => DateTime.parse(saledate); // '20240502' -> DateTime

  factory AuctionPrice.fromJson(Map<String, dynamic> json) {
    return AuctionPrice(
      saledate: json['SALEDATE'] ?? '',
      whsalcd: json['WHSALCD'] ?? '',
      whsalname: json['WHSALNAME'] ?? '',
      cmpcd: json['CMPCD'] ?? '',
      cmpname: json['CMPNAME'] ?? '',
      large: json['LARGE'] ?? '',
      largename: json['LARGENAME'] ?? '',
      mid: json['MID'] ?? '',
      midname: json['MIDNAME'] ?? '',
      small: json['SMALL'] ?? '',
      smallname: json['SMALLNAME'] ?? '',
      sancd: json['SANCD'] ?? '',
      sanname: json['SANNAME'] ?? '',
      cost: json['COST'] ?? '',
      qty: json['QTY'] ?? '',
      std: json['STD'] ?? '',
      sbidtime: json['SBIDTIME'] ?? '',
    );
  }
}
