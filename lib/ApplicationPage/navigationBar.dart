import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/homePage.dart';
import 'package:tvf_legion/ApplicationPage/locationPage.dart';
import 'package:tvf_legion/ApplicationPage/profilePage.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  int _page = 0;

  PageController _pageController = PageController(
    initialPage: 0,
  );

  List<Widget> _tabBar = [
    HomePage(),
    Container(
      color: Colors.blue,
    ),
    LocationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final homeNavigationBar = CurvedNavigationBar(
        index: _page,
        items: [
          new Icon(Icons.home, size: 30),
          new Icon(Icons.chat, size: 30),
          new Icon(Icons.location_on, size: 30),
          new Icon(Icons.person, size: 30)
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.red,
        backgroundColor: Color(0xff01A0C7),
        onTap: (index) {
          _page = index;
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
          setState(() {});
        });

    return Scaffold(
      bottomNavigationBar: homeNavigationBar,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: _tabBar,
      ),
    );
  }
}