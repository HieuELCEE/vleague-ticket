import 'dart:convert';
import 'dart:ffi';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/momo_response.dart';

class MomoService with ChangeNotifier {
  final String PARTNER_CODE = 'MOMOWBVW20220621';
  final String SCHEME_ID = 'momowbvw20220621';
  final String ACCESS_KEY = 'RX2kPT9vQvpoUvOq';
  final String BASE_URL = 'https://test-payment.momo.vn';
  final String REDIRECT_URL = 'http://vleague-ticket.firebaseapp.com';
  final String IPN_URL = 'http://localhost:8081/api/v1/payment/momo';
  final String REQUEST_TYPE = 'captureWallet';
  final String EXTRA_DATA = 'eyJ1c2VybmFtZSI6ImhpZXVlbGNlZSJ9';
  final String LANG = 'en';
  final String SECRET_KEY = '5ELE2oMKalu0DpStXbLgcmjktnBKkZqd';

  var _launchUrl;

  String get launchUrl {
    return _launchUrl;
  }

  String generateSignature({
    required int amount,
    required String orderId,
    required String orderInfo,
    required String requestId,
  }) {
    var signature = '';
    var rawSignature =
        'accessKey=' + ACCESS_KEY + '&amount=' + amount.toString() + '&extraData=' + EXTRA_DATA + '&ipnUrl=' + IPN_URL + '&orderId=' + orderId + '&orderInfo=' + orderInfo + '&partnerCode=' + PARTNER_CODE + '&redirectUrl=' + REDIRECT_URL + '&requestId=' + requestId + '&requestType=' + REQUEST_TYPE;
    var key = utf8.encode(SECRET_KEY);
    var signatureInBytes = utf8.encode(rawSignature);
    var hmacSha256 = Hmac(sha256, key);
    signature = hmacSha256.convert(signatureInBytes).toString();
    print(signature);
    return signature;
  }

  Future<int> createRequest(int amount, String orderInfo) async {
    var uuid = Uuid();
    var requestId = uuid.v1();
    var orderId = uuid.v4();
    var signature = generateSignature(
        amount: amount,
        orderId: orderId,
        orderInfo: orderInfo,
        requestId: requestId);
    var url = Uri.parse('https://test-payment.momo.vn/v2/gateway/api/create');
    var response = await http.post(
      url,
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: jsonEncode(<String, dynamic>{
        'partnerCode': PARTNER_CODE,
        'requestType': REQUEST_TYPE,
        'ipnUrl': IPN_URL,
        'requestId': requestId,
        'redirectUrl': REDIRECT_URL,
        'orderId': orderId,
        'orderInfo': orderInfo,
        'amount': amount,
        'lang': LANG,
        'extraData': EXTRA_DATA,
        'signature': signature,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      print('REQUEST SUCCESS');
      MomoResponse momoResponse = MomoResponse.fromJson(json.decode(response.body));
      _launchUrl = momoResponse.payUrl;
      notifyListeners();
    } else {
      print('ERROR');
      print(response.body);
    }
    return response.statusCode;
  }
}
