//| 서비스키   | serviceKey | -   | 필수  | -        | OpenApi 신청 > 로그인 > serviceKey 발급 |
//| ------ | ---------- | --- | --- | -------- | -------------------------------- |
//| API유형  | apiType    | 4   | 필수  | json     | xml 또는 json                      |
//| 페이지 번호 | pageNo     | -   | 필수  | 1        | 페이지 별 1000건 데이터 표출               |
//| 도매시장코드 | whsalCd    | 6   | 필수  | 110001   | 코드검색 > 도매시장코드 검색                 |
//| 법인코드   | cmpCd      | 8   | 옵션  | 11000101 | 코드검색 > 법인코드 검색                   |
//| 대분류코드  | largeCd    | 2   | 옵션  | 06       | 코드검색 > 표준품목코드 검색 > 코드 (1,2자리)    |
//| 중분류코드  | midCd      | 2   | 옵션  | 01       | 코드검색 > 표준품목코드 검색 > 코드 (3,4자리)    |
//| 소분류코드  | smallCd    | 2   | 옵션  | 01       | 코드검색 > 표준품목코드 검색 > 코드 (5,6자리)    |
/// {@category Domain}
/// TODO: Define fromJson and toJson factory constructor.
class RealTimeAuctionInfoItem {
  RealTimeAuctionInfoItem({
    this.rn, //
    this.saleDate, // 경락 일자
    this.whsalCd, // 도매시장 코드
    this.whsalName, // 도매시장명
    this.cmpCd, // 법인 코드
    this.cmpName, // 법인명
    this.large, // 대분류
    this.largeName, // 대분류명
    this.mid, // 중분류
    this.midName, // 중분류명
    this.small, // 소분류
    this.smallName, // 소분류명
    this.sanCd, // 산지코드
    this.sanName, // 산지명
    this.price, // 경락가
    this.qty, // 물량
    this.std, // 규격(단량, 단위, 포장)
    this.sbidtime, // 경락일시
  });
  final int? rn; //
  final DateTime? saleDate; // 경락 일자
  final int? whsalCd; // 도매시장 코드
  final String? whsalName; // 도매시장명
  final int? cmpCd; // 법인 코드
  final String? cmpName; // 법인명
  final int? large; // 대분류
  final String? largeName; // 대분류명
  final int? mid; // 중분류
  final String? midName; // 중분류명
  final int? small; // 소분류
  final String? smallName; // 소분류명
  final int? sanCd; // 산지코드
  final String? sanName; // 산지명
  final int? price; // 경락가
  final double? qty; // 물량
  final String? std; // 규격(단량; 단위; 포장)
  final DateTime? sbidtime; // 경락일시
}

/// TODO: Define fromJson and toJson factory constructor.
class RealTimeAuctionInfoResponse {
  RealTimeAuctionInfoResponse({
    required int? totalCount, // 전체 데이터 건수
    required int? pageNo, // 호출 페이지 번호
    required int? dataCount, // 호출 페이지 데이터 건수
    required List<RealTimeAuctionInfoItem>? data, // data: [],
    required String? statusText,
    required String? errorCode,
    required String? status,
    required String? errorText, // errorText: "",
  });
  int? totalCount; // 전체 데이터 건수
  int? pageNo; // 호출 페이지 번호
  int? dataCount; // 호출 페이지 데이터 건수
  List<RealTimeAuctionInfoItem>? data; // data: [];
  String? statusText;
  String? errorCode;
  String? status;
  String? errorText; // errorText: "",
}
