import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tst extends StatefulWidget {
  Tst({Key? key}) : super(key: key);

  @override
  State<Tst> createState() => _TstState();
}

class _TstState extends State<Tst> {
  late StreamSubscription<Position> positionStream;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
  );

  late GoogleMapController gmc;

  Set<Marker> markers = {};

  updateMap(newLat, newLong) {
    markers.clear();
    markers.add(
        Marker(markerId: MarkerId("1"), position: LatLng(newLat, newLong)));
    gmc.animateCamera(CameraUpdate.newLatLng(LatLng(newLat, newLong)));
    setState(() {});
  }

  Future getPermission() async {
    bool locationServices;
    locationServices = await Geolocator.isLocationServiceEnabled();
    if (locationServices == false) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Location Services',
        desc: 'Please enable the location services',
        btnOkOnPress: () {},
      )..show();
    }

    LocationPermission per;
    per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied) {
      Geolocator.requestPermission();
    }
  }

  Future<void> getLatLong() async {
    Position currentLocation = await Geolocator.getCurrentPosition();
    _kGooglePlex = CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 14.4746,
    );
    markers.add(Marker(
        markerId: MarkerId("1"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude)));
    setState(() {});
  }

  @override
  void initState() {
    getPermission();
    getLatLong();
    positionStream =
        Geolocator.getPositionStream().listen((Position? position) {
      updateMap(position?.latitude, position?.longitude);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Live Location"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _kGooglePlex ==
                    CameraPosition(
                        bearing: 0.0,
                        target: LatLng(0.0, 0.0),
                        tilt: 0.0,
                        zoom: 0.0)
                ? CircularProgressIndicator()
                : Container(
                    margin: EdgeInsets.all(10),
                    width: 400,
                    height: 500,
                    child: GoogleMap(
                      markers: markers,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        gmc = controller;
                      },
                    ),
                  ),
          ],
        ));
  }
}
