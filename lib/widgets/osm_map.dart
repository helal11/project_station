import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_station/metro_station.dart';

class OSMMap extends StatelessWidget {
  final double lat;
  final double lng;
  final List<MetroStation> stations;
  final MetroStation? nearestStation;

  const OSMMap({
    super.key,
    required this.lat,
    required this.lng,
    required this.stations,
    required this.nearestStation,
  });

  @override
  Widget build(BuildContext context) {
    final userPoint = LatLng(lat, lng);

    return SizedBox(
      height: 300,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: userPoint,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.project_station.app',
          ),

          /// Stations + user markers
          MarkerLayer(
            markers: [
              Marker(
                point: userPoint,
                width: 40,
                height: 40,
                child: const Icon(Icons.person_pin_circle,
                    color: Colors.blue, size: 40),
              ),

              for (final s in stations)
                if (s.lat != null && s.lng != null)
                  Marker(
                    point: LatLng(s.lat!, s.lng!),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.location_on,
                      color: s == nearestStation
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
            ],
          ),

          /// Direction line
          if (nearestStation != null)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [
                    userPoint,
                    LatLng(
                      nearestStation!.lat!,
                      nearestStation!.lng!,
                    ),
                  ],
                  strokeWidth: 4,
                  color: Colors.blue,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
