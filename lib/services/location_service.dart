import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:project_station/metro_station.dart';

class LocationService {
  /// Get current location
  static Future<Position> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );
  }

  /// Distance in meters (Haversine)
  static double distanceInMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _deg2rad(double deg) => deg * (pi / 180);

  /// Find nearest station
  static MetroStation? findNearestStation(
    Position pos,
    List<MetroStation> stations,
  ) {
    double minDistance = double.infinity;
    MetroStation? nearest;

    for (final station in stations) {
      if (station.lat == null || station.lng == null) continue;

      final dist = distanceInMeters(
        pos.latitude,
        pos.longitude,
        station.lat!,
        station.lng!,
      );

      if (dist < minDistance) {
        minDistance = dist;
        nearest = station;
      }
    }

    return nearest;
  }
}
