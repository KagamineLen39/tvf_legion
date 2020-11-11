import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/Login&SignUp/loginPage.dart';
import 'package:tvf_legion/services/auth.dart';
import 'package:tvf_legion/services/helper.dart';


class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  AuthMethods authMethods = new AuthMethods();
  bool isLoading = false;

  String username,email,gender,birthDate;

  logOut(){
    dynamic result = authMethods.signOut();

    if(result == null){
      setState(() {
        isLoading = false;
      });
    }else{
      try{
        setState(() => isLoading = true);

        Helper.savedLoggedIn(false);
        Helper.getLogIn().then((value){
          print("User logged in: $value");
        });
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=> LoginPage()),
        );
      }catch(e){
        print(Helper.getLogIn().toString());
        print(e.toString());
      }
    }

  }

  @override
  void initState() {
    getUserInfoState();
    super.initState();
  }

  getUserInfoState(){
    Helper.getUserName().then((value) {
      setState(() {
        username = value;
      });

    });

    Helper.getUserEmail().then((value){
      setState(() {
        email=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    retrieveUsername() async{
      String userID;
      Helper.getUserId().then((value){
        userID = value;
        print(userID);
      });

      /*await Firestore.instance.collection("Users").getDocuments().then((value){
        print(value);
      });

      return username;*/
    }

    /*retrieveEmail()async{

      return email;

    }

    retrieveGender()async{

      return gender;
    }

    retrieveDoB()async{

      return birthDate;
    }*/

    /*final profilePic =CircleAvatar(
        radius: 80,
        backgroundImage: AssetImage(),
      );*/

     final userNameBar =  Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
            leading:Icon(
              Icons.perm_identity,
            ),
            title: Text("$username")
        ),
      );

      final genderBar= Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
            leading:Icon(
              Icons.person,
            ),
            title: Text("Gender")
        ),
      );

      final emailBar= Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
            leading:Icon(
              Icons.mail,
            ),
            title: Text("$email")
        ),
      );

      final  birthDateBar = Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
            leading:Icon(
              Icons.cake,
            ),
            title: Text("DoB")
        ),
      );

    final friendBar = ListTile(
              title : new Text ('Friends ',style: style.copyWith(fontWeight: FontWeight.bold),),
              onTap: (){
                retrieveUsername();



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
     /*final settingBar =ListTile(
              title : new Text ('Settings ',style: style.copyWith(fontWeight: FontWeight.bold),),
              onTap: (){

                *//*Navigator.push(
                context,
                new MaterialPageRoute(
                  builder:(BuildContext context) => new Friends())*//*}
          );*/
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
                  /*Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 5),

                    child: profilePic,
                  ),*/

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