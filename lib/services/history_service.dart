import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/flower_model.dart';
import 'flower_classifier.dart';

class HistoryService {
  static final ValueNotifier<List<HistoryRecord>> historyNotifier =
      ValueNotifier<List<HistoryRecord>>([]);

  static bool _initialized = false;

  static Future<File> _getHistoryFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/plantknow_history.json');
  }

  static HistoryRecord _recordFromJson(Map<String, dynamic> json) {
    final rawMatches = json['matches'] as List<dynamic>;
    final parsedMatches = rawMatches.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      final flower = FlowerClassifier.getById(map['flowerId'] as String);
      return FlowerMatch(
        flower: flower,
        similarityPercent: map['similarityPercent'] as int,
      );
    }).toList();

    return HistoryRecord(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      matches: parsedMatches,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    try {
      final file = await _getHistoryFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> list = jsonDecode(content) as List<dynamic>;
        historyNotifier.value = list
            .map((e) => _recordFromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (_) {
      historyNotifier.value = [];
    }
  }

  static Future<void> saveScanResult(ScanResultData result) async {
    await init();
    final dir = await getApplicationDocumentsDirectory();
    final imgDir = Directory('${dir.path}/scanned_flowers');
    if (!await imgDir.exists()) {
      await imgDir.create(recursive: true);
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final savedImage = await File(result.capturedImagePath)
        .copy('${imgDir.path}/flower_$id.jpg');

    final record = HistoryRecord(
      id: id,
      imagePath: savedImage.path,
      matches: result.matches,
      timestamp: result.timestamp,
    );

    final updated = [record, ...historyNotifier.value];
    historyNotifier.value = updated;

    final file = await _getHistoryFile();
    await file.writeAsString(
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> deleteRecord(String id) async {
    final updated =
        historyNotifier.value.where((item) => item.id != id).toList();
    historyNotifier.value = updated;
    final file = await _getHistoryFile();
    await file.writeAsString(
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }

  static ScanResultData toScanResultData(HistoryRecord record) {
    return ScanResultData(
      capturedImagePath: record.imagePath,
      matches: record.matches,
      timestamp: record.timestamp,
    );
  }
}