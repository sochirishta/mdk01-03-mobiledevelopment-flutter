import 'package:_10_geo_tracker/directions_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:_10_geo_tracker/models/recordroute_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/widgets.dart';

class HistoryDialog extends StatefulWidget {
  final List<RecordRoute> records;

  const HistoryDialog({super.key, required this.records});

  @override
  State<HistoryDialog> createState() => _HistoryDialogState();
}

class _HistoryDialogState extends State<HistoryDialog> {
  List<RecordRoute> records = [];
  Map<int, MapController> mapControllers = {};

  @override
  Widget build(BuildContext context) {
    records = widget.records;
    for (final record in records) {
      mapControllers[record.idRoute] = MapController();
    }
    return AlertDialog(
      title: Text("Direction history"),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = widget.records[index];
            final controller = mapControllers[record.idRoute];
            return Card(
              child: ExpansionTile(
                title: Text("Direction #${index + 1}:"),
                subtitle: Text(
                  "Start: ${record.startpointLabel}"
                  "\nEnd: ${record.endpointLabel}",
                ),
                onExpansionChanged: (expanded) {
                  if (expanded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        controller?.fitCamera(
                          CameraFit.bounds(
                            bounds: LatLngBounds.fromPoints([
                              LatLng(
                                record.startLatitude,
                                record.startLongitude,
                              ),
                              LatLng(record.endLatitude, record.endLongitude),
                            ]),
                            padding: const EdgeInsets.all(20.0),
                          ),
                        );
                      });
                    });
                  };
                },
                children: [
                  ListTile(
                    subtitle: Text(
                      "\nStartpoint: ${record.startpointLabel}: (${record.startLatitude.toStringAsFixed(2)}, ${record.startLongitude.toStringAsFixed(2)})"
                      "\nEndpoint: ${record.endpointLabel}: (${record.endLatitude.toStringAsFixed(2)}, ${record.endLongitude.toStringAsFixed(2)})"
                      "\nDistance meters: ${record.distanceMeters}"
                      "\nDuration seconds: ${record.durationSeconds}"
                      "\nCreated At: ${record.createdAt}",
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await DirectionsHistory.deleteHistory(index);
                        setState(() {
                          records.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                  SizedBox(
                    height: 130,
                    child: FlutterMap(
                      mapController: controller,
                      options: MapOptions(
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                        initialCenter: LatLng(55.75, 37.61),
                        initialZoom: 13,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'route_app',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [
                                LatLng(
                                  record.startLatitude,
                                  record.startLongitude,
                                ),
                                LatLng(record.endLatitude, record.endLongitude),
                              ],
                              strokeWidth: 4,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                record.startLatitude,
                                record.startLongitude,
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                            ),
                            Marker(
                              point: LatLng(
                                record.endLatitude,
                                record.endLongitude,
                              ),
                              child: Icon(Icons.location_on, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
