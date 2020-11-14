import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf_legion/ApplicationPage/homePage.dart';
import 'package:tvf_legion/services/database.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool isLoading =false;
  TextEditingController searchEditingController = new TextEditingController();
  Database databaseMethods = new Database();
  QuerySnapshot searchResultSnapshot;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByUsername(searchEditingController.text.trimRight()).then((snapshot){
        searchResultSnapshot = snapshot;
          print("$snapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }else{
      setState(() {
        isLoading = false;
        haveUserSearched = false;
      });
    }
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot.documents.length,
        itemBuilder: (context, index){
          return peerList(
            searchResultSnapshot.documents[index].data["username"],
            searchResultSnapshot.documents[index].data["email"],
          );
        }
    ):
    Container(
      padding: EdgeInsets.all(25),
      child: Text(
        "No user found",
        style: style.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black38,
        ),
      ),
    );
  }

  Widget peerList(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              //addFriend(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.lightBlue[500],
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Add",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final backButton = IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: (){
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) =>HomePage()),
              (Route<dynamic> route)=>false,
        );
      },
    );

    final searchLabel = TextField(
      controller: searchEditingController,
      cursorColor: Colors.white,
      style: style.copyWith(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        border:InputBorder.none,
        hintText: 'Search Username',
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),

    );

    final searchBar = Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        children:<Widget>[
          Expanded(
            child: searchLabel,
          ),
          SizedBox(
            child: Container(
              height: 45,
              width: 45,
              child: IconButton(
                icon: Icon(
                    Icons.search,
                    color: Colors.white
                ),
                onPressed: initiateSearch,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                color: Colors.lightBlue[500],
              ),
            ),

          ),
        ] ,
      ),
    );
    return Scaffold(
      body: Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10,25,10,5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    backButton,
                    SizedBox(height: 5),
                    Column(
                      children: <Widget>[
                        searchBar,
                        userList(),
                      ],
                    ),
                  ],
                )),
          ),
    );
  }
}