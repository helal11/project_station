import 'package:flutter/material.dart';
import 'package:project_station/lines_data.dart';
import 'package:project_station/metro_line.dart';
import 'package:project_station/metro_map_page.dart';
import 'package:project_station/metro_system.dart';
import 'package:project_station/nearest_station.dart';
import 'package:project_station/widgets/station_autocomplete.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  String? startStation;
  String? endStation;
  String? result;

  late MetroSystem metro;

  @override
  void initState() {
    super.initState();

    metro = MetroSystem([
      MetroLine('Line 1', 'Red', line1Stations),
      MetroLine('Line 2', 'Yellow', line2Stations),
      MetroLine('Line 3', 'Green', line3Stations),
    ]);
  }

  List<String> get allStations {
    final stations = metro.lines
        .expand((l) => l.stations)
        .map((s) => s.name)
        .toSet()
        .toList();
    stations.sort();
    return stations;
  }

  void calculateRoute() {
    if (startStation == null || endStation == null) {
      setState(() {
        result = 'من فضلك اختر محطة البداية ومحطة الوصول';
      });
      return;
    }

    if (startStation == endStation) {
      setState(() {
        result = 'محطة البداية والوصول لا يمكن أن تكونا متطابقتين';
      });
      return;
    }

    final trip = metro.findRoute(startStation!, endStation!);

    if (trip == null) {
      setState(() {
        result = 'لا يوجد مسار متاح بين هاتين المحطتين';
      });
      return;
    }

    final buffer = StringBuffer();

    buffer.writeln('عدد المحطات: ${trip.totalStations}');
    buffer.writeln('الوقت المتوقع: ${trip.totalStations * 2} دقيقة');
    buffer.writeln('سعر التذكرة: ${trip.ticketPrice(trip.totalStations)} جنيه');
    buffer.writeln('عدد التحويلات: ${trip.transferStations.length}');

    if (trip.transferStations.isNotEmpty) {
      buffer.writeln('\nمحطات التحويل:');
      for (final s in trip.transferStations) {
        buffer.writeln('• ${s.name}');
      }
    } else {
      buffer.writeln('\n🚇 بدون تحويل');
    }

    setState(() {
      result = buffer.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      NearestStationPage(
        metro: metro,
        onStationSelected: (stationName) {
          setState(() {
            startStation = stationName;
            _currentIndex = 0;
          });
        },
      ),
      const MetroMapPage(),
      _buildAbout(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('مترو القاهرة',style: TextStyle(color: Colors.blueAccent),),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_location),
            label: 'أقرب محطة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'خريطة المترو',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'عن التطبيق',
          ),
        ],
      ),
    );
  }

  /// الصفحة الرئيسية
  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'اعرف تفاصيل رحلتك',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

         StationAutocomplete(
  label: 'محطة البداية',
  stations: allStations,
  initialValue: startStation,
  onSelected: (value) {
    setState(() {
      startStation = value;
    });
  },
),

const SizedBox(height: 12),

StationAutocomplete(
  label: 'محطة الوصول',
  stations: allStations,
  initialValue: endStation,
  onSelected: (value) {
    setState(() {
      endStation = value;
    });
  },
),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: calculateRoute,
            child: const Text('احسب الرحلة'),
          ),

          const SizedBox(height: 24),

          if (result != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(result!, textAlign: TextAlign.center),
              ),
            ),

          const SizedBox(height: 20),

          Image.asset('assets/images/metrol-logo.png'),
        ],
      ),
    );
  }

  /// عن التطبيق
  Widget _buildAbout() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'تطبيق مترو القاهرة يساعدك على معرفة أفضل مسار، '
          'عدد المحطات، الوقت المتوقع وسعر التذكرة.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
