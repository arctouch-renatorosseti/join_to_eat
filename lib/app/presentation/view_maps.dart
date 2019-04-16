import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_to_eat/app/meeting/meeting_bloc.dart';
import 'package:join_to_eat/app/meeting/meeting_event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewMaps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapBody();
}

class _MapBody extends State<ViewMaps> {

  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController mapController;

  static const LatLng _center = const LatLng(-27.5949, -48.5482);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  Map<String, double> userLocation;

//   _getLocation() async {
//    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    return position;
//  }

  @override
  void initState() {
    print("Init state");
    _getLocation();
    super.initState();
  }

   _getLocation() async {
    var location = new Location();
    var currentLocation;
    try {
      currentLocation = await location.getLocation();

      print("locationLatitude: ${currentLocation["latitude"]}");
      print("locationLongitude: ${currentLocation["longitude"]}");
      setState(
              () {}); //rebuild the widget after getting the current location of the user
    } on Exception {
      currentLocation = null;
    }
    return currentLocation;
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget> [
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    SizedBox(height: 16.0),
                    FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.add_location, size: 36.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}