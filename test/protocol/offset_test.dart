library kafka.test.api.offset;

import 'package:test/test.dart';
import 'package:kafka/kafka.dart';
import 'package:kafka/protocol.dart';
import '../setup.dart';

void main() {
  group('OffsetApi:', () {
    String _topicName = 'dartKafkaTest';
    Broker? _broker;
    KafkaSession? _session;
    OffsetRequest? _request;
    int? _offset;

    setUp(() async {
      var ip = await getDefaultHost();
      _session = KafkaSession([ContactPoint(ip, 9092)]);
      var metadata = await _session?.getMetadata([_topicName].toSet());
      var leaderId =
          metadata?.getTopicMetadata(_topicName).getPartition(0).leader;
      _broker = metadata?.getBroker(leaderId!);

      var now = DateTime.now();
      var _message = 'test:' + now.toIso8601String();
      ProduceRequest produce = ProduceRequest(1, 1000, [
        ProduceEnvelope(_topicName, 0, [Message(_message.codeUnits)])
      ]);

      ProduceResponse response = await _session?.send(_broker!, produce);
      _offset = response.results.first.offset;
      _request = OffsetRequest(leaderId!);
    });

    tearDown(() async {
      await _session?.close();
    });

    test('it fetches offset info', () async {
      _request?.addTopicPartition(_topicName, 0, -1, 1);
      OffsetResponse response = await _session?.send(_broker!, _request!);

      expect(response.offsets, hasLength(1));
      var offset = response.offsets.first;
      expect(offset.errorCode, equals(0));
      expect(offset.offsets, hasLength(1));
      expect(offset.offsets.first, equals(_offset! + 1));
    });
  });
}
