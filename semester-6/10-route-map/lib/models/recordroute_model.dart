import 'dart:convert';

class RecordRoute {
  final int idRoute;
  final double startLatitude;
  final double startLongitude;
  final String startpointLabel;
  final double endLatitude;
  final double endLongitude;
  final String endpointLabel;
  final double distanceMeters;
  final double durationSeconds;
  final DateTime createdAt;

  RecordRoute({
    required this.idRoute,
    required this.startLatitude,
    required this.startLongitude,
    required this.startpointLabel,
    required this.endLatitude,
    required this.endLongitude,
    required this.endpointLabel,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'idRoute': idRoute,
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'startpointLabel': startpointLabel,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'endpointLabel': endpointLabel,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJson() => jsonEncode(toMap());

  factory RecordRoute.fromJson(String source) {
    final map = jsonDecode(source);

    print(map);
    return RecordRoute(
      idRoute: map['idRoute'],
      startLatitude: map['startLatitude'],
      startLongitude: map['startLongitude'],
      startpointLabel: map['startpointLabel'],
      endLatitude: map['endLatitude'],
      endLongitude: map['endLongitude'],
      endpointLabel: map['endpointLabel'],
      distanceMeters: map['distanceMeters'],
      durationSeconds: map['durationSeconds'],
      createdAt: DateTime.parse(map['createdAt'])
    );
  }
}