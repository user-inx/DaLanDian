import 'package:app/life_engine/models/goal.dart';
import 'package:app/life_engine/mock/mock_goals.dart';
import 'package:app/life_engine/repository/life_repository.dart';

class MockRepository implements LifeRepository {

  @override
  Future<List<Goal>> loadGoals() async {

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    return mockGoals;
  }

  @override
  Future<void> saveGoal(Goal goal) async {}

  @override
  Future<void> deleteGoal(String id) async {}

}