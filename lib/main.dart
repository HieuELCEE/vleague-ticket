import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'web_url_protocol.dart'
    if (dart.library.io) 'package:url_protocol/url_protocol.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/*SETUP*/
import 'firebase_options.dart';

/*PROVIDERS*/
import './providers/google_auth.dart';
import './providers/matches_provider.dart';
import './providers/cart.dart';
import './providers/tickets_provider.dart';
import './providers/page.dart';
import './providers/orders.dart';
import './providers/momo_service.dart';
import './providers/resultcode.dart';
import './providers/notification_service.dart';

/*SCREENS*/
import './screens/auth_navigation_screen.dart';
import './screens/login_screen.dart';
import './screens/tabs_screen.dart';
import './screens/user_info_screen.dart';
import './screens/matches_screen.dart';
import './screens/cart_screen.dart';
import './screens/match_detail_screen.dart';
import './screens/payment_screen.dart';

bool _initialUriIsHandled = false;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notification',
  description: "This channel is used for importance notification",
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A background messsage just show up: ${message.messageId}');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('@mipmap/ic_launcher');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Uri? _initialUri;
  // Uri? _latestUri;
  // Object? _err;
  // int? _resultCode;

  // StreamSubscription? _sub;
  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _handleIncomingLinks();
    // _handleInitialUri();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        print('ARE YOU THERE');
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
                  icon: "@mipmap/ic_launcher",
            )));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new messageopen app event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("${notification.title}"),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("${notification.body}")],
                  ),
                ),
              );
            });
      }
    });

  }



  // @override
  // void dispose() {
  //   _sub?.cancel();
  //   super.dispose();
  // }
  //
  // void _handleIncomingLinks() {
  //   if (!kIsWeb) {
  //     _sub = uriLinkStream.listen((Uri? uri) {
  //       if (!mounted) return;
  //       print('got uri: $uri');
  //       setState(() {
  //         _latestUri = uri;
  //         _err = null;
  //       });
  //     }, onError: (Object err) {
  //       if (!mounted) return;
  //       print('got err: $err');
  //       setState(() {
  //         _latestUri = null;
  //         if (err is FormatException) {
  //           _err = err;
  //         } else {
  //           _err = null;
  //         }
  //       });
  //     });
  //   }
  // }
  //
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => GoogleAuth()),
        ChangeNotifierProvider(create: (ctx) => MatchesProvider()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => TicketsProvider()),
        ChangeNotifierProvider(create: (ctx) => PageProvider()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
        ChangeNotifierProvider(create: (ctx) => MomoService()),
        ChangeNotifierProvider(create: (ctx) => ResultCode()),
        ChangeNotifierProvider(create: (ctx) => NotificationService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vleague-Ticket',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            accentColor: Colors.black87,
          ),
          canvasColor: Colors.white,
        ),
        home: AuthNavigationScreen(),
        routes: {
          UserInfoScreen.routeName: (ctx) => UserInfoScreen(),
          MatchesScreen.routeName: (ctx) => MatchesScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          MatchDetailScreen.routeName: (ctx) => MatchDetailScreen(),
          TabsScreen.routeName: (ctx) => TabsScreen(),
          PaymentScreen.routeName: (ctx) => PaymentScreen(),
        },
      ),
    );
  }
}
