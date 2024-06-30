# 単体テストの定義とは？
`単体テストの考えた方/使い方`より引用

単体テストの定義には様々なものがあります。本質的ではないものを除くと、
単体テスト として定義されるテストには次に挙げる 3 つの重要な性質がすべて備えられていること
になります。つまり、自動化されていて、次の 3 つの性質をすべて備えるものが単体テストとな るのです :

1. 「単体(unit)」と呼ばれる少量のコードを検証する 
2. 実行時間が短い
3. 隔離された状態で実行される

### 定義:テスト・ダブル とは、
リリース対象のオブジェクトと同じような見た目と振る 舞いを持っていながらも、
複雑さを減少させて簡潔になることでテストを行いや すくするオブジェクトのことになります。
この「テスト・ダブル」という用語は Gerard Meszaros氏の『xUnit Test Patterns: 
Refactoring Test Code』(Addison- Wesley、2007 年)で出てきたもので、
名前自体は映画のスタントマン(英語だ と「stunt double」)から来ています。

### 単体テストは何か？
今回扱うのは EC サイトのアプリケーションで、「顧客が商品を買う」という 1 つのユースケ ースしかありません。
そして、顧客が商品を購入する際、その店に十分な商品があれば(在 庫があれば)、取引を成立させ、それから、
その店の商品を購入された分だけ減らすように なっているとします。その逆に、もし、その店に十分な商品がなければ(在庫が足らなけれ
ば)、取引は失敗し、その店の在庫に対して何もしないようになっているとします。 
次のリスト 2.1 が示すものは、店(store)に商品(product)が十分にある場合、つまり、
十分な在庫(inventory)がある場合にのみ購入(purchase)が成功することを検証するテ スト・コードです。
このテスト・コードには、2 つのテスト・ケースが定義されており、古 典学派のスタイルで実装されています。そして、各テスト・ケースは準備(Arrange)、実行
(Act)、確認(Assert)の 3 つのフェーズで構成されています。
このように、テスト・ケース を 3 つのフェーズで構成する定義の仕方を各フェーズの頭文字を取って「AAA パターン」と
呼びます(この 3 つのフェーズについては第 3 章で詳しく見ていきます)。

**Dartに置き換えてます**
```dart
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
```
　
### 定義:モック とは、
特別な種類のテスト・ダブルのことで、テスト対象システムと
協力者オブジェクトとのやり取りを検証できるようになっています。

- テスト・ダブル とは、テストで使われるすべての種類の偽りの依存のことであり、プロ ダクトで使われることはない。
- モック はこのような偽りの依存の 1 種でしかない。

このコードでは、StoreクラスのメソッドhasEnoughInventoryとremoveInventoryをモック化しています。
hasEnoughInventoryメソッドは在庫が十分にあるかどうかを確認し、removeInventoryメソッドは在庫を減らします。
テストでは、test関数を使用して2つのテストケースを定義しています。
一つ目のテストケースでは、在庫が十分にある場合に購入が成功することを確認しています。
二つ目のテストケースでは、在庫が不足している場合に購入が失敗することを確認しています。
verify関数はモックのメソッドが呼び出された回数を検証します。
verifyNever関数はモックのメソッドが一度も呼び出されていないことを検証します。

```dart
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
```

繰り返しになりますが、ロンドン学派の単体テストでは、
テスト対象システムと協力者オブジェクトの隔離をテスト・ダブル(具体的にはモック)を用いることで実現しています。
興 味深いことに、このように、依存をテスト・ダブルに置き換えることは、
何がテスト対象の コード(つまりは、単体)となるのか、ということに影響を与えることになります。それで は、
単体テストが持っていなくてはならないすべての性質についてもう一度振り返ってみま しょう :

- 「単体(unit)」と呼ばれる少量のコードを検証すること ⿟実行時間が短いこと 
- 隔離された状態で実行されること

単体テストにおけるロンドン学派と古典学派の見解の違い。隔離対象、単体が意味すること、 9
テスト・ダブルを使うべき依存の 3 つの視点から違いを明確にすることができる

|        | 隔離対象    | 単体の意味                             | テスト・タブルの置き換え対象 |
|--------|---------|-----------------------------------|----------------|
| ロンドン学派 | 単体      | １つのクラス                            | 不変依存を除くすべての依存  |
| 古典学派   | テスト・ケース | １つのクラス、もしくは、同じ目的を達成するためのクラスの１グループ | 共有依存           |

### 単体テストの構造解析
AAAパターンについて
- Arrange: テスト対象のオブジェクトを作成し、テスト対象のメソッドを呼び出すための準備を行う
- Act: 実行
- Assert: 結果を検証、確認

単体テストにおいて回避すべき: if文の使用
以下は、単体テストにおける`if`文の使用を避けるためのDartのテストコードの例です。

```dart
import 'package:flutter_test/flutter_test.dart';

class Calculator {
  double sum(double first, double second) {
    return first + second;
  }
}

void main() {
  var calculator = Calculator();

  test('sum of two positive numbers', () {
    double first = 10;
    double second = 20;
    double result = calculator.sum(first, second);
    expect(result, 30);
  });

  test('sum of two negative numbers', () {
    double first = -10;
    double second = -20;
    double result = calculator.sum(first, second);
    expect(result, -30);
  });

  test('sum of positive and negative number', () {
    double first = 10;
    double second = -20;
    double result = calculator.sum(first, second);
    expect(result, -10);
  });
}
```

このコードでは、if文を使用せずに、異なる条件をテストするために複数のテストケースを定義しています。
各テストケースは独立しており、それぞれが特定の条件をテストします。
これにより、テストケースが単純で理解しやすくなり、保守も容易になります。

このように、単体テストでは、`if`文を使用せずに、異なる条件をテストするために複数のテストケースを定義することが推奨されます。

### モックとスタブの違い
モックとは、テスト対象システムとその協力者オブジェクトとのやりとりを検証するのに使われるテスト・ダブルのこと。
そして、テスト・ダブルにはもっとは別の種類のスタブと呼ばれるものも存在します。

### テスト・ダブルの種類
テスト・タブル とは、プロダクション・コードには含まれず、テストでしか使われない偽りの依存として表現される
すべてのものを包括的に意味するものです。この用語は映画のス タントマン(英語だと「stunt double」)を
語源としています。テスト・ダブルが使われる主 な理由はテストを円滑に実施できるようにするためです。たとえば、
テストの際に使われる 依存を用意することや維持することが難しい場合、実際の依存の代わりにテスト・ダブルを
テスト対象システムに使わせるようにすれば、テストを容易に行えるようになります。
このテスト・ダブルには、ダミー、スタブ、スパイ、モック、フェイク の 5 種類があります 
[1]。こんなに種類があるとうんざりした気分になるかもしれませんが、実際には、次の図 5.1 で示すように、
モックとスタブの 2 つに大きく分けることができます。

- モックはテスト対象システムからその依存に向かって行われる 外部に向かう コミュニケ ーション(出力)を模倣し、
そして、検証するのに使われる。このとき、モックが模倣す るコミュニケーションはテスト対象システムが依存の状態を変えるために行うその依存
への呼び出しのことになる。
- スタブは依存からテスト対象システムに向かって行われる 内部に向かう コミュニケー ション(入力)を模倣するのに使われる。
このとき、スタブが模倣するコミュニケーショ ンはテスト対象システムが依存からデータを取得するために行う
その依存への呼び出し のことになる。

これらの違いを除くと、テスト・ダブルの種類の違いはすべて細かな実装の違いに関する ことであり、
そこまで重要性はありません。たとえば、スパイ はモックと同じ役割を担うの ですが、
モックはモック・フレームワークの助けを借りて生成されるのに対し、スパイは開 発者自身の手で実装される、
という違いがあります。そのため、スパイのことを「手書きの モック(handwritten mock)」と呼ぶことがあります。
一方、スタブとダミーとフェイクの違いは、どのくらい知的に振る舞えるのか、というこ とになります。まず、ダミー とは、
null値や一時しのぎで使われる文字列などのシンプルな ハード・コーディングされた値のことです。このダミーはテスト対象
システムのメソッド・ シグネチャを満たすために使われ、最終的な結果を生成することには参加しません。次に、 スタブ なのですが、
スタブはもっと洗練されており、設定によって返す結果を異なるシナリオごとに変えられる完全に自立した依存として振る舞うものです。
そして、最後に、フェイ ク なのですが、フェイクを使う目的はスタブの場合とほぼ同じである一方、通常、フェイク はまだ存在しない依存を
置き換えるために作成される、というフェイクを作成する際の動機 がスタブの場合と異なります。
それでは、モックとスタブの違いについて見ていきましょう。まず、両者には、外部に向 かうコミュニケーションなのか、それとも、
内部に向かうコミュニケーションなのか、とい う違いがあります。このことに加え、モックはテスト対象システムとその依存とのコミュニ ケーションを
模倣 するだけではなく、検証 も行うのに対し、スタブはテスト対象システム とその依存とのコミュニケーションの 模倣 だけしか行わない、という違いもあります。
これ は重要な違いなのですが、なぜ重要なのかについてはあとで見ていきます。