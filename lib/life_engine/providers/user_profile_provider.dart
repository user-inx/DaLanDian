import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 用户人生档案
class UserProfile {
  final String name;
  final int age;
  final String city;
  final int income; // 月收入（美元）
  final int dailyFreeHours; // 每日自由时间（小时）
  final String goal; // 人生目标
  final int lifeExpectancy; // 预期寿命

  const UserProfile({
    required this.name,
    required this.age,
    required this.city,
    required this.income,
    required this.dailyFreeHours,
    required this.goal,
    this.lifeExpectancy = 90,
  });

  /// 人生进度（%）
  double get lifeProgress => age / lifeExpectancy;

  /// 剩余年数
  int get remainingYears => lifeExpectancy - age;

  UserProfile copyWith({
    String? name,
    int? age,
    String? city,
    int? income,
    int? dailyFreeHours,
    String? goal,
    int? lifeExpectancy,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      city: city ?? this.city,
      income: income ?? this.income,
      dailyFreeHours: dailyFreeHours ?? this.dailyFreeHours,
      goal: goal ?? this.goal,
      lifeExpectancy: lifeExpectancy ?? this.lifeExpectancy,
    );
  }
}

/// 用户档案 Provider
final userProfileProvider = StateProvider<UserProfile>((ref) {
  return const UserProfile(
    name: '用户',
    age: 28,
    city: '新加坡',
    income: 8000,
    dailyFreeHours: 2,
    goal: '3年内实现年收入100万',
    lifeExpectancy: 90,
  );
});

/// 用户档案 Notifier（用于修改）
final userProfileNotifierProvider = Provider((ref) {
  return UserProfileNotifier(ref);
});

class UserProfileNotifier {
  final Ref ref;

  UserProfileNotifier(this.ref);

  UserProfile get profile => ref.read(userProfileProvider);

  void updateProfile({
    String? name,
    int? age,
    String? city,
    int? income,
    int? dailyFreeHours,
    String? goal,
    int? lifeExpectancy,
  }) {
    ref.read(userProfileProvider.notifier).state =
        profile.copyWith(
          name: name,
          age: age,
          city: city,
          income: income,
          dailyFreeHours: dailyFreeHours,
          goal: goal,
          lifeExpectancy: lifeExpectancy,
        );
  }

  void updateAge(int age) {
    ref.read(userProfileProvider.notifier).state =
        profile.copyWith(age: age);
  }

  void updateGoal(String goal) {
    ref.read(userProfileProvider.notifier).state =
        profile.copyWith(goal: goal);
  }
}