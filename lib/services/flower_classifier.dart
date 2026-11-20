import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../models/flower_model.dart';

class FlowerClassifier {
  static const List<FlowerInfo> dataset = [
    FlowerInfo(
      id: 'mawar',
      name: 'Bunga Mawar',
      latinName: 'Rosa rubiginosa',
      description:
          'Tanaman semak berduri dengan kelopak berlapis rapat dan aroma khas yang harum. '
          'Umumnya berwarna merah cerah, merah muda, hingga putih dan sering dijadikan tanaman hias taman.',
      careTip: 'Butuh sinar matahari penuh minimal 6 jam sehari dan penyiraman rutin di pagi hari.',
      primaryColor: Color(0xFFD32F2F),
      secondaryColor: Color(0xFFFFCDD2),
      targetHue: 355.0,
    ),
    FlowerInfo(
      id: 'sepatu',
      name: 'Kembang Sepatu',
      latinName: 'Hibiscus rosa-sinensis',
      description:
          'Bunga tropis berukuran besar berbentuk terompet dengan lima kelopak lebar dan putik menjulur panjang di bagian tengah. '
          'Banyak tumbuh subur di pekarangan rumah beriklim tropis.',
      careTip: 'Siram secara teratur saat tanah mulai mengering dan beri pupuk NPK sebulan sekali.',
      primaryColor: Color(0xFFE91E63),
      secondaryColor: Color(0xFFF8BBD0),
      targetHue: 335.0,
    ),
    FlowerInfo(
      id: 'matahari',
      name: 'Bunga Matahari',
      latinName: 'Helianthus annuus',
      description:
          'Bunga semusim berukuran besar dengan kelopak kuning keemasan yang mengelilingi bagian tengah berwarna cokelat gelap. '
          'Memiliki sifat heliotropisme yaitu selalu menghadap arah datangnya sinar matahari.',
      careTip: 'Tanam di area terbuka yang terkena matahari langsung dengan tanah gembur berdrainase baik.',
      primaryColor: Color(0xFFFBC02D),
      secondaryColor: Color(0xFFFFF9C4),
      targetHue: 48.0,
    ),
    FlowerInfo(
      id: 'alamanda',
      name: 'Bunga Alamanda',
      latinName: 'Allamanda cathartica',
      description:
          'Tanaman hias merambat yang dikenal sebagai bunga terompet emas karena kelopak kuning cerahnya yang mengilap. '
          'Berbunga sepanjang tahun di daerah tropis.',
      careTip: 'Pangkas cabang secara berkala agar pertumbuhan tetap rimbun dan rajin berbunga.',
      primaryColor: Color(0xFFFFA000),
      secondaryColor: Color(0xFFFFECB3),
      targetHue: 38.0,
    ),
    FlowerInfo(
      id: 'melati',
      name: 'Bunga Melati',
      latinName: 'Jasminum sambac',
      description:
          'Bunga kecil berwarna putih bersih dengan mahkota bertumpuk dan wangi lembut yang menenangkan. '
          'Merupakan salah satu puspa bangsa Indonesia.',
      careTip: 'Jaga kelembapan tanah tanpa menggenang dan letakkan di tempat terang.',
      primaryColor: Color(0xFF66BB6A),
      secondaryColor: Color(0xFFF1F8E9),
      targetHue: 120.0,
      isWhiteOrNeutral: true,
    ),
    FlowerInfo(
      id: 'anggrek',
      name: 'Anggrek Bulan',
      latinName: 'Phalaenopsis amabilis',
      description:
          'Spesies anggrek epifit dengan kelopak simetris elegan berwarna putih hingga ungu lembut. '
          'Mampu bertahan mekar hingga berminggu-minggu.',
      careTip: 'Gunakan media tanam arang atau pakis dan hindari paparan matahari siang langsung.',
      primaryColor: Color(0xFF8E24AA),
      secondaryColor: Color(0xFFF3E5F5),
      targetHue: 285.0,
    ),
    FlowerInfo(
      id: 'bougenville',
      name: 'Bunga Kertas (Bougenville)',
      latinName: 'Bougainvillea spectabilis',
      description:
          'Tanaman hias populer dengan seludang bunga tipis menyerupai kertas berwarna ungu kemerahan atau magenta cerah. '
          'Tahan terhadap cuaca panas dan kemarau.',
      careTip: 'Kurangi penyiraman sesekali untuk merangsang munculnya bunga lebat.',
      primaryColor: Color(0xFFAD1457),
      secondaryColor: Color(0xFFFCE4EC),
      targetHue: 318.0,
    ),
    FlowerInfo(
      id: 'kamboja',
      name: 'Bunga Kamboja',
      latinName: 'Plumeria rubra',
      description:
          'Bunga beraroma harum dengan lima kelopak tebal bergradasi putih dan kuning di bagian tengahnya. '
          'Sering dijumpai di taman tropis dan halaman rumah.',
      careTip: 'Sangat menyukai sinar matahari penuh dan tidak memerlukan terlalu banyak air.',
      primaryColor: Color(0xFFFFB300),
      secondaryColor: Color(0xFFFFFDE7),
      targetHue: 55.0,
      isWhiteOrNeutral: true,
    ),
  ];

  static FlowerInfo getById(String id) {
    return dataset.firstWhere(
      (f) => f.id == id,
      orElse: () => dataset.first,
    );
  }

  /// Menganalisis gambar dari kamera/galeri dan mengembalikan 3 kecocokan teratas
  static Future<ScanResultData> classifyImage(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);

    double avgHue = 350.0;
    double avgSat = 0.5;
    double avgVal = 0.7;

    if (decoded != null) {
      final resized = img.copyResize(decoded, width: 64, height: 64);
      // Fokus pada area tengah gambar (lokasi bunga dibidik)
      double sumSin = 0;
      double sumCos = 0;
      double sumSat = 0;
      double sumVal = 0;
      int count = 0;

      for (int y = 16; y < 48; y++) {
        for (int x = 16; x < 48; x++) {
          final pixel = resized.getPixel(x, y);
          final r = pixel.r / 255.0;
          final g = pixel.g / 255.0;
          final b = pixel.b / 255.0;

          final maxC = max(r, max(g, b));
          final minC = min(r, min(g, b));
          final delta = maxC - minC;

          double hue = 0;
          if (delta > 0.0001) {
            if (maxC == r) {
              hue = 60 * (((g - b) / delta) % 6);
            } else if (maxC == g) {
              hue = 60 * (((b - r) / delta) + 2);
            } else {
              hue = 60 * (((r - g) / delta) + 4);
            }
          }
          if (hue < 0) hue += 360;

          final sat = maxC == 0 ? 0.0 : delta / maxC;
          final val = maxC;

          // Bobot lebih tinggi untuk piksel berwarna mencolok (kelopak bunga)
          final weight = 0.3 + sat;
          final rad = hue * pi / 180.0;
          sumSin += sin(rad) * weight;
          sumCos += cos(rad) * weight;
          sumSat += sat;
          sumVal += val;
          count++;
        }
      }

      if (count > 0) {
        avgHue = (atan2(sumSin, sumCos) * 180.0 / pi);
        if (avgHue < 0) avgHue += 360;
        avgSat = sumSat / count;
        avgVal = sumVal / count;
      }
    }

    // Hitung skor jarak warna terhadap setiap bunga di dataset
    final scored = dataset.map((flower) {
      double distance;
      if (avgSat < 0.22 && avgVal > 0.65) {
        // Objek dominan putih/cerah
        distance = flower.isWhiteOrNeutral ? 12.0 : 95.0;
      } else {
        double hueDiff = (avgHue - flower.targetHue).abs();
        if (hueDiff > 180) hueDiff = 360 - hueDiff;
        distance = hueDiff + (flower.isWhiteOrNeutral ? 35.0 : 0.0);
      }
      return MapEntry(flower, distance);
    }).toList();

    scored.sort((a, b) => a.value.compareTo(b.value));

    // Ambil 3 terbaik & konversi ke persentase kemiripan yang realistis
    final top3 = scored.take(3).toList();
    final p1 = (94 - (top3[0].value * 0.15)).clamp(76, 96).round();
    final p2 = (p1 - 14 - (top3[1].value * 0.06)).clamp(54, p1 - 8).round();
    final p3 = (p2 - 11 - (top3[2].value * 0.05)).clamp(38, p2 - 7).round();

    final matches = [
      FlowerMatch(flower: top3[0].key, similarityPercent: p1),
      FlowerMatch(flower: top3[1].key, similarityPercent: p2),
      FlowerMatch(flower: top3[2].key, similarityPercent: p3),
    ];

    return ScanResultData(
      capturedImagePath: imagePath,
      matches: matches,
      timestamp: DateTime.now(),
    );
  }
}