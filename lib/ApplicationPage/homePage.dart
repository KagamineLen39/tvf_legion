import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
    Container(
      color: Colors.yellow,
    ),
    Container(
      color: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final homeNavigationBar = CurvedNavigationBar(
        index: _page,
        items: [
          new Icon(Icons.home, size: 30),
          new Icon(Icons.chat, size: 30),
          new Icon(Icons.person, size: 30),
          new Icon(Icons.location_on, size: 30)
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

    final menuBar = Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
              accountName: new Text('Test'),
              accountEmail: new Text('test@gmail.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: null),
              ),
          new ListTile(
            title : new Text ('Friends '),
            onTap: (){
              Navigator.of(context).pop();
              /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
                  ),
          new ListTile(
              title : new Text ('Terms & Services '),
              onTap: (){
                Navigator.of(context).pop();
                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          ),
          new ListTile(
              title : new Text ('Privacy '),
              onTap: (){
                Navigator.of(context).pop();
                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          ),
          new ListTile(
              title : new Text ('Settings '),
              onTap: (){
                Navigator.of(context).pop();
                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          ),
          new ListTile(
              title : new Text ('About Us '),
              onTap: (){
                Navigator.of(context).pop();
                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          ),
          new ListTile(
              title : new Text ('Logout '),
              onTap: (){
                Navigator.of(context).pop();
                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          ),
        ],
      ),
    );
    return Scaffold(
      bottomNavigationBar : homeNavigationBar,
      drawer: menuBar,
      appBar: AppBar(
        backgroundColor: Color(0xff01A0C7),
        centerTitle: true,
        title: Text(
          "???",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: PageView(
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