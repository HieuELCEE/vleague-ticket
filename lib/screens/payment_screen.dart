import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:uni_links/uni_links.dart';

import '../providers/momo_service.dart';
import '../providers/cart.dart';
import '../providers/resultcode.dart';
import '../providers/notification_service.dart';
import '../providers/invoice_service.dart';
import '../providers/page.dart';
import '../providers/email_service.dart';
import '../screens/order_screen.dart';
import '../screens/tabs_screen.dart';
import '../models/cart_info.dart';

bool _initialUriIsHandled = false;

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment_screen';

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  Uri? _latestUri;
  Object? _err;
  int? _resultCode = 1;

  StreamSubscription? _sub;
  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleIncomingLinks();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  int _getResultCode() {
    String url = _latestUri.toString();
    var splitter = url.split('&');
    var strResultCode =
        splitter.firstWhere((element) => element.contains('resultCode'));
    var strResultCodeValue = strResultCode.split('=');
    var strValue = strResultCodeValue[1];
    return int.parse(strValue);
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        setState(() {
          _latestUri = uri;
          _err = null;
          _resultCode = _getResultCode();
        });
      }, onError: (Object err) {
        if (!mounted) return;
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context, listen: true);
    var code = Provider.of<ResultCode>(context);
    var launchMomo = Provider.of<MomoService>(context).launchUrl;
    var page = Provider.of<PageProvider>(context);
    var notification = Provider.of<NotificationService>(context, listen: false);
    var email = Provider.of<EmailService>(context, listen: false);
    var invoiceService = Provider.of<InvoiceProvider>(context, listen: false);
    WebViewController controller;
    return SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: launchMomo,
        onWebViewCreated: (WebViewController webViewController) async {
          controller = webViewController;
        },
        navigationDelegate: (NavigationRequest request) async {
          if (request.url.startsWith('momo://?action=payWithAppToken')) {
            await _launchURL(request.url);
            return NavigationDecision.prevent;
          }
          code.resultCode = _resultCode!;
          if (_resultCode == 0) {
            List<CartInfo> cartInfo = [];
            cart.items.forEach((key, value) {cartInfo.add(new CartInfo(quantity: value.quantity, ticketId: int.parse(key)));});
            double totalAmount = cart.total;
            cart.clearCart();
            page.currPage = 2;
            invoiceService.addInvoice(cartInfo, totalAmount);
            notification.sendNotification();
            email.sendEmail();
            Navigator.of(context).popAndPushNamed(TabsScreen.routeName, arguments: {'cartPage': 2});
          } else {
            notification.sendErrorNotification();
            Navigator.of(context).pop();
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
