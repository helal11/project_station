import 'metro_line.dart';
import 'metro_station.dart';

class RouteSegment {
  MetroLine line;
  List<MetroStation> stations;
  String direction;

  RouteSegment(this.line, this.stations, this.direction);

  int get numberOfStations => stations.length;
  int get numberOfStops => stations.length - 1;
}
