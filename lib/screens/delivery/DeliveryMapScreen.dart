import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'models/Order.dart';


class DeliveryMapScreen extends StatefulWidget {
  final Order order;

  const DeliveryMapScreen({super.key, required this.order});

  @override
  State<DeliveryMapScreen> createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  final locationController = Location();
  LatLng? currentPosition; // Current location of the delivery person
  Map<PolylineId, Polyline> polylines = {};
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initializeMap());
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
    if (currentPosition != null) {
      final coordinates = await fetchPolylinePoints();
      generatePolyLineFromPoints(coordinates);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Delivery Tracking")),
    body: currentPosition == null
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentPosition!,
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('currentLocation'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure),
          position: currentPosition!,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
        Marker(
          markerId: const MarkerId('destinationLocation'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed),
          position: LatLng(widget.order.lat, widget.order.lng),
          infoWindow: InfoWindow(
              title: 'Customer Location', snippet: widget.order.address),
        ),
      },
      polylines: Set<Polyline>.of(polylines.values),
      onMapCreated: (controller) => mapController = controller,
    ),
  );

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final currentLocation = await locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        currentPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });
    }

    locationController.onLocationChanged.listen((updatedLocation) {
      if (updatedLocation.latitude != null && updatedLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            updatedLocation.latitude!,
            updatedLocation.longitude!,
          );
        });
      }
    });
  }

  Future<List<LatLng>> fetchPolylinePoints() async {
    if (currentPosition == null) return [];

    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      dotenv.env['GOOGLE_MAP_KEY'] ?? "",
      PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
      PointLatLng(widget.order.lat, widget.order.lng),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint("Polyline error: ${result.errorMessage}");
      return [];
    }
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    const polylineId = PolylineId('route');

    final polyline = Polyline(
      polylineId: polylineId,
      color: Colors.blueAccent,
      width: 5,
      points: polylineCoordinates,
    );

    setState(() => polylines[polylineId] = polyline);
  }
}
