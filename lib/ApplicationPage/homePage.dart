import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
<<<<<<< HEAD
import 'package:tvf_legion/ApplicationPage/locationPage.dart';
=======
>>>>>>> parent of 88b2cac... HomePage
import 'package:tvf_legion/ApplicationPage/profilePage.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  int _page = 0;

  PageController _pageController = PageController(
    initialPage: 0,
  );

  List<Widget> _tabBar = [
    Container(
      color: Colors.white,
    ),
    Container(
      color: Colors.blue,
    ),
<<<<<<< HEAD
    LocationPage(),

=======
    Container(
      color: Colors.green,
    ),
>>>>>>> parent of 88b2cac... HomePage
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
        buttonBackgroundColor: Colors. red,
        backgroundColor: Color(0xff01A0C7),
        onTap: (index){
          _page = index;
          _pageController.animateToPage(index, duration:Duration(milliseconds: 500), curve: Curves.easeIn, );
          setState(() {});
        }
    );


    return Scaffold(
      bottomNavigationBar : homeNavigationBar,
      appBar: AppBar(
        backgroundColor: Color(0xff01A0C7),
        centerTitle: true,
        title: Text(
<<<<<<< HEAD
          "Home Page",
=======
          "???",
>>>>>>> parent of 88b2cac... HomePage
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: PageView(
<<<<<<< HEAD
        physics: NeverScrollableScrollPhysics(),
=======
>>>>>>> parent of 88b2cac... HomePage
        controller: _pageController,
        onPageChanged: (index){
          setState(() {
            _page = index;
          });
        },
        children: _tabBar ,
      ),
    );
  }

}