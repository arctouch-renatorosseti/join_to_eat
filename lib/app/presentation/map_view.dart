import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join_to_eat/app/resources/constants.dart';
import 'package:join_to_eat/app/resources/images.dart';
import 'package:join_to_eat/app/resources/strings.dart';
import 'package:join_to_eat/app/utils/ScalerHelper.dart';
import 'package:join_to_eat/app/utils/routes.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:sprintf/sprintf.dart';

class MapView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapsPlaces _googleMapsPlaces = GoogleMapsPlaces(apiKey: Constants.GOOGLE_MAPS_API_KEY);
  GoogleMapController _controller;

  static const double _initialZoom = 16.5;
  static const String _typeFilter = "restaurant";

  static const num _searchRadius = 500;

  Set<Marker> _markers = {};

  LatLng _center = const LatLng(-27.544805723209087, -48.5015320032835); // ArcTouch Floripa
  LatLng _lastMapPosition;

  MapType _currentMapType = MapType.normal;

  BitmapDescriptor _pinImage;

  @override
  void initState() {
    super.initState();
    _lastMapPosition = _center;
    _setCurrentLocation();
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void _onMeetingListButtonPressed() {
    Navigator.pushNamed(context, Routes.listMeetings);
  }

  void _onAddQuizButtonPressed() {
    Navigator.pushNamed(context, Routes.createQuiz);
  }

  void _onPlaceSelected(PlacesSearchResult place) {
    Navigator.pushNamed(context, Routes.createMeeting, arguments: place);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onCameraMoved() {
    _searchNearby();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _moveCamera(_center);
    _searchNearby();
  }

  void _searchNearby() async {
    var location = new Location(_lastMapPosition.latitude, _lastMapPosition.longitude);

    final result = await _googleMapsPlaces.searchNearbyWithRadius(location, _searchRadius, type: _typeFilter);

    if (result.status == "OK") {
      setState(() {
        Set<Marker> newMarkers = {};

        result.results.forEach((item) {
          newMarkers.add(Marker(
            markerId: MarkerId(item.id),
            position: LatLng(item.geometry.location.lat, item.geometry.location.lng),
            infoWindow: InfoWindow(
                title: item.name,
                snippet: item.rating == null ? Strings.ratingAbsent : sprintf(Strings.rating, [item.rating.toInt()]),
                onTap: () {
                  _onPlaceSelected(item);
                }),
            icon: _pinImage,
          ));
        });

        _markers = newMarkers;
      });
    } else {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(Strings.nearbyPlaceError)));
      print("Error searching nearby places: ${result.errorMessage}");
    }
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerIcon(context);

    return Stack(
      children: <Widget>[
        GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(target: _center, zoom: _initialZoom - 20.0),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraMoved),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                    width: ScalerHelper.getScaleWidth(56.0),
                    height: ScalerHelper.getScaleHeight(56.0),
                    child: FloatingActionButton(
                        heroTag: "meetingListFloating",
                        onPressed: _onMeetingListButtonPressed,
                        backgroundColor: Colors.transparent,
                        child: new ConstrainedBox(
                          constraints: new BoxConstraints.expand(),
                          child: new Image(image: AssetImage(Images.FLOATING_ALERTS_LIST)),
                        ))),
                SizedBox(
                    width: ScalerHelper.getScaleWidth(72.0),
                    height: ScalerHelper.getScaleHeight(72.0),
                    child: FloatingActionButton(
                        heroTag: "addQuizFloating",
                        onPressed: _onAddQuizButtonPressed,
                        backgroundColor: Colors.transparent,
                        child: new ConstrainedBox(
                          constraints: new BoxConstraints.expand(),
                          child: new Image(image: AssetImage(Images.FLOATING_CALL_PEOPLE)),
                        ))),
                SizedBox(
                    width: ScalerHelper.getScaleWidth(56.0),
                    height: ScalerHelper.getScaleHeight(56.0),
                    child: FloatingActionButton(
                        heroTag: "mapTypeFloating",
                        onPressed: _onMapTypeButtonPressed,
                        backgroundColor: Colors.transparent,
                        child: new ConstrainedBox(
                          constraints: new BoxConstraints.expand(),
                          child: new Image(image: AssetImage(Images.FLOATING_AROUND_ME)),
                        ))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future _setCurrentLocation() async {
    try {
      var location = new LocationManager.Location();
      var currentLocation = await location.getLocation();

      _center = new LatLng(currentLocation.latitude, currentLocation.longitude);
    } catch (ex) {
      print("SetCurrentLocation exception: ${ex.toString()}");
    }

    _moveCamera(_center);
  }

  void _moveCamera(LatLng location, {double zoom = _initialZoom}) {
    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: zoom)));
    }
  }

  Future<void> _createMarkerIcon(BuildContext context) async {
    if (this._pinImage == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: ScalerHelper.getScaledSize(32.0, 40.0));

      BitmapDescriptor.fromAssetImage(imageConfiguration, Images.IMAGE_MAP_PIN).then((value) {
        setState(() {
          this._pinImage = value;
        });
      });
    }
  }
}
