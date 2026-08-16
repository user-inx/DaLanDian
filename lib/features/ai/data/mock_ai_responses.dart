import '../../../life_engine/models/goal.dart';      // ← 新增
import '../../../life_engine/enums/goal_category.dart';  // ← 新增

class MockAiResponses {
  static Map<String, dynamic> getPlanForGoal(Goal goal) {
    switch (goal.category) {
      case GoalCategory.health:
        return _healthPlan(goal);
      case GoalCategory.career:
        return _careerPlan(goal);
      case GoalCategory.wealth:
        return _wealthPlan(goal);
      case GoalCategory.learning:
        return _learningPlan(goal);
      case GoalCategory.family:
        return _familyPlan(goal);
      default:
        return _generalPlan(goal);
    }
  }

  static Map<String, dynamic> _healthPlan(Goal goal) {
    return {
      'summary': '这个目标非常可行！健康类目标的关键在于把大目标拆解成每日可执行的小行动。建议从建立微习惯开始，逐步提升强度。',
      'difficulty': '中等',
      'duration': '3个月',
      'frequency': '每天',
      'phases': [
        {
          'name': '阶段 1：基础习惯建立',
          'description': '用前两周建立核心习惯，不要追求完美，先做到持续',
          'timeRange': '第 1-2 周',
          'subtasks': ['每天固定时间运动 15 分钟', '记录每日饮食', '保证 7 小时睡眠'],
        },
        {
          'name': '阶段 2：持续执行与优化',
          'description': '习惯稳定后，逐步增加强度和优化细节',
          'timeRange': '第 3-8 周',
          'subtasks': ['运动时间增加到 30 分钟', '优化饮食结构', '每周测量一次身体数据'],
        },
        {
          'name': '阶段 3：巩固成果',
          'description': '让健康成为生活的一部分，建立长期机制',
          'timeRange': '第 9-12 周',
          'subtasks': ['找到喜欢的运动方式', '建立饮食记录习惯', '定期体检跟踪数据'],
        },
      ],
      'todayAction': '今天：步行 30 分钟，晚餐控制碳水摄入，记录体重',
    };
  }

  static Map<String, dynamic> _careerPlan(Goal goal) {
    return {
      'summary': '事业目标需要清晰的路线图和持续的执行力。建议先明确核心技能方向，再制定阶段性里程碑。',
      'difficulty': '较高',
      'duration': '6个月',
      'frequency': '每周 5 天',
      'phases': [
        {
          'name': '阶段 1：明确方向',
          'description': '确定你的核心竞争力和目标岗位要求',
          'timeRange': '第 1-4 周',
          'subtasks': ['分析目标岗位要求', '盘点现有技能', '制定学习路线'],
        },
        {
          'name': '阶段 2：技能提升',
          'description': '集中时间提升最关键的 3 项技能',
          'timeRange': '第 5-16 周',
          'subtasks': ['每天投入 2 小时学习', '完成至少一个项目作品', '拓展行业人脉'],
        },
        {
          'name': '阶段 3：成果落地',
          'description': '将学习成果转化为实际价值',
          'timeRange': '第 17-24 周',
          'subtasks': ['更新简历和作品集', '主动争取项目机会', '定期复盘职业进展'],
        },
      ],
      'todayAction': '今天：花 30 分钟分析目标岗位的 JD，列出 5 项核心要求',
    };
  }

  static Map<String, dynamic> _wealthPlan(Goal goal) {
    return {
      'summary': '财务目标需要耐心和纪律。关键是把大目标拆解成可执行的财务行动，并定期追踪进度。',
      'difficulty': '中等',
      'duration': '6个月',
      'frequency': '每周',
      'phases': [
        {
          'name': '阶段 1：财务盘点',
          'description': '全面了解当前的财务状况，建立基准',
          'timeRange': '第 1-4 周',
          'subtasks': ['记账统计月支出', '盘点资产和负债', '设定储蓄目标'],
        },
        {
          'name': '阶段 2：执行与优化',
          'description': '优化支出结构，开始执行储蓄和投资计划',
          'timeRange': '第 5-16 周',
          'subtasks': ['减少非必要支出', '建立自动储蓄', '学习基础投资知识'],
        },
        {
          'name': '阶段 3：持续增长',
          'description': '建立长期财务增长机制',
          'timeRange': '第 17-24 周',
          'subtasks': ['评估投资回报', '调整资产配置', '制定下阶段计划'],
        },
      ],
      'todayAction': '今天：下载记账 App，开始记录本周的每一笔支出',
    };
  }

  static Map<String, dynamic> _learningPlan(Goal goal) {
    return {
      'summary': '学习目标最需要的是持续性和方法。建议采用"刻意练习 + 定期测试"的方式加速成长。',
      'difficulty': '中等',
      'duration': '3个月',
      'frequency': '每天',
      'phases': [
        {
          'name': '阶段 1：基础入门',
          'description': '建立知识框架，掌握核心概念',
          'timeRange': '第 1-4 周',
          'subtasks': ['每天学习 1 小时', '完成基础课程', '做好学习笔记'],
        },
        {
          'name': '阶段 2：深度实践',
          'description': '通过实践项目巩固知识',
          'timeRange': '第 5-10 周',
          'subtasks': ['完成 2-3 个实践项目', '参与学习社区讨论', '定期回顾总结'],
        },
        {
          'name': '阶段 3：产出成果',
          'description': '将学习成果转化为可见的产出',
          'timeRange': '第 11-12 周',
          'subtasks': ['整理学习笔记为文章', '制作成果展示', '制定后续计划'],
        },
      ],
      'todayAction': '今天：安排 1 小时的专注学习时间，关掉手机通知',
    };
  }

  static Map<String, dynamic> _familyPlan(Goal goal) {
    return {
      'summary': '家庭目标需要平衡和耐心。建议用小行动建立良好的家庭关系基础。',
      'difficulty': '中等',
      'duration': '3个月',
      'frequency': '每周',
      'phases': [
        {
          'name': '阶段 1：建立连接',
          'description': '创造更多有质量的家庭时间',
          'timeRange': '第 1-4 周',
          'subtasks': ['每周安排一次家庭活动', '每天 15 分钟专注交流', '记录家庭美好瞬间'],
        },
        {
          'name': '阶段 2：深化关系',
          'description': '通过共同目标增强家庭凝聚力',
          'timeRange': '第 5-10 周',
          'subtasks': ['一起制定家庭计划', '共同完成一个小项目', '定期家庭会议'],
        },
        {
          'name': '阶段 3：持续经营',
          'description': '让家庭关系成为生活的基石',
          'timeRange': '第 11-12 周',
          'subtasks': ['建立家庭传统', '定期回顾家庭目标', '规划长期家庭愿景'],
        },
      ],
      'todayAction': '今天：给家人一个真诚的拥抱，说一句"谢谢你"',
    };
  }

  static Map<String, dynamic> _generalPlan(Goal goal) {
    return {
      'summary': '这是一个值得投入的目标。建议按照"明确目标 → 拆解步骤 → 持续执行"的路径推进。',
      'difficulty': '中等',
      'duration': '3个月',
      'frequency': '每周 5 天',
      'phases': [
        {
          'name': '阶段 1：明确目标',
          'description': '清晰定义你想要达成的结果',
          'timeRange': '第 1-2 周',
          'subtasks': ['写下具体的目标描述', '设定可衡量的指标', '确定时间节点'],
        },
        {
          'name': '阶段 2：计划执行',
          'description': '按计划稳步推进，定期检查进度',
          'timeRange': '第 3-10 周',
          'subtasks': ['每天推进一小步', '每周复盘一次', '及时调整策略'],
        },
        {
          'name': '阶段 3：成果巩固',
          'description': '确保成果可持续，避免反弹',
          'timeRange': '第 11-12 周',
          'subtasks': ['总结成功经验', '制定长期维持计划', '分享你的成果'],
        },
      ],
      'todayAction': '今天：花 10 分钟写下你对这个目标的真实想法',
    };
  }

  static Map<String, String> getCoachResponse({
    required String userAction,
    required String goalTitle,
  }) {
    switch (userAction) {
      case 'completed':
        return {
          'message': '太棒了！完成今天的任务是达成目标的关键一步。你已经证明了自己可以做到。继续这样坚持，目标很快就会实现。💪',
          'suggestion': '明天继续保持这个势头，你可以的！',
        };
      case 'not_completed':
        return {
          'message': '没关系，每个人都会有状态不好的时候。重要的是不要连续放弃。我们把今天的任务重新安排到明天，保持连续性。',
          'suggestion': '现在花 1 分钟想想：是什么阻碍了今天的执行？明天如何避免？',
        };
      case 'difficulty':
        return {
          'message': '遇到困难是正常的，说明你在突破舒适区。告诉我具体遇到了什么，我们一起想办法调整。记住：计划是服务于你的，不是束缚你的。',
          'suggestion': '如果某个步骤太难，可以先降低难度，保持前进的节奏。',
        };
      default:
        return {
          'message': '继续加油！你已经有了清晰的目标和计划，现在需要的就是一步步执行。我在这里陪你。',
          'suggestion': '今天的建议：专注完成当前阶段的任务，不需要考虑太远。',
        };
    }
  }
}