import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage>
    with TickerProviderStateMixin {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FireMap(),
      ),
    );
  }
}

class FireMap extends StatefulWidget {
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newMapController;

  Position currentPosition;

  var geoLocator = Geolocator();

  CameraPosition cameraPosition;

  void locateUser() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPos = LatLng(position.latitude, position.longitude);

    cameraPosition = new CameraPosition(target: latLngPos, zoom: 15);

    newMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  build(context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(5.4164, 100.3327), zoom: 15),
          onMapCreated: _onMapCreated,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
        ),
      ],
    );
  }

  mapDesign() {
    getMapJson("assets/Json Files/nightMap.json").then(setMapDesign);
  }

  Future<String> getMapJson(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapDesign(String mapStyle) {
    newMapController.setMapStyle(mapStyle);
  }

  _onMapCreated(GoogleMapController control) {
    mapDesign();
    _googleMapController.complete(control);
    newMapController = control;
    locateUser();
  }
}
