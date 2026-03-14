

/// YKS (TYT/AYT) sınav veri modeli
/// Her yıl güncellenebilir yapı - Türkiye YKS şartlarına uygun Sınav türü: TYT veya AYT
enum YksExamType { tyt, ayt }

/// AYT alan türü (Sayısal, Eşit Ağırlık, Sözel)
enum AytFieldType { sayisal, esitAgirlik, sozel }

/// Tek bir YKS sınav dönemi (örn: 2025)
class YksExamSeason {
  final String year; // "2025"
  final DateTime updatedAt;
  final List<YksExam> exams; // TYT ve AYT

  const YksExamSeason({
    required this.year,
    required this.updatedAt,
    required this.exams,
  });

  factory YksExamSeason.fromJson(Map<String, dynamic> json) {
    return YksExamSeason(
      year: json['year'] as String,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      exams: (json['exams'] as List)
          .map((e) => YksExam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'year': year,
        'updatedAt': updatedAt.toIso8601String(),
        'exams': exams.map((e) => e.toJson()).toList(),
      };
}

/// Tek sınav: TYT veya AYT
class YksExam {
  final YksExamType type;
  final String name; // "TYT" veya "AYT"
  final int totalQuestions;
  final List<YksSubject> subjects;

  const YksExam({
    required this.type,
    required this.name,
    required this.totalQuestions,
    required this.subjects,
  });

  factory YksExam.fromJson(Map<String, dynamic> json) {
    return YksExam(
      type: json['type'] == 'ayt' ? YksExamType.ayt : YksExamType.tyt,
      name: json['name'] as String,
      totalQuestions: json['totalQuestions'] as int,
      subjects: (json['subjects'] as List)
          .map((e) => YksSubject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type == YksExamType.ayt ? 'ayt' : 'tyt',
        'name': name,
        'totalQuestions': totalQuestions,
        'subjects': subjects.map((e) => e.toJson()).toList(),
      };
}

/// Ders (Türkçe, Matematik, Fizik vb.)
class YksSubject {
  final String id;
  final String name;
  final int questionCount; // Bu dersten sınavda toplam soru sayısı
  final AytFieldType? fieldType; // AYT için: sayisal, esitAgirlik, sozel
  final List<YksTopic> topics;

  const YksSubject({
    required this.id,
    required this.name,
    required this.questionCount,
    this.fieldType,
    required this.topics,
  });

  factory YksSubject.fromJson(Map<String, dynamic> json) {
    AytFieldType? field;
    if (json['fieldType'] != null) {
      switch (json['fieldType'] as String) {
        case 'sayisal':
          field = AytFieldType.sayisal;
          break;
        case 'esitAgirlik':
          field = AytFieldType.esitAgirlik;
          break;
        case 'sozel':
          field = AytFieldType.sozel;
          break;
      }
    }
    return YksSubject(
      id: json['id'] as String,
      name: json['name'] as String,
      questionCount: json['questionCount'] as int,
      fieldType: field,
      topics: (json['topics'] as List)
          .map((e) => YksTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'questionCount': questionCount,
        if (fieldType != null) 'fieldType': fieldType!.name,
        'topics': topics.map((e) => e.toJson()).toList(),
      };
}

/// Konu - ortalama soru sayısı ile
class YksTopic {
  final String id;
  final String name;
  final double averageQuestionCount; // Sınavda ortalama kaç soru çıkıyor
  final int? order; // Müfredat sırası

  const YksTopic({
    required this.id,
    required this.name,
    required this.averageQuestionCount,
    this.order,
  });

  factory YksTopic.fromJson(Map<String, dynamic> json) {
    return YksTopic(
      id: json['id'] as String,
      name: json['name'] as String,
      averageQuestionCount: (json['averageQuestionCount'] as num).toDouble(),
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'averageQuestionCount': averageQuestionCount,
        if (order != null) 'order': order,
      };
}
