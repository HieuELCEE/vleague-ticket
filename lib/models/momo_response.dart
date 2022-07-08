class MomoResponse {
  String partnerCode;
  String requestId;
  String orderId;
  int amount;
  int responseTime;
  String message;
  int resultCode;
  String payUrl;


  // String deeplink;
  // String qrCodeUrl;

  MomoResponse({
    required this.partnerCode,
    required this.requestId,
    required this.orderId,
    required this.amount,
    required this.responseTime,
    required this.message,
    required this.resultCode,
    required this.payUrl,
    // required this.deeplink,
    // required this.qrCodeUrl,
  });

  factory MomoResponse.fromJson(Map<String, dynamic> json) => MomoResponse(
        partnerCode: json['partnerCode'],
        orderId: json['orderId'],
        requestId: json['requestId'],
        amount: json['amount'],
        responseTime: json['responseTime'],
        message: json['message'],
        resultCode: json['resultCode'],
        payUrl: json['payUrl'],
        // deeplink: json['deeplink'],
        // qrCodeUrl: json['qrCodeUrl'],
      );
}
