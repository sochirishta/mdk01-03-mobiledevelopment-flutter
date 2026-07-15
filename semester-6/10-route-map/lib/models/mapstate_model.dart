import 'package:_10_geo_tracker/models/route_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'recordroute_model.dart';

class MapState {
  LatLng? pointA;
  LatLng? pointB;
  String? startpointString;
  String? endpointString;
  List<Marker> markers = [];
  RouteResult? routePoints;
  List<RecordRoute> records = [];

  MapState();
}