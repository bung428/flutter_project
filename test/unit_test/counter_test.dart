import 'package:test/test.dart';

void main() {
  group('test Counter Provider', (){
    test('test for Counter increment', () {
      final counter = Counter();

      counter.increment();
      expect(counter.value, 1);
    });
    test('test for Counter decrement', (){
      final counter = Counter();

      counter.decrement();
      expect(counter.value, -1);
    });
    test('Counter value should be incremented', () {
      final counter = Counter();
      String hello = "HELLO WORLD";

      counter.increment();

      expect(counter.value, 1);
      expect(hello.toLowerCase(), "hello world");
    });
  });
}

class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}
