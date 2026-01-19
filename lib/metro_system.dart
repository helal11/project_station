import 'metro_line.dart';
import 'metro_station.dart';
import 'route_segment.dart';
import 'trip.dart';

class MetroSystem {
  final List<MetroLine> lines;
  final Map<MetroStation, List<MetroLine>> stationToLines = {};

  MetroSystem(this.lines) {
    _buildStationIndex();
  }

  // indexing station in lines
  void _buildStationIndex() {
    for (var line in lines) {
      for (var station in line.stations) {
        if (!stationToLines.containsKey(station)) {
          stationToLines[station] = [];
        }
        stationToLines[station]!.add(line);
      }
    }
  }

  // on the same line ??
  Trip? findDirectRoute(String startName, String arrivalName) {
    for (var line in lines) {
      if (line.hasStation(startName) && line.hasStation(arrivalName)) {
        int startIndex = line.getStationIndex(startName);
        int arrivalIndex = line.getStationIndex(arrivalName);

        if (startIndex == arrivalIndex) continue;

        List<MetroStation> route;
        String direction;

        if (startIndex < arrivalIndex) {
          route = line.stations.sublist(startIndex, arrivalIndex + 1);
          direction = '${line.stations.last}';
        } else {
          route = line.stations
              .sublist(arrivalIndex, startIndex + 1)
              .reversed
              .toList();
          direction = '${line.stations.first}';
        }

        RouteSegment segment = RouteSegment(line, route, direction);
        return Trip(
          segments: [segment],
          totalStations: route.length,
          transferStations: [],
        );
      }
    }
    return null;
  }

  // not the same line ??
  Trip? findRouteWithTransfer(String startName, String arrivalName) {
    MetroStation? startStation = _findStation(startName);
    MetroStation? arrivalStation = _findStation(arrivalName);

    if (startStation == null || arrivalStation == null) return null;

    // lines of start and arrival
    List<MetroLine> startLines = stationToLines[startStation] ?? [];
    List<MetroLine> arrivalLines = stationToLines[arrivalStation] ?? [];

    // transfer stations
    for (var startLine in startLines) {
      for (var arrivalLine in arrivalLines) {
        if (startLine == arrivalLine) continue;

        //  transfer stations between two lines
        for (var transferStation in startLine.stations) {
          if (arrivalLine.hasStation(transferStation.name)) {
            //transfer one station
            int startIdx = startLine.getStationIndex(startStation.name);
            int transferIdx1 = startLine.getStationIndex(transferStation.name);
            int transferIdx2 = arrivalLine.getStationIndex(
              transferStation.name,
            );
            int arrivalIdx = arrivalLine.getStationIndex(arrivalStation.name);

            if (startIdx == transferIdx1 || transferIdx2 == arrivalIdx)
              continue;

            // first segment
            List<MetroStation> segment1Stations;
            String direction1;
            if (startIdx < transferIdx1) {
              segment1Stations = startLine.stations.sublist(
                startIdx,
                transferIdx1 + 1,
              );
              direction1 = '${startLine.stations.last}';
            } else {
              segment1Stations = startLine.stations
                  .sublist(transferIdx1, startIdx + 1)
                  .reversed
                  .toList();
              direction1 = '${startLine.stations.first}';
            }

            List<MetroStation> segment2Stations;
            String direction2;
            if (transferIdx2 < arrivalIdx) {
              segment2Stations = arrivalLine.stations.sublist(
                transferIdx2,
                arrivalIdx + 1,
              );
              direction2 = '${arrivalLine.stations.last}';
            } else {
              segment2Stations = arrivalLine.stations
                  .sublist(arrivalIdx, transferIdx2 + 1)
                  .reversed
                  .toList();
              direction2 = '${arrivalLine.stations.first}';
            }

            RouteSegment seg1 = RouteSegment(
              startLine,
              segment1Stations,
              direction1,
            );
            RouteSegment seg2 = RouteSegment(
              arrivalLine,
              segment2Stations,
              direction2,
            );

            int totalStations =
                segment1Stations.length + segment2Stations.length - 1;

            return Trip(
              segments: [seg1, seg2],
              totalStations: totalStations,
              transferStations: [transferStation],
            );
          }
        }
      }
    }
    return null;
  }

  // Main route finding method
  Trip? findRoute(String startName, String arrivalName) {
    // Try direct route first
    Trip? directRoute = findDirectRoute(startName, arrivalName);
    if (directRoute != null) return directRoute;

    // Try route with one transfer
    Trip? transferRoute = findRouteWithTransfer(startName, arrivalName);
    if (transferRoute != null) return transferRoute;

    return null;
  }

  // Find station object by name
  MetroStation? _findStation(String name) {
    for (var line in lines) {
      MetroStation? station = line.getStation(name);
      if (station != null) return station;
    }
    return null;
  }
}
