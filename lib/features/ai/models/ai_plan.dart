import '../../../life_engine/models/goal.dart';  // ← 修正路径
import '../data/mock_ai_responses.dart';

class AiPlanPhase {
  final String id;
  final String name;
  final String description;
  final String timeRange;
  final List<String> subtasks;
  final bool isCompleted;

  const AiPlanPhase({
    required this.id,
    required this.name,
    required this.description,
    required this.timeRange,
    this.subtasks = const [],
    this.isCompleted = false,
  });

  AiPlanPhase copyWith({
    String? id,
    String? name,
    String? description,
    String? timeRange,
    List<String>? subtasks,
    bool? isCompleted,
  }) {
    return AiPlanPhase(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      timeRange: timeRange ?? this.timeRange,
      subtasks: subtasks ?? this.subtasks,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class AiPlan {
  final String id;
  final Goal goal;
  final String analysisSummary;
  final String difficulty;
  final String duration;
  final String frequency;
  final List<AiPlanPhase> phases;
  final String todayAction;

  const AiPlan({
    required this.id,
    required this.goal,
    required this.analysisSummary,
    required this.difficulty,
    required this.duration,
    required this.frequency,
    required this.phases,
    required this.todayAction,
  });

  factory AiPlan.fromGoal(Goal goal) {
    final data = MockAiResponses.getPlanForGoal(goal);
    return AiPlan(
      id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
      goal: goal,
      analysisSummary: data['summary'] as String,
      difficulty: data['difficulty'] as String,
      duration: data['duration'] as String,
      frequency: data['frequency'] as String,
      phases: (data['phases'] as List<Map<String, dynamic>>).map((phaseData) {
        return AiPlanPhase(
          id: 'phase_${DateTime.now().millisecondsSinceEpoch}_${phaseData['name']}',
          name: phaseData['name'] as String,
          description: phaseData['description'] as String,
          timeRange: phaseData['timeRange'] as String,
          subtasks: (phaseData['subtasks'] as List<dynamic>).cast<String>(),
        );
      }).toList(),
      todayAction: data['todayAction'] as String,
    );
  }
}