import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../providers/momo_service.dart';
import '../providers/cart.dart';
import '../providers/resultcode.dart';
import '../providers/notification_service.dart';

bool _initialUriIsHandled = false;

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Notification',
//   description: "This channel is used for importance notification",
//   importance: Importance.max,
// );
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment_screen';

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  int? _resultCode = 1;

  StreamSubscription? _sub;
  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _handleInitialUri();
    _handleIncomingLinks();
    // _getResultCode();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? androidNotification = message.notification?.android;
    //   if (notification != null && androidNotification != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //             android: AndroidNotificationDetails(
    //               channel.id,
    //               channel.name,
    //               channelDescription: channel.description,
    //               color: Colors.blue,
    //               playSound: true,
    //               icon: '@mimap/ic_launcher',
    //             )));
    //   }
    // });
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

  int _getResultCode () {
    String url = _latestUri.toString();
    var splitter = url.split('&');
    var strResultCode = splitter.firstWhere((element) =>
        element.contains('resultCode'));
    var strResultCodeValue = strResultCode.split('=');
    var strValue = strResultCodeValue[1];
    return int.parse(strValue);
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          _latestUri = uri;
          _err = null;
          _resultCode = _getResultCode();
        });
        print('RESULT CODE: $_resultCode');
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
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

  // Future<void> _handleInitialUri() async {
  //   if (!_initialUriIsHandled) {
  //     _initialUriIsHandled = true;
  //     try {
  //       final uri = await getInitialUri();
  //       if (uri == null) {
  //         print('no initial uri');
  //       } else {
  //         print('got initial uri: $uri');
  //       }
  //       if (!mounted) return;
  //       setState(() => _initialUri = uri);
  //     } on PlatformException {
  //       // Platform messages may fail but we ignore the exception
  //       print('falied to get initial uri');
  //     } on FormatException catch (err) {
  //       if (!mounted) return;
  //       print('malformed initial uri');
  //       setState(() => _err = err);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    var code = Provider.of<ResultCode>(context);
    var launchMomo = Provider.of<MomoService>(context).launchUrl;
    var notification = Provider.of<NotificationService>(context, listen: false);
    WebViewController controller;
    return SafeArea(
      child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: launchMomo,
          onWebViewCreated: (WebViewController webViewController) async {
            controller = webViewController;
            print('CONTROLLER: ${controller.currentUrl()}');
          },
          navigationDelegate: (NavigationRequest request) async {
            if (request.url.startsWith('momo://?action=payWithAppToken')) {
              await _launchURL(request.url);
              return NavigationDecision.prevent;
            }
            code.resultCode = _resultCode!;
            print('RESULT CODE AFTER: $_resultCode');
            if (_resultCode == 0) {
              cart.clearCart();
              notification.sendNotification();
            } else {
              notification.sendErrorNotification();
            }
            Navigator.of(context).pop();
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
