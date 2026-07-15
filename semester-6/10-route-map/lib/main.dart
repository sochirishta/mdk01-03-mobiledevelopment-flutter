import 'dart:async';

import 'package:_10_geo_tracker/directions_history.dart';
import 'package:_10_geo_tracker/history_dialog.dart';
import 'package:_10_geo_tracker/models/mapstate_model.dart';
import 'package:_10_geo_tracker/models/recordroute_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'services/osrm_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RouteMap',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'RouteMap'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final AlignOnUpdate _cameraFollowMode = AlignOnUpdate.never;
  final Geocoding geocoding = Geocoding();
  final Geolocator geolocator = Geolocator();
  final MapState mapState = MapState();
  dynamic bounds;
  bool isFirstTap = true;
  bool isSecondEndpoint = false;
  final StreamController<double?> _centerCurrentLocationStream =
      StreamController<double?>.broadcast();
  late final AnimatedMapController _animatedMapController;

  @override
  void initState() {
    super.initState();
    _animatedMapController =AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    loadHistory();
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    _centerCurrentLocationStream.close();
    super.dispose();
  }

  Future<void> loadHistory() async {
    final loadRecords = await DirectionsHistory.getHistory();

    setState(() {
      mapState.records = loadRecords;
    });
  }

  Future<void> addStartpoint() async {
    mapState.markers.add(
      Marker(
        point: mapState.pointA!,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_on, size: 40, color: Colors.green),
      ),
    );
    isFirstTap = false;
    setState(() {});
  }

  Future<void> addEndpoint() async {
    if (mapState.markers.length > 1) mapState.markers.removeLast();
    mapState.markers.add(
      Marker(
        point: mapState.pointB!,
        width: 40,
        height: 40,
        child: const Icon(Icons.location_on, size: 40, color: Colors.red),
      ),
    );
    setState(() {});
  }

  Future<void> zoomToDirection() async {
    bounds = LatLngBounds.fromPoints(mapState.routePoints!.points);
    _animatedMapController.animatedFitCamera(cameraFit:
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50.0)),
    );
  }

  Future<void> refresh() async {
    mapState.markers.clear();
    mapState.pointA = null;
    mapState.pointB = null;
    isFirstTap = true;
    mapState.routePoints = null;
    isSecondEndpoint = false;
    setState(() {});
  }

  Future<String> getAddress(double latitude, double longitude) async {
    List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
      latitude,
      longitude,
    );
    if (placemarks.isEmpty) {
      return "Unknown location";
    }
    final place = placemarks.first;
    return "${place.country} - ${place.street} - ${place.locality}";
  }

  Future _saveDirection() async {
    mapState.records.add(
      RecordRoute(
        idRoute: DateTime.now().microsecondsSinceEpoch,
        startLatitude: mapState.pointA?.latitude ?? 0,
        startLongitude: mapState.pointA?.longitude ?? 0,
        startpointLabel: mapState.startpointString ?? '',
        endLatitude: mapState.pointB?.latitude ?? 0,
        endLongitude: mapState.pointB?.longitude ?? 0,
        endpointLabel: mapState.endpointString ?? '',
        distanceMeters: mapState.routePoints?.distanceMeters ?? 0,
        durationSeconds: mapState.routePoints?.durationSeconds ?? 0,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final polylines = <Polyline>[
      if (mapState.routePoints != null)
        Polyline(
          points: mapState.routePoints!.points,
          strokeWidth: 4,
          color: Colors.blue,
        ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              polylines.clear();
              await refresh();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => HistoryDialog(records: mapState.records),
              );
            },
            icon: Icon(Icons.segment),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height:
                (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top) *
                0.6,
            child: FlutterMap(
              mapController: _animatedMapController.mapController,
              options: MapOptions(
                initialCenter: LatLng(55.75, 37.61),
                initialZoom: 13,
                onTap: (tapPosition, point) async {
                  setState(() {
                    if (isFirstTap == true) {
                      mapState.pointA = point;
                    } else {
                      mapState.pointB = point;
                    }
                  });
                  if (isFirstTap == true) {
                    mapState.startpointString = await getAddress(
                      mapState.pointA!.latitude,
                      mapState.pointA!.longitude,
                    );
                  } else {
                    mapState.endpointString = await getAddress(
                      mapState.pointB!.latitude,
                      mapState.pointB!.longitude,
                    );
                  }
                  isFirstTap == true
                      ? await addStartpoint()
                      : await addEndpoint();

                  mapState.routePoints = await OsrmService.getRoute(
                    mapState.pointA!,
                    mapState.pointB!,
                  );
                  if (mapState.routePoints != null) {
                    await zoomToDirection();
                  }
                  isFirstTap == false;
                  setState(() {
                    print("${mapState.routePoints}");
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'route_app',
                ),
                CurrentLocationLayer(
                  alignPositionStream: _centerCurrentLocationStream.stream,
                  alignPositionOnUpdate: _cameraFollowMode,
                  style: LocationMarkerStyle(
                    marker: const DefaultLocationMarker(
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
                PolylineLayer(polylines: polylines),
                MarkerLayer(markers: mapState.markers),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  maxLines: 3,
                  mapState.pointA != null
                      ? "Startpoint: ${mapState.startpointString} (${mapState.pointA?.latitude.toStringAsFixed(2)}, ${mapState.pointA?.longitude.toStringAsFixed(2)})"
                      : "",
                ),
                Text(
                  maxLines: 3,
                  mapState.pointB != null
                      ? "Endpoint: ${mapState.endpointString} (${mapState.pointB?.latitude.toStringAsFixed(2)}, ${mapState.pointB?.longitude.toStringAsFixed(2)})"
                      : "",
                ),
                Text(
                  mapState.routePoints?.distanceMeters != null
                      ? "Direction distance: ${mapState.routePoints?.distanceMeters} cm"
                      : "",
                ),
                mapState.routePoints?.durationSeconds != null
                    ? Text(
                        "Time for the path: ${mapState.routePoints?.durationSeconds} min",
                      )
                    : Text(''),
                Visibility(
                  visible: mapState.pointA != null && mapState.pointB != null,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveDirection();
                      await DirectionsHistory.saveHistory(mapState.records);
                    },

                    child: Text("Save directory"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (isFirstTap == false) mapState.markers.removeAt(0);
                    await refresh();

                    _centerCurrentLocationStream.add(15.0);

                    mapState.pointA = await Geolocator.getCurrentPosition()
                        .then((pos) => LatLng(pos.latitude, pos.longitude));
                    mapState.startpointString = await getAddress(
                      mapState.pointA!.latitude,
                      mapState.pointA!.longitude,
                    );
                    addStartpoint();
                    print("${mapState.pointA}");

                    setState(() {});
                  },
                  child: Text("Set my location"),
                ),
                SizedBox(height: 13,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
