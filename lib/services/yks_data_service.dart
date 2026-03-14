import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/yks_exam_data.dart';

/// YKS sınav verilerini yükleyen servis.
/// Öncelik: Firestore (güncel) → Assets (varsayılan)
class YksDataService {
  static const String _firestoreCollection = 'yks_exam_data';
  static const String _currentDocId = 'current';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Güncel YKS verisini getirir.
  /// Firestore'da varsa oradan, yoksa assets'teki JSON'dan okur.
  Future<YksExamSeason> getCurrentYksData() async {
    try {
      final remote = await _getFromFirestore();
      if (remote != null) return remote;
    } catch (_) {
      // Firestore yoksa veya hata varsa assets'e düş
    }
    return _getFromAssets();
  }

  /// Firestore'dan veri çeker (admin tarafından güncellenebilir)
  Future<YksExamSeason?> _getFromFirestore() async {
    final doc = await _firestore
        .collection(_firestoreCollection)
        .doc(_currentDocId)
        .get();

    if (!doc.exists || doc.data() == null) return null;

    return YksExamSeason.fromJson(doc.data()!);
  }

  /// Assets'teki varsayılan JSON'dan okur
  Future<YksExamSeason> _getFromAssets() async {
    final jsonStr = await rootBundle.loadString(
      'assets/data/yks_2025_example.json',
    );
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return YksExamSeason.fromJson(json);
  }

  /// Firestore'a yeni YKS verisi yazar (admin paneli veya script ile)
  static Future<void> updateYksDataInFirestore(YksExamSeason season) async {
    await FirebaseFirestore.instance
        .collection(_firestoreCollection)
        .doc(_currentDocId)
        .set(season.toJson());
  }
}
