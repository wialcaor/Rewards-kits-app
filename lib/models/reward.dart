import 'package:flutter/foundation.dart';// Import your Task model
import '../utils/data.dart';

class Reward extends ChangeNotifier {
  String id;
  String name;
  String description;
  int points;
  String imageUrl;
  bool isAvailable;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.imageUrl,
    this.isAvailable = true,
  });
}

class RewardProvider with ChangeNotifier {  
  final List<Reward> _rewards = rewardsData.sublist(rewardsData.length -3).cast<Reward>(); // Cast to List<Reward>
  List<Reward> get rewards => _rewards;

  Future<void> refreshRewards() async {    
    notifyListeners();
  }
  
  void addTask(Reward reward) {
    _rewards.add(reward);
    notifyListeners();
  }

  void updateTask(Reward updatedRewardk) {
    final existingRewardIndex = _rewards.indexWhere((r) => r.id == updatedRewardk.id);
    _rewards[existingRewardIndex] = updatedRewardk;
    notifyListeners();    
  }

  void removeTask(String rewardId) {
    _rewards.removeWhere((reward) => reward.id == rewardId);
    notifyListeners();
  }
}