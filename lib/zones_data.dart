class Zone {
  final String name;
  final double lat;
  final double lng;

  const Zone({
    required this.name,
    required this.lat,
    required this.lng,
  });
}

const zonesData = [
  Zone(name: 'مدينة نصر', lat: 30.0561, lng: 31.3300),
  Zone(name: 'المعادي', lat: 29.9602, lng: 31.2569),
  Zone(name: 'الدقي', lat: 30.0385, lng: 31.2116),
  Zone(name: 'شبرا', lat: 30.0726, lng: 31.2454),
];
