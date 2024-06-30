import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

/// flutter pub run build_runner watch --delete-conflicting-outputs
// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<Email>()])
import 'email_test.mocks.mocks.dart';

// Real class
class Email {
  // 仮のメールアドレスを送信するモックのテスト
  String sendEmail(String address) => "送信先: $address";
}

void main() {
  test('sendEmail returns correct address', () {
    var email = MockEmail();

    // sendEmailメソッドが呼び出されたときの戻り値を設定します。
    when(email.sendEmail(any)).thenReturn("送信先: test@example.com");

    // sendEmailメソッドを呼び出し、期待する戻り値が得られることを確認します。
    expect(email.sendEmail("test@example.com"), "送信先: test@example.com");
  });
}
