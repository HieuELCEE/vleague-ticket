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

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  int? _resultCode;

  StreamSubscription? _sub;
  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _handleIncomingLinks();
    // _handleInitialUri();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }



  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          _latestUri = uri;
          _err = null;
        });

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

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => _err = err);
      }
    }
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
        ChangeNotifierProvider(create: (ctx) => Orders()),
        ChangeNotifierProvider(create: (ctx) => MomoService()),
        ChangeNotifierProvider(create: (ctx) => ResultCode()),
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
