import 'package:flutter/material.dart';

class FlowerInfo {
  final String id;
  final String name;
  final String latinName;
  final String description;
  final String careTip;
  final Color primaryColor;
  final Color secondaryColor;
  final double targetHue;
  final bool isWhiteOrNeutral;

  const FlowerInfo({
    required this.id,
    required this.name,
    required this.latinName,
    required this.description,
    required this.careTip,
    required this.primaryColor,
    required this.secondaryColor,
    required this.targetHue,
    this.isWhiteOrNeutral = false,
  });
}

class FlowerMatch {
  final FlowerInfo flower;
  final int similarityPercent;

  const FlowerMatch({
    required this.flower,
    required this.similarityPercent,
  });

  Map<String, dynamic> toJson() {
    return {
      'flowerId': flower.id,
      'similarityPercent': similarityPercent,
    };
  }
}

class ScanResultData {
  final String capturedImagePath;
  final List<FlowerMatch> matches;
  final DateTime timestamp;

  const ScanResultData({
    required this.capturedImagePath,
    required this.matches,
    required this.timestamp,
  });
}

class HistoryRecord {
  final String id;
  final String imagePath;
  final List<FlowerMatch> matches;
  final DateTime timestamp;

  const HistoryRecord({
    required this.id,
    required this.imagePath,
    required this.matches,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'matches': matches.map((m) => m.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}