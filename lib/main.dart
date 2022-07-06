import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

/*SETUP*/
import 'firebase_options.dart';

/*PROVIDERS*/
import './providers/google_auth.dart';
import './providers/matches_provider.dart';
import './providers/cart.dart';
import './providers/tickets_provider.dart';
import './providers/page.dart';
import './providers/orders.dart';

/*SCREENS*/
import './screens/auth_navigation_screen.dart';
import './screens/login_screen.dart';
import './screens/tabs_screen.dart';
import './screens/user_info_screen.dart';
import './screens/matches_screen.dart';
import './screens/cart_screen.dart';
import './screens/match_detail_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        },
      ),
    );
  }
}
