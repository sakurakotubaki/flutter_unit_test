import 'package:flutter_test/flutter_test.dart';

// 参考にした.NETのコードだと、assertを使っているが、Flutterのテストコードではexpectを使う
class Calculator {
  double sum(double first, double second) {
    return first + second;
  }
}

void main() {
  var calculator = Calculator();

  test('sum of two numbers', () {
    /// [準備(Arrange)]
    double first = 10;
    double second = 20;

    /// [実行(Act)]
    double result = calculator.sum(first, second);

    /// [検証(Assert)]
    expect(result, 30); // 左の値が期待値、右の値が実際の値で、等しい場合は何も起こらない
  });
}
