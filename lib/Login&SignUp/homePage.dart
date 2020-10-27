import 'package:flutter/material.dart';
// import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
// import 'package:circular_bottom_navigation/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final homeNavigationBar = BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.onSurface,
      unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
      selectedLabelStyle: textTheme.caption,
      unselectedLabelStyle: textTheme.caption,
      onTap: (newIndex) => setState((){_currentIndex = newIndex;}),
      items: [
        new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Home")
        ),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.chat),
            title: new Text("ChiChat")
        ),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text("Profile")
        ),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.location_city),
            title: new Text("Location")
        ),
        new BottomNavigationBarItem(
            icon: new Icon(Icons.menu),
            title: new Text("Menu")
        ),
      ],

    );
    return Scaffold(
      bottomNavigationBar: homeNavigationBar,
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

      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[




                  ],
                )),
          ),
        ),
      ),
    );
  }
}
