import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_unit_test/api/calc.dart';

void main() {
  test('adds one to input values', () {
    // テスト用のコードをインスタンス化
    final calc = Calc();
    // メソッドに引数を渡す
    final result = calc.add(1, 2);
    /**
     * 期待する結果と実際の結果を比較する
     * expect(実際の結果, 期待する結果);
     * expect(actual, matcher);
     */
    expect(result, 3);
  });
}
