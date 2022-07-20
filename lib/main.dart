import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
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
import './providers/momo_service.dart';
import './providers/resultcode.dart';
import './providers/notification_service.dart';
import './providers/orders_provider.dart';
import './providers/order_detail_provider.dart';
import './providers/invoice_service.dart';
import './providers/email_service.dart';

/*SCREENS*/
import './screens/auth_navigation_screen.dart';
import './screens/login_screen.dart';
import './screens/tabs_screen.dart';
import './screens/user_info_screen.dart';
import './screens/matches_screen.dart';
import './screens/cart_screen.dart';
import './screens/match_detail_screen.dart';
import './screens/payment_screen.dart';
import './screens/order_screen.dart';
import './screens/order_detail_screen.dart';

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
  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
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
              styleInformation: BigTextStyleInformation(''),
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => GoogleAuth()),
        ChangeNotifierProvider(create: (ctx) => MatchesProvider()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => TicketsProvider()),
        ChangeNotifierProvider(create: (ctx) => PageProvider()),
        ChangeNotifierProvider(create: (ctx) => MomoService()),
        ChangeNotifierProvider(create: (ctx) => ResultCode()),
        ChangeNotifierProvider(create: (ctx) => NotificationService()),
        ChangeNotifierProvider(create: (ctx) => OrdersProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderDetailProvider()),
        ChangeNotifierProvider(create: (ctx) => InvoiceProvider()),
        ChangeNotifierProvider(create: (ctx) => EmailService()),
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
          OrderScreen.routeName: (ctx) => OrderScreen(),
          OrderDetailScreen.routeName: (ctx) => OrderDetailScreen(),
        },
      ),
    );
  }
}
