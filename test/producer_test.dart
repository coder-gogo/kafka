library kafka.test.producer;

import 'package:test/test.dart';
import 'package:kafka/kafka.dart';
import 'setup.dart';

main() {
  group('Producer:', () {
    KafkaSession? _session;
    String _topicName = 'dartKafkaTest';

    setUp(() async {
      var host = await getDefaultHost();
      _session = KafkaSession([ContactPoint(host, 9092)]);
    });

    tearDown(() async {
      await _session?.close();
    });

    test('it can produce messages to multiple brokers', () async {
      var producer = Producer(_session!, 1, 100);
      var result = await producer.produce([
        ProduceEnvelope(_topicName, 0, [Message('test1'.codeUnits)]),
        ProduceEnvelope(_topicName, 1, [Message('test2'.codeUnits)]),
        ProduceEnvelope(_topicName, 2, [Message('test3'.codeUnits)]),
      ]);
      expect(result.hasErrors, isFalse);
      expect(result.offsets[_topicName]?[0], greaterThanOrEqualTo(0));
      expect(result.offsets[_topicName]?[1], greaterThanOrEqualTo(0));
      expect(result.offsets[_topicName]?[2], greaterThanOrEqualTo(0));
    });
  });
}
