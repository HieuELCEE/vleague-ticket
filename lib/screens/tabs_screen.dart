import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

/*PROVIDERS*/
import '../providers/google_auth.dart';
import '../providers/cart.dart';
import '../providers/page.dart';

/*SCREENS*/
import './user_info_screen.dart';
import './categories_screen.dart';
import './order_screen.dart';
import './cart_screen.dart';

/*WIDGETS*/
import '../widgets/badge.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs_screen';
  const TabsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, dynamic>> _tabs = [
    {
      'tab': CategoriesScreen(),
      'title': 'E-Ticket',
    },
    {
      'tab': CartScreen(),
      'title': 'Cart',
    },
    {
      'tab': OrderScreen(),
      'title': 'Orders',
    },
  ];

  int _selectedPageIndex = 0;
  String _selectMenuItem = '';
  bool _isChosen1 = false;
  bool _isChosen2 = false;
  bool _isChosen3 = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isChosen1 = true;
      });
      _selectedPageIndex = Provider.of<PageProvider>(context).currPage;
      if(_selectedPageIndex == 1) {
        setState(() {
          _isChosen1 = false;
          _isChosen2 = true;
          _isChosen3 = false;
        });
      } else if (_selectedPageIndex == 2) {
        setState(() {
          _isChosen1 = false;
          _isChosen2 = false;
          _isChosen3 = true;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectTab(int index) {
    setState(() {
      _selectedPageIndex = index;
      if (index == 0) {
        _isChosen1 = true;
        _isChosen2 = false;
        _isChosen3 = false;
      } else if (index == 1) {
        _isChosen1 = false;
        _isChosen2 = true;
        _isChosen3 = false;
      } else {
        _isChosen1 = false;
        _isChosen2 = false;
        _isChosen3 = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final provider = Provider.of<Cart>(context, listen: true);
    final initPage = Provider.of<PageProvider>(context, listen: false);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              _tabs[_selectedPageIndex]['title'],
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  setState(() {
                    _selectMenuItem = value as String;
                  });
                },
                child: CachedNetworkImage(
                  imageUrl: '${user.photoURL}',
                  placeholder: (context, url) => Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 20,
                  ),
                ),
                itemBuilder: (cxt) => [
                  PopupMenuItem(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(cxt)
                            .pushReplacementNamed(UserInfoScreen.routeName);
                      },
                      leading: Icon(Icons.edit),
                      title: Text('View Profile'),
                    ),
                    value: '1',
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      onTap: () async {
                        provider.clearCart();
                        initPage.currPage = 0;
                        await Provider.of<GoogleAuth>(context, listen: false)
                            .logout();
                        Navigator.of(context).pop();
                      },
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Logout'),
                    ),
                    value: '2',
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
            ],
          ),
          body: _tabs[_selectedPageIndex]['tab'],
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectTab,
            backgroundColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.white,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            currentIndex: _selectedPageIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Container(
                    child: _isChosen1 == true
                        ? Icon(FontAwesomeIcons.solidCompass)
                        : Icon(FontAwesomeIcons.compass),
                    height: 35,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Badge(
                    Container(
                      child: _isChosen2 == true
                          ? Icon(Icons.shopping_cart)
                          : Icon(Icons.shopping_cart_outlined),
                      width: 50,
                      height: 35,
                    ),
                    provider.itemCount.toString(),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: 'Your Cart'),
              BottomNavigationBarItem(
                  icon: Container(
                    child: _isChosen3 == true
                        ? Icon(Icons.payments)
                        : Icon(Icons.payments_outlined),
                    height: 35,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: 'Orders'),
            ],
          ),
        ),
      ],
    );
  }
}
