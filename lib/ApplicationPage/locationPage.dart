import 'dart:async';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class LocationPage extends StatefulWidget {

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {

    return Container(
         child: FireMap(),
    );
  }

}

class FireMap extends StatefulWidget {
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newMapController;
  build(context){
    return Stack(children: [

      GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationButtonEnabled: true,
        mapType: MapType.hybrid,
        compassEnabled: true,
      ),

    ],);
  }

  _onMapCreated(GoogleMapController control){
    _googleMapController.complete(control);
    newMapController = control;
  }

}
