import 'metro_station.dart';

class MetroLine {
  String lineName;
  String lineColor;
  
  List<MetroStation> stations;

  MetroLine(this.lineName, this.lineColor, this.stations);

  bool hasStation(String stationName) {
    return stations.any(
      (station) => station.name.toLowerCase() == stationName.toLowerCase(),
    );
  }

  int getStationIndex(String stationName) {
    return stations.indexWhere(
      (station) => station.name.toLowerCase() == stationName.toLowerCase(),
    );
  }

  MetroStation? getStation(String stationName) {
    try {
      return stations.firstWhere(
        (station) => station.name.toLowerCase() == stationName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
