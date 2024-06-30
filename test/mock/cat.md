## mockito
[mockito](https://pub.dev/packages/mockito)

testディレクトリに、cat_test.mocks.dartファイルを作成します。

このコードは、Mockitoというモックライブラリを使用して、Catクラスのメソッドの振る舞いをテストするためのものです。
モックオブジェクトを使用すると、実際のオブジェクトの代わりにテストで使用でき、その振る舞いを制御することができます。
これにより、テストはより予測可能で再現可能になります。

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

/// flutter pub run build_runner watch --delete-conflicting-outputs
// アノテーションはcat.mocks.dartライブラリとMockCatクラスを生成します。
@GenerateNiceMocks([MockSpec<Cat>()])
import 'cat_test.mocks.mocks.dart';

// 実際のクラス
class Cat {
  String sound() => "Meow";  // 猫の鳴き声を返す
  bool eatFood(String food, {bool? hungry}) => true;  // 猫が食べ物を食べる
  Future<void> chew() async => print("Chewing...");  // 猫が食べ物を噛む
  int walk(List<String> places) => 7;  // 猫が歩く
  void sleep() {}  // 猫が寝る
  void hunt(String place, String prey) {}  // 猫が狩りをする
  int lives = 9;  // 猫の命は9つ
}

void main() {
  test('mockito', () {
    // MockCatオブジェクトを作成します。
    var cat = MockCat();

    // 対話する前にモックメソッドをスタブ化します。
    when(cat.sound()).thenReturn("Purr");
    expect(cat.sound(), "Purr");

    // 再度呼び出すことができます。
    expect(cat.sound(), "Purr");

    // スタブを変更しましょう。
    when(cat.sound()).thenReturn("Meow");
    expect(cat.sound(), "Meow");

    // ゲッターをスタブ化することができます。
    when(cat.lives).thenReturn(9);
    expect(cat.lives, 9);

    // メソッドをスタブ化して例外を投げることができます。
    when(cat.lives).thenThrow(RangeError('Boo'));
    expect(() => cat.lives, throwsRangeError);

    // 呼び出し時にレスポンスを計算することができます。
    var responses = ["Purr", "Meow"];
    when(cat.sound()).thenAnswer((_) => responses.removeAt(0));
    expect(cat.sound(), "Purr");
    expect(cat.sound(), "Meow");

    // 特定の順序で発生した複数の呼び出しを持つメソッドをスタブ化することができます。
    when(cat.sound()).thenReturnInOrder(["Purr", "Meow"]);
    expect(cat.sound(), "Purr");
    expect(cat.sound(), "Meow");
    expect(() => cat.sound(), throwsA(isA<StateError>()));
  });
}
```