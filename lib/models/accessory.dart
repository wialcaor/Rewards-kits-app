import 'package:flutter/foundation.dart';// Import your Task model
import '../utils/data.dart';

class Accessory extends ChangeNotifier {
  String id;  
  int points;
  String imageUrl;
  String thumbnail;
  bool isVisible;
  String type;

  Accessory({
    required this.id,
    required this.points,
    required this.imageUrl,
    required this.thumbnail,
    required this.type,
    this.isVisible = false,
  });
}

class AccessoryProvider with ChangeNotifier {  
  final List<Accessory> _accessories = accessoryData.cast<Accessory>(); // Cast to List<accessory>
  List<Accessory> get accessories => _accessories;  
  final List<Accessory> _savedAccessories = [];
  List<Accessory> get savedAccessories => _savedAccessories;
  final List<Accessory> _purchasedAccessories = [];
  List<Accessory> get purchasedAccessories => _purchasedAccessories;

  final List<Accessory> _selectedAccessories = [];
  List<Accessory> get selectedAccessories => _selectedAccessories;
  
  Future<void> refreshAccessories() async {
    notifyListeners();
  }
  
  void setSelectedAccessories(List<Accessory> newAccessories) {
    _selectedAccessories.clear();
    _selectedAccessories.addAll(newAccessories);

    notifyListeners();
  }

  void saveAccessories() {
    _savedAccessories.clear();
    _savedAccessories.addAll(selectedAccessories);
    notifyListeners();
  } 

  void undoChanges() {
    _selectedAccessories.clear();
    _selectedAccessories.addAll(_savedAccessories);
    notifyListeners();    
  }

  void addAccessory(Accessory accessory) {
    _selectedAccessories.add(accessory);
    notifyListeners();
    print(_savedAccessories.length);
  }

  void removeAccessory(Accessory accessory) {
    _selectedAccessories.remove(accessory);
    notifyListeners();
  }  
}