import 'package:flutter/material.dart';
import 'package:project_station/lines_data.dart';
import 'package:project_station/metro_line.dart';
import 'package:project_station/metro_system.dart';
import 'package:project_station/nearest_station.dart';
import 'package:project_station/widgets/station_autocomplete.dart';
import 'package:project_station/zones_data.dart';

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

  final TextEditingController zoneController = TextEditingController();

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

  // ===============================
  // اقتراح أقرب محطة من منطقة / شارع
  // ===============================
  void suggestStationFromZone() {
    final input = zoneController.text.trim();

    if (input.isEmpty) {
      setState(() {
        result = 'من فضلك أدخل اسم المنطقة أو الشارع';
      });
      return;
    }

    final zone = zonesData.firstWhere(
      (z) => z.name.contains(input),
      orElse: () => zonesData.first,
    );

    final nearest = metro.findNearestStationByLatLng(
      zone.lat,
      zone.lng,
    );

    setState(() {
      endStation = nearest?.name;
      result =
          '📍 أقرب محطة لمنطقة "$input"\n\n🚉 ${nearest?.name ?? 'غير متاح'}';
    });
  }

  // ===============================
  // حساب تفاصيل الرحلة (بدون graph)
  // ===============================
  void calculateRoute() {
    if (startStation == null || endStation == null) {
      setState(() {
        result = 'من فضلك اختر محطة البداية ومحطة الوصول';
      });
      return;
    }

    // تقدير بسيط للعرض (آمن للـ presentation)
    final estimatedStations = 8;
    final estimatedTime = estimatedStations * 2;
    final ticketPrice = _ticketPrice(estimatedStations);

    setState(() {
      result = '''
🚇 تفاصيل الرحلة
------------------------
📍 محطة البداية: $startStation
🎯 محطة الوصول: $endStation

🚏 عدد المحطات: $estimatedStations
⏱️ الوقت المتوقع: $estimatedTime دقيقة
💳 سعر التذكرة: $ticketPrice جنيه
🔁 عدد التحويلات: 1 (تقديري)

(سيتم تحسين الحساب باستخدام Graph لاحقًا)
''';
    });
  }

  int _ticketPrice(int stations) {
    if (stations <= 9) return 8;
    if (stations <= 16) return 10;
    return 15;
  }

  // ===============================
  // UI
  // ===============================
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
      _buildAbout(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('مترو القاهرة'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
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
            icon: Icon(Icons.info),
            label: 'عن التطبيق',
          ),
        ],
      ),
    );
  }

  // ===============================
  // الصفحة الرئيسية
  // ===============================
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
            onSelected: (v) => setState(() => startStation = v),
          ),

          const SizedBox(height: 12),

          StationAutocomplete(
            label: 'محطة الوصول',
            stations: allStations,
            initialValue: endStation,
            onSelected: (v) => setState(() => endStation = v),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: zoneController,
            decoration: const InputDecoration(
              labelText: 'أدخل اسم المنطقة أو الشارع',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_city),
            ),
          ),

          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed: suggestStationFromZone,
            icon: const Icon(Icons.near_me),
            label: const Text('اقترح أقرب محطة'),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: calculateRoute,
            child: const Text('احسب الرحلة'),
          ),

          const SizedBox(height: 24),

          if (result != null)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  result!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===============================
  // عن التطبيق
  // ===============================
  Widget _buildAbout() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'تطبيق مترو القاهرة يساعدك على معرفة أقرب محطة، '
          'تفاصيل الرحلة، وسعر التذكرة بطريقة سهلة.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
