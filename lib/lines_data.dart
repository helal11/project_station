import 'metro_station.dart';

/// =====================================================
/// Shared / Transfer Stations (WITH GPS)
/// =====================================================
/// ⚠️ These stations MUST be defined ONCE and reused
/// across all lines (transfer + nearest station logic)

final sadat = MetroStation('Sadat', 30.0444, 31.2357);
final attaba = MetroStation('Attaba', 30.0523, 31.2468);
final nasser = MetroStation('Nasser', 30.0535, 31.2387);
final shohadaa = MetroStation('Al-Shohadaa', 30.0611, 31.2460);
final kitKat = MetroStation('Kit Kat', 30.0666, 31.2156);

/// =====================================================
/// Line 1 – Red Line
/// =====================================================
List<MetroStation> line1Stations = [
  MetroStation('Helwan'),
  MetroStation('Ain Helwan'),
  MetroStation('Helwan University'),
  MetroStation('Wadi Hof'),
  MetroStation('Hadayek Helwan'),
  MetroStation('El-Maasara'),
  MetroStation('Tora El-Asmant'),
  MetroStation('Kozzika'),
  MetroStation('Tora El-Balad'),
  MetroStation('Sakanat El-Maadi'),
  MetroStation('Maadi'),
  MetroStation('Hadayek El-Maadi'),
  MetroStation('Dar El-Salam'),
  MetroStation('El-Zahraa'),
  MetroStation('Mar Girgis'),
  MetroStation('El-Malek El-Saleh'),
  MetroStation('Al-Sayeda Zeinab'),
  MetroStation('Saad Zaghloul'),
  sadat,
  nasser,
  MetroStation('Orabi'),
  shohadaa,
  MetroStation('Ghamra'),
  MetroStation('El-Demerdash'),
  MetroStation('Manshiet El-Sadr'),
  MetroStation('Kobri El-Qobba'),
  MetroStation('Hammamat El-Qobba'),
  MetroStation('Saray El-Qobba'),
  MetroStation('Hadayeq El-Zaitoun'),
  MetroStation('Helmeyet El-Zaitoun'),
  MetroStation('El-Matareyya'),
  MetroStation('Ain Shams'),
  MetroStation('Ezbet El-Nakhl'),
  MetroStation('El-Marg'),
  MetroStation('New El-Marg'),
];

/// =====================================================
/// Line 2 – Yellow Line
/// =====================================================
List<MetroStation> line2Stations = [
  MetroStation('El-Mounib'),
  MetroStation('Sakiat Mekki'),
  MetroStation('Omm El-Masryeen'),
  MetroStation('Giza'),
  MetroStation('Faisal'),
  MetroStation('Cairo University'),
  MetroStation('Bohooth'),
  MetroStation('Dokki'),
  MetroStation('Opera'),
  sadat,
  MetroStation('Mohamed Naguib'),
  attaba,
  shohadaa,
  MetroStation('Masarra'),
  MetroStation('Road El-Farag'),
  MetroStation('St. Teresa'),
  MetroStation('Khalafawy'),
  MetroStation('Mezallat'),
  MetroStation('Kolleyyet El-Zeraa'),
  MetroStation('Shubra El-Kheima'),
];

/// =====================================================
/// Line 3 – Green Line
/// =====================================================
List<MetroStation> line3Stations = [
  MetroStation('Adly Mansour'),
  MetroStation('El-Haykestep'),
  MetroStation('Omar Ibn El-Khattab'),
  MetroStation('Qobaa'),
  MetroStation('Hesham Barakat'),
  MetroStation('El-Nozha'),
  MetroStation('Nadi El-Shams'),
  MetroStation('Alf Maskan'),
  MetroStation('Heliopolis'),
  MetroStation('Haroun'),
  MetroStation('Al-Ahram'),
  MetroStation('Koleyet El-Banat'),
  MetroStation('Stadium'),
  MetroStation('Fair Zone'),
  MetroStation('Abbassia'),
  MetroStation('Abdou Pasha'),
  MetroStation('El-Geish'),
  MetroStation('Bab El-Shaaria'),
  attaba,
  nasser,
  MetroStation('Maspero'),
  MetroStation('Safaa Hegazy'),
  kitKat,
  MetroStation('Sudan'),
  MetroStation('Imbaba'),
  MetroStation('El-Bohy'),
  MetroStation('El-Qawmia'),
  MetroStation('Ring Road'),
  MetroStation('Rod El-Farag Corridor'),
];
