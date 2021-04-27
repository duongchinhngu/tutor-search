import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

CameraPosition __initalLocation = CameraPosition(
    target: LatLng(10.7915178, 106.7271422),
    zoom: 14.4746,
  );
  GoogleMapController mapController;

  Position _currentPosition;
  String _currentAddress;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final destinationAddressFocusNode = FocusNode();



  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

    // Method for retrieving the current location
  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {

      return await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
   _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

       return _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        // startAddressController.text = _currentAddress;
        // _startAddress = _currentAddress;
    } catch (e) {
      print(e);
    }
  }