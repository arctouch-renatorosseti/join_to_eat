import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/resources/constants.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/routes.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:sprintf/sprintf.dart';

class MapView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapsPlaces _googleMapsPlaces = GoogleMapsPlaces(apiKey: Constants.GOOGLE_MAPS_API_KEY);

  static const LatLng _center = const LatLng(-27.544805723209087, -48.5015320032835); // ArcTouch Floripa
  static const double _initialZoom = 16.5;
  static const String _typeFilter = "restaurant";

  static const Color _buttonBackgroundColor = Colors.lightGreen;

  static const num _searchRadius = 500;

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;
  Future<LatLng> _initialLocation;

  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _initialLocation = _getInitialLocation();
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void _onEventListButtonPressed() {
    Navigator.pushNamed(context, Routes.listEvents);
  }

  void _onAddEventButtonPressed() {
    Navigator.pushNamed(context, Routes.createEvent);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onCameraMoved() {
    _searchNearby();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _searchNearby();
  }

  void _searchNearby() async {
    var location = new Location(_lastMapPosition.latitude, _lastMapPosition.longitude);

    final result = await _googleMapsPlaces.searchNearbyWithRadius(location, _searchRadius, type: _typeFilter);

    if (result.status == "OK") {
      setState(() {
        result.results.forEach((item) {
          _markers.add(Marker(
            markerId: MarkerId(item.id),
            position: LatLng(item.geometry.location.lat, item.geometry.location.lng),
            infoWindow: InfoWindow(
                title: item.name,
                snippet: item.rating == null ? Strings.ratingAbsent : sprintf(Strings.rating, [item.rating.toInt()])),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          ));
        });
      });
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(Strings.nearbyPlaceError)));
      print("Error searching nearby places: ${result.errorMessage}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new FutureBuilder(
            future: _initialLocation,
            builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return new GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: snapshot.data,
                      zoom: _initialZoom,
                    ),
                    mapType: _currentMapType,
                    markers: _markers,
                    onCameraMove: _onCameraMove,
                    onCameraIdle: _onCameraMoved);
              }
              return new Container();
            }),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "eventListFloating",
                  onPressed: _onEventListButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: _buttonBackgroundColor,
                  child: const Icon(Icons.format_list_bulleted, size: 32.0),
                ),
                FloatingActionButton(
                  heroTag: "addEventFloating",
                  onPressed: _onAddEventButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: _buttonBackgroundColor,
                  child: const Icon(Icons.call, size: 32.0),
                ),
                FloatingActionButton(
                  heroTag: "mapTypeFloating",
                  onPressed: _onMapTypeButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: _buttonBackgroundColor,
                  child: const Icon(Icons.map, size: 32.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<LatLng> _getInitialLocation() async {
    var location = new LocationManager.Location();

    try {
      var currentLocation = await location.getLocation();

      return new LatLng(currentLocation.latitude, currentLocation.longitude);
    } catch (ex) {
      print("GetInitialLocation exception: ${ex.toString()}");
      return _center;
    }
  }
}
