import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  bool _isParent = false;
  String _userName = 'Tom';
  int _points = 0;
  int _usedPoints = 0;
  String _level = 'bronce';

  bool get isParent => _isParent;
  String get userName => _userName;
  int get points => _points;
  int get usedPoints => _usedPoints;
  String get level => _level;

  // Simplified parent mode setter
  void setParentMode(bool value) {
    debugPrint('Setting parent mode to: $value');
    _isParent = value;
    notifyListeners();
  }
  
  void resetState() {
    //_isParent = true;
    notifyListeners();
  }

  void toggleUserType() {
    _isParent = !_isParent;
    _userName = _isParent ? 'Tom' : 'Sam';
    notifyListeners();
    // Ensure the state is properly updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> refreshUser() async {    
    notifyListeners();
  }

  void addPoints(int amount) {
    _points += amount;
    _updateLevel();
    notifyListeners();
  }

  void updatePoints(int amount) {
    _points = amount;
    _updateLevel();
    notifyListeners();
  }

  void deductPoints(int amount) {
    _usedPoints += amount;        
    _updateLevel();
    notifyListeners();
  }   

  void _updateLevel() {
    if (_points <= 499) {
      _level = 'bronce';
    } else if (_points <= 1499) {
      _level = 'plata';
    } else {
      _level = 'oro';
    }
  }
}