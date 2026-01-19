import 'metro_station.dart';
import 'route_segment.dart';

class Trip {
  final List<RouteSegment> segments;
  final int totalStations;
  final List<MetroStation> transferStations;

  Trip({
    required this.segments,
    required this.totalStations,
    required this.transferStations,
  });

  /// ⏱️ كل محطة ≈ دقيقتين
  int get timeMinutes => totalStations * 2;

  /// 🎟️ سعر التذكرة حسب عدد المحطات
  int ticketPrice(int length) {
  if (length <= 9) return 8;
  if (length <= 16) return 10;
  if (length <= 23) return 15;
  return 20;
}

}
