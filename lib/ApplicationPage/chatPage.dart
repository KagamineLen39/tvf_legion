import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvf_legion/services/database.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController searchController = new TextEditingController();
  Database databaseMethods = new Database();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;
  bool friendRequestPage = false;
  int index =0;
  SharedPreferences prefs;

  final List<String> chatPageOptions = ["Chats","Friend Requests"];

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByUsername(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
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
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              //sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
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

    searchBar(){
      return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: searchController,
                        style: style.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                      ),

                      cursorColor: Colors.white,
                      maxLines: 1,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.lightBlue[300],
                        hintText: "Search Username",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: BorderSide.none
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 5),

                  SizedBox(
                    height: 50,
                      width:50,
                      child:GestureDetector(
                        onTap: (){
                          initiateSearch();
                        },
                        child: Container(
                          height:40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(Icons.search,
                          color: Colors.white
                          ),
                        ),
                      )
                    ),
                ],
              ),
            ),
            
            userList()
          ],
        ),
      );
    }

    pageChanger(){
      return Container(
        height: 75,
        color: Colors.lightBlue[200],
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: chatPageOptions.length,
          itemBuilder: (BuildContext context,int _index){
              return Container(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      index = _index;
                    });

                    if(index == 0){
                      setState(() {
                        friendRequestPage = true;
                      });
                    }else{
                      setState(() {
                        friendRequestPage = false;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:55,
                        vertical:25
                    ),
                    child: Text(chatPageOptions[_index],
                    style: style.copyWith(
                      color: _index == index? Colors.white: Colors.white54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ))
                  ),
                ),
              );
          },

        ),
      );
    }

    contentPages(){
     return Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )
          ),

          child:Column(
            children: <Widget>[
              Container(

              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
          backgroundColor: Colors.lightBlue[600],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            pageChanger(),
            contentPages(),
          ],
        ),
      ),
    );
  }



}