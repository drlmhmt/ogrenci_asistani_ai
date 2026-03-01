import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSelection {
  const OnboardingSelection({required this.goalIndex, required this.goalText});

  final int goalIndex;
  final String goalText;
}

class OnboardingStateService {
  static const String _seenKey = 'onboarding_seen';
  static const String _goalIndexKey = 'onboarding_goal_index';
  static const String _goalTextKey = 'onboarding_goal_text';
  static const String _completedAtKey = 'onboarding_completed_at';

  Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenKey) ?? false;
  }

  Future<void> setCompleted({
    required int goalIndex,
    required String goalText,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
    await prefs.setInt(_goalIndexKey, goalIndex);
    await prefs.setString(_goalTextKey, goalText);
    await prefs.setInt(_completedAtKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<OnboardingSelection?> getSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final goalIndex = prefs.getInt(_goalIndexKey);
    final goalText = prefs.getString(_goalTextKey);

    if (goalIndex == null || goalText == null || goalText.isEmpty) {
      return null;
    }

    return OnboardingSelection(goalIndex: goalIndex, goalText: goalText);
  }
}
