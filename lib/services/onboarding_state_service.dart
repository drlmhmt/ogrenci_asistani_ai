import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSelection {
  const OnboardingSelection({
    required this.goalIndex,
    required this.goalText,
    this.examKey,
    this.examTitle,
    this.fieldKey,
    this.fieldTitle,
    this.targetScore,
  });

  final int goalIndex;
  final String goalText;
  final String? examKey;
  final String? examTitle;
  final String? fieldKey;
  final String? fieldTitle;
  final double? targetScore;
}

class OnboardingStateService {
  static const String _seenKey = 'onboarding_seen';
  static const String _goalIndexKey = 'onboarding_goal_index';
  static const String _goalTextKey = 'onboarding_goal_text';
  static const String _examKey = 'onboarding_exam_key';
  static const String _examTitleKey = 'onboarding_exam_title';
  static const String _fieldKey = 'onboarding_field_key';
  static const String _fieldTitleKey = 'onboarding_field_title';
  static const String _targetScoreKey = 'onboarding_target_score';
  static const String _completedAtKey = 'onboarding_completed_at';

  Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenKey) ?? false;
  }

  Future<void> setCompleted({
    required int goalIndex,
    required String goalText,
    String? examKey,
    String? examTitle,
    String? fieldKey,
    String? fieldTitle,
    double? targetScore,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
    await prefs.setInt(_goalIndexKey, goalIndex);
    await prefs.setString(_goalTextKey, goalText);
    if (examKey != null) {
      await prefs.setString(_examKey, examKey);
    }
    if (examTitle != null) {
      await prefs.setString(_examTitleKey, examTitle);
    }
    if (fieldKey != null) {
      await prefs.setString(_fieldKey, fieldKey);
    }
    if (fieldTitle != null) {
      await prefs.setString(_fieldTitleKey, fieldTitle);
    }
    if (targetScore != null) {
      await prefs.setDouble(_targetScoreKey, targetScore);
    }
    await prefs.setInt(_completedAtKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<OnboardingSelection?> getSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final goalIndex = prefs.getInt(_goalIndexKey);
    final goalText = prefs.getString(_goalTextKey);

    if (goalIndex == null || goalText == null || goalText.isEmpty) {
      return null;
    }

    return OnboardingSelection(
      goalIndex: goalIndex,
      goalText: goalText,
      examKey: prefs.getString(_examKey),
      examTitle: prefs.getString(_examTitleKey),
      fieldKey: prefs.getString(_fieldKey),
      fieldTitle: prefs.getString(_fieldTitleKey),
      targetScore: prefs.getDouble(_targetScoreKey),
    );
  }
}
