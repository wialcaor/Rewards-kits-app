class Avatar {
  final String id;
  String name;
  String baseImageUrl;
  List<String> accessories;
  Map<String, bool> unlockedAccessories;

  Avatar({
    required this.id,
    required this.name,
    required this.baseImageUrl,
    List<String>? accessories,
    Map<String, bool>? unlockedAccessories,
  })  : accessories = accessories ?? [],
        unlockedAccessories = unlockedAccessories ?? {};

  void unlockAccessory(String accessoryId) {
    unlockedAccessories[accessoryId] = true;
  }

  bool isAccessoryUnlocked(String accessoryId) {
    return unlockedAccessories[accessoryId] ?? false;
  }

  void addAccessory(String accessoryId) {
    if (!accessories.contains(accessoryId)) {
      accessories.add(accessoryId);
    }
  }

  void removeAccessory(String accessoryId) {
    accessories.remove(accessoryId);
  }
}