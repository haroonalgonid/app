import 'package:flutter/foundation.dart';
import 'restaurantDetail_screen.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  final String restaurantId;
  final String restaurantName;

  CartItem({
    required this.menuItem,
    required this.quantity,
    required this.restaurantId,
    required this.restaurantName,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // الحصول على عناصر المطعم المحدد فقط
  List<CartItem> getRestaurantItems(String restaurantId) {
    return _items.where((item) => item.restaurantId == restaurantId).toList();
  }

  // إضافة عنصر إلى السلة
  void addToCart(CartItem item) {
    // التحقق من وجود عنصر مماثل في السلة
    int existingIndex = _items.indexWhere(
      (element) => element.menuItem.id == item.menuItem.id
    );

    if (existingIndex >= 0) {
      // زيادة الكمية إذا كان العنصر موجوداً
      _items[existingIndex].quantity += item.quantity;
    } else {
      // إضافة العنصر إذا لم يكن موجوداً
      _items.add(item);
    }
    notifyListeners();
  }

  // تحديث كمية عنصر في السلة
  void updateQuantity(String menuItemId, int quantity) {
    int index = _items.indexWhere((element) => element.menuItem.id == menuItemId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  // حذف عنصر من السلة
  void removeItem(String menuItemId) {
    _items.removeWhere((element) => element.menuItem.id == menuItemId);
    notifyListeners();
  }

  // حساب إجمالي سعر المطعم المحدد
  double getRestaurantTotal(String restaurantId) {
    double total = 0;
    for (var item in getRestaurantItems(restaurantId)) {
      total += item.menuItem.price * item.quantity;
    }
    return total;
  }

  // حساب إجمالي عدد العناصر في السلة
  int getItemCount() {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // حذف جميع عناصر مطعم محدد بعد إتمام الطلب
  void clearRestaurantCart(String restaurantId) {
    _items.removeWhere((element) => element.restaurantId == restaurantId);
    notifyListeners();
  }

  // التحقق ما إذا كانت السلة تحتوي على عناصر من مطاعم مختلفة
  bool hasMultipleRestaurants() {
    if (_items.isEmpty) return false;
    
    final firstRestaurantId = _items.first.restaurantId;
    return _items.any((item) => item.restaurantId != firstRestaurantId);
  }

  // الحصول على قائمة المطاعم الموجودة في السلة
  Map<String, String> getRestaurants() {
    Map<String, String> restaurants = {};
    for (var item in _items) {
      restaurants[item.restaurantId] = item.restaurantName;
    }
    return restaurants;
  }
}