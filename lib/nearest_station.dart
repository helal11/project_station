import 'package:flutter/material.dart';
import 'package:project_station/metro_station.dart';
import 'package:project_station/metro_system.dart';
import 'package:project_station/services/location_service.dart';
import 'package:project_station/widgets/osm_map.dart';

class NearestStationPage extends StatefulWidget {
  final MetroSystem metro;
  final void Function(String stationName) onStationSelected;

  const NearestStationPage({
    super.key,
    required this.metro,
    required this.onStationSelected,
  });

  @override
  State<NearestStationPage> createState() => _NearestStationPageState();
}

class _NearestStationPageState extends State<NearestStationPage> {
  MetroStation? nearestStation;
  double? userLat;
  double? userLng;
  String? result;

  Future<void> findNearest() async {
    try {
      final pos = await LocationService.getCurrentLocation();

      final stations = widget.metro.lines
          .expand((l) => l.stations)
          .toSet()
          .toList();

      final nearest =
          LocationService.findNearestStation(pos, stations);

      if (nearest == null) {
        setState(() => result = 'لا توجد محطات بإحداثيات');
        return;
      }

      final distanceMeters = LocationService.distanceInMeters(
        pos.latitude,
        pos.longitude,
        nearest.lat!,
        nearest.lng!,
      );

      final distanceKm = distanceMeters / 1000;

      setState(() {
        nearestStation = nearest;
        userLat = pos.latitude;
        userLng = pos.longitude;
        result =
            '📍 أقرب محطة:\n${nearest.name}\n'
            'المسافة: ${distanceKm.toStringAsFixed(2)} كم';
      });
    } catch (e) {
      setState(() => result = 'تعذر تحديد موقعك');
    }
  }

  @override
  Widget build(BuildContext context) {
    final stations = widget.metro.lines
        .expand((l) => l.stations)
        .toSet()
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'أقرب محطة مترو',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.location_searching),
            label: const Text('تحديد موقعي'),
            onPressed: findNearest,
          ),

          if (result != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(result!, textAlign: TextAlign.center),
              ),
            ),
          ],

          if (userLat != null && userLng != null)
            OSMMap(
              lat: userLat!,
              lng: userLng!,
              stations: stations,
              nearestStation: nearestStation,
            ),

          if (nearestStation != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                label: const Text('استخدمها كنقطة بداية'),
                onPressed: () =>
                    widget.onStationSelected(nearestStation!.name),
              ),
            ),
        ],
      ),
    );
  }
}
