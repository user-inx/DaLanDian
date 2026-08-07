import '../models/goal.dart';

class MockRepository {
  static const List<Goal> mockGoals = [];

  Future<List<Goal>> loadGoals() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return mockGoals;
  }
}