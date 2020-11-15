import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final List<String>room=["Apple", "Food", "Product"];
  @override
  Widget build(BuildContext context) {
    final searchTab = TextField(
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
        ));
    final popularLabel = Text("Popular room",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 15.0,
          color: Colors.grey,

        )
    );
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              children: <Widget>[
                searchTab,
                SizedBox(height: 20),
                popularLabel,
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, int index) => ListRoomItem(this.room[index]),
                  itemCount: this.room.length,
                ),
              ],

            )),
      ),
    );
  }
}
// ignore: must_be_immutable
class ListRoomItem extends StatelessWidget{
  String roomName;

  ListRoomItem(this.roomName);
  @override
  Widget build(BuildContext context){
    return new Card(
      elevation: 7.0,
      child: new Container(
        margin: EdgeInsets.all(9.0),
        padding: EdgeInsets.all(6.0),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              child: new Text(roomName[0]),
            ),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Text(roomName, style: TextStyle(fontSize: 20.0),)
          ],
        ),
      ),
    );
  }
}