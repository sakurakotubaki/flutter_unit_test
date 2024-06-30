import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

enum Product { Shampoo, Book }

class Store {
  bool hasEnoughInventory(Product product, int quantity) => true;
  void removeInventory(Product product, int quantity) {}
}

class MockStore extends Mock implements Store {}

void main() {
  test('Purchase succeeds when enough inventory', () {
    // Arrange
    var storeMock = MockStore();
    when(storeMock.hasEnoughInventory(Product.Shampoo, 5)).thenReturn(true);

    // Act
    bool success = storeMock.hasEnoughInventory(Product.Shampoo, 5);

    // Assert
    expect(success, true);
    verify(storeMock.removeInventory(Product.Shampoo, 5)).called(1);
  });

  test('Purchase fails when not enough inventory', () {
    // Arrange
    var storeMock = MockStore();
    when(storeMock.hasEnoughInventory(Product.Shampoo, 5)).thenReturn(false);

    // Act
    bool success = storeMock.hasEnoughInventory(Product.Shampoo, 5);

    // Assert
    expect(success, false);
    verifyNever(storeMock.removeInventory(Product.Shampoo, 5));
  });
}
