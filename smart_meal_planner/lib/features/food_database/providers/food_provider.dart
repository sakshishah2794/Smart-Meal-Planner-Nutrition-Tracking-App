import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../../features/food_database/data/food_item.dart';
import '../../../services/hive_service.dart';
import 'package:uuid/uuid.dart';

class FoodProvider extends ChangeNotifier {
  static const _uuid = Uuid();
  List<FoodItem> _allFoods = [];
  List<FoodItem> _filteredFoods = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<FoodItem> get allFoods => _allFoods;
  List<FoodItem> get filteredFoods => _filteredFoods;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  FoodProvider() {
    loadFoods();
  }

  void loadFoods() {
    final box = HiveService.getFoodBox();
    _allFoods = box.values.toList();
    _applyFilters();
    notifyListeners();
  }

  void searchFoods(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredFoods = _allFoods.where((food) {
      final matchesSearch = _searchQuery.isEmpty ||
          food.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          food.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    _filteredFoods.sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> addCustomFood(FoodItem food) async {
    final customFood = food.copyWith(
      id: _uuid.v4(),
      isCustom: true,
      category: 'Custom',
    );
    final box = HiveService.getFoodBox();
    await box.put(customFood.id, customFood);
    loadFoods();
  }

  Future<void> deleteFood(String id) async {
    final box = HiveService.getFoodBox();
    await box.delete(id);
    loadFoods();
  }

  FoodItem? getFoodById(String id) {
    try {
      return _allFoods.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }
}
