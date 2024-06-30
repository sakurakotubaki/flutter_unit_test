import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

/// flutter pub run build_runner watch --delete-conflicting-outputs
// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<Cat>()])
import 'cat_test.mocks.mocks.dart';

// Real class
class Cat {
  String sound() => "Meow";
  bool eatFood(String food, {bool? hungry}) => true;
  Future<void> chew() async => print("Chewing...");
  int walk(List<String> places) => 7;
  void sleep() {}
  void hunt(String place, String prey) {}
  int lives = 9;
}

void main() {
  test('mockito', () {
    // Create a MockCat object.
    var cat = MockCat();

    // Stub a mock method before interacting.
    when(cat.sound()).thenReturn("Purr");
    expect(cat.sound(), "Purr");

// You can call it again.
    expect(cat.sound(), "Purr");

// Let's change the stub.
    when(cat.sound()).thenReturn("Meow");
    expect(cat.sound(), "Meow");

// You can stub getters.
    when(cat.lives).thenReturn(9);
    expect(cat.lives, 9);

// You can stub a method to throw.
    when(cat.lives).thenThrow(RangeError('Boo'));
    expect(() => cat.lives, throwsRangeError);

// We can calculate a response at call time.
    var responses = ["Purr", "Meow"];
    when(cat.sound()).thenAnswer((_) => responses.removeAt(0));
    expect(cat.sound(), "Purr");
    expect(cat.sound(), "Meow");

// We can stub a method with multiple calls that happened in a particular order.
    when(cat.sound()).thenReturnInOrder(["Purr", "Meow"]);
    expect(cat.sound(), "Purr");
    expect(cat.sound(), "Meow");
    expect(() => cat.sound(), throwsA(isA<StateError>()));
  });
}
