class AppConstants {
  static const String appName = 'KidsRewards';
  
  // Routes
  static const String homeRoute = '/';
  static const String parentDashboardRoute = '/parent_dashboard';
  static const String childDashboardRoute = '/child_dashboard';
  static const String taskTemplatesRoute = '/task_templates';
  static const String taskEditorRoute = '/task_editor';
  static const String rewardTemplatesRoute = '/reward_templates';
  static const String rewardEditorRoute = '/reward_editor';
  static const String avatarCustomizationRoute = '/avatar_customization';
  static const String pendingTasksRoute = '/pending_tasks';
  static const String availableRewardsRoute = '/available_rewards';

  // Asset paths
  static const String avatarBasePath = 'assets/avatars/';
  static const String taskIconsPath = 'assets/task_icons/';
  static const String rewardIconsPath = 'assets/reward_icons/';
  static const String accessoriesPath = 'assets/accessories/';

  // Levels
  static const Map<String, int> levelThresholds = {
    'bronce': 0,
    'plata': 500,
    'oro': 1500,
  };

  // Task difficulty levels
  static const Map<int, String> difficultyLevels = {
    1: 'Muy fácil',
    2: 'Fácil',
    3: 'Medio',
    4: 'Difícil',
    5: 'Muy difícil',
  };

  // Points per difficulty level
  static const Map<int, int> pointsPerDifficulty = {
    1: 20,
    2: 40,
    3: 60,
    4: 80,
    5: 100,
  };
}
