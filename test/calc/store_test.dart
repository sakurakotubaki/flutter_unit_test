import 'package:flutter_test/flutter_test.dart';

enum Product { Shampoo, Book }

class Store {
  Map<Product, int> _inventory = {};

  void addInventory(Product product, int quantity) {
    _inventory[product] = quantity;
  }

  int getInventory(Product product) {
    return _inventory[product] ?? 0;
  }

  bool purchase(Product product, int quantity) {
    if (_inventory[product] == null || _inventory[product]! < quantity) {
      return false;
    }
    _inventory[product] = _inventory[product]! - quantity;
    return true;
  }
}

void main() {
  test('Purchase succeeds when enough inventory', () {
    // Arrange
    var store = Store();
    store.addInventory(Product.Shampoo, 10);

    // Act
    bool success = store.purchase(Product.Shampoo, 5);

    // Assert
    expect(success, true);
    expect(store.getInventory(Product.Shampoo), 5);
  });

  test('Purchase fails when not enough inventory', () {
    // Arrange
    var store = Store();
    store.addInventory(Product.Shampoo, 10);

    // Act
    bool success = store.purchase(Product.Shampoo, 15);

    // Assert
    expect(success, false);
    expect(store.getInventory(Product.Shampoo), 10);
  });
}
