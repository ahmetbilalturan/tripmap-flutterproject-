import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripmap/screens/loadingscreen.dart';
import 'package:tripmap/globals.dart' as globals;

const LatLng SOURCE_LOCATION = LatLng(41.015137, 28.979530);
const LatLng DEST_LOCATION = LatLng(41.008469, 28.980261);
const double CAMERA_ZOOM = 13.5;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

class PolylineScreen extends StatefulWidget {
  final LatLng destinationLocation;
  const PolylineScreen({Key? key, required this.destinationLocation})
      : super(key: key);

  @override
  _PolylineScreenState createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  Completer<GoogleMapController> _controller = Completer();

  bool isFetched = false;

  Set<Marker> _markers = Set<Marker>();
  double pinPillPosition = PIN_VISIBLE_POSITION;
  LatLng currentLocation = const LatLng(41.012604, 28.959648);
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showLoadingOverlay());
    polylinePoints = PolylinePoints();
    setInitialLocation();
  }

  void setInitialLocation() async {
    Position position = await globals.deviceLocation;
    LatLng location = LatLng(position.latitude, position.longitude);
    currentLocation = location;

    setState(() {
      isFetched = true;
      hideLoadingOverlay();
    });
    showPinsOnMap();
    setPolylines();
  }

  OverlayEntry? entry;

  void showLoadingOverlay() {
    final overlay = Overlay.of(context)!;

    entry = OverlayEntry(
      builder: (context) => buildLoadingOverlay(),
    );
    overlay.insert(entry!);
  }

  void hideLoadingOverlay() {
    entry!.remove();
    entry = null;
  }

  Widget buildLoadingOverlay() => const Material(
        color: Colors.transparent,
        elevation: 8,
        child: Center(
          child: CircularProgressIndicator(
              color: Color.fromARGB(255, 163, 171, 192)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            polylines: _polylines,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: LoadingScreen.currentLocation,
            onTap: (LatLng loc) {
              setState(
                () {
                  pinPillPosition = PIN_INVISIBLE_POSITION;
                },
              );
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                color: const Color(0xFF6C43BC),
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void showPinsOnMap() {
    setState(
      () {
        _markers.add(
          Marker(
            markerId: const MarkerId('destinationPin'),
            position: widget.destinationLocation,
            onTap: () {
              setState(
                () {
                  pinPillPosition = PIN_VISIBLE_POSITION;
                },
              );
            },
          ),
        );
      },
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        position: currentLocation,
        onTap: () {
          setState(() {});
        },
      ),
    );
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        globals.apiKey,
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(widget.destinationLocation.latitude,
            widget.destinationLocation.longitude));

    if (result.status == 'OK') {
      result.points.forEach(
        (PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        },
      );

      setState(
        () {
          _polylines.add(Polyline(
              width: 4,
              polylineId: const PolylineId('polyLine'),
              color: const Color(0xFF6C43BC),
              points: polylineCoordinates));
        },
      );
    }
  }
}
