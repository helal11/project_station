class MetroStation {
  final String name;
  final double? lat;
  final double? lng;

  MetroStation(this.name, [this.lat, this.lng]);

  @override
  String toString() => name;
}
