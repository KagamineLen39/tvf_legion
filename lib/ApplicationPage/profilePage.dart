import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/loginPage.dart';
import 'package:tvf_legion/services/auth.dart';
import 'package:tvf_legion/modal/Constants.dart';
import 'package:tvf_legion/services/database.dart';
import 'package:tvf_legion/services/helper.dart';


class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  AuthMethods _authMethods = new AuthMethods();
  bool isLoading = false;

  Database _database = new Database();

  String username;

  @override
  void initState(){
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.userName = await Helper.getUserName();
    _database.getUserbyUserName(Constants.userName).then((snapshots){
      setState(() {
        username = snapshots;
      });
    });
  }


  logOut(){
    setState(() => isLoading = true);
    _authMethods.signOut();
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context)=> LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profilePic =CircleAvatar(
        radius: 80,
        backgroundImage: AssetImage(''),
      );

     final userNameBar =  Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
            leading:Icon(
              Icons.perm_identity,
            ),
            title: Text('$username')
        ),
      );

      final genderBar= Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
            leading:Icon(
              Icons.person,
            ),
            title: Text('Gender',)
        ),
      );

      final emailBar= Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
            leading:Icon(
              Icons.mail,
            ),
            title: Text('Email',)
        ),
      );

      final  birthDateBar = Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
            leading:Icon(
              Icons.cake,
            ),
            title: Text('Birth Date',)
        ),
      );

    final friendBar = ListTile(
              title : new Text ('Friends ',style: style.copyWith(fontWeight: FontWeight.bold),),
              onTap: (){

                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          );
    final termServicesBar= ListTile(
              title : new Text ('Terms & Services ',style: style.copyWith(fontWeight: FontWeight.bold),),
              onTap: (){

                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          );
    final privacyBar= ListTile(
              title : new Text ('Privacy ',style: style.copyWith(fontWeight: FontWeight.bold),),
              onTap: (){

                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          );
     final settingBar =ListTile(
              title : new Text ('Settings ',style: style.copyWith(fontWeight: FontWeight.bold),),
              onTap: (){

                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          );
     final aboutUsBar =ListTile(
              title : new Text ('About Us ',style: style.copyWith(fontWeight: FontWeight.bold),),
              onTap: (){

                /*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*/}
          );
     final logOutBar = Container(
          decoration: new BoxDecoration(
            color: Colors.red,
          ),
          child:new ListTile(
              title : new Text ('Logout ',style: style.copyWith(fontWeight: FontWeight.bold,color: Colors.white),),
              onTap: (){
                logOut();
              }
          ),
          );


    return Scaffold(
      body: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Center(
        child: Container(
          color: Colors.white,
            child: ListView(

              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                children:<Widget>[
                  profilePic,
                  userNameBar,
                  genderBar,
                  emailBar,
                  birthDateBar,
                  friendBar,
                  termServicesBar,
                  privacyBar,
                  aboutUsBar,
                  logOutBar,
                ],
                )
            ),
          ),
    );
  }

}