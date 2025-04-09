import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPostionOfUser;
  String? mapStyle;

  @override
  void initState() {
    super.initState();
    loadMapStyle();
  }

  Future<void> loadMapStyle() async {
    String style = await getJsonFileFromThemes("themes/standard_style.json");
    setState(() {
      mapStyle = style;
    });
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  getCurrentLiveLocationOfUser() async {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
    );

    Position positionOfUser = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    currentPostionOfUser = positionOfUser;

    LatLng positionOfUserInLatLng =
        LatLng(currentPostionOfUser!.latitude, currentPostionOfUser!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserInLatLng, zoom: 15);

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static const CameraPosition googlePlexInitialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125), // Dhaka, Bangladesh
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              googleMapCompleterController.complete(controllerGoogleMap);
              getCurrentLiveLocationOfUser();
            },
            style: mapStyle,
          ),
        ],
      ),
    );
  }
}
