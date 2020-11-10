import 'package:flutter/cupertino.dart';
import 'package:tvf_legion/services/auth.dart';

class Provider extends InheritedWidget{
  final AuthMethods authMethods;
  final db;
  final colors;

  Provider({Key key,Widget child,this.authMethods,this.db,this.colors}):super(key:key,child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget){
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>());
}