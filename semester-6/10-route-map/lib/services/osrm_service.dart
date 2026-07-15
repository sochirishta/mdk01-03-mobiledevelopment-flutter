import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/route_model.dart';

class OsrmService {
  static Future<RouteResult> getRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
      "https://router.project-osrm.org/route/v1/driving/"
      "${start.longitude},${start.latitude};"
      "${end.longitude},${end.latitude}"
      "?overview=full&geometries=geojson",
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      final route = data["routes"][0];

      final geometry = route["geometry"];
      final coordinates = geometry["coordinates"];

      List<LatLng> points = coordinates.map<LatLng>((coord) {
        return LatLng(
          (coord[1] as num).toDouble(),
          (coord[0] as num).toDouble(),
        );
      }).toList();

      return RouteResult(
        points: points,
        distanceMeters: (route["distance"] as num).toDouble(),
        durationSeconds: (route["duration"] as num).toDouble(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
