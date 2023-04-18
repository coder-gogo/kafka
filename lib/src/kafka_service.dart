import 'package:kafka/kafka.dart';
import 'package:kafka/src/const_string.dart';

enum Response { withError, done }

class KafkaService {
  KafkaService._internal();

  static final _singleTon = KafkaService._internal();

  factory KafkaService() => _singleTon;

  Future<void> pushStream(
      {required String body,
      required KafkaConfiguration kafkaConfig,
      required void Function(Response response, Object object) listen}) async {
    try {
      ProducerConfig config;
      ProduceResult result;
      Producer<String, String> producer;

      config = ProducerConfig(bootstrapServers: kafkaConfig.serverAddress);

      producer = Producer<String, String>(
        StringSerializer(),
        StringSerializer(),
        config,
      );

      ProducerRecord<String, String> record = ProducerRecord(
        kafkaConfig.topic,
        kafkaConfig.partition,
        Strings.kafka,
        body,
      );

      producer.add(record);

      result = await record.result.timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception(Strings.timeOut),
      );
      await producer.close();
      listen(Response.done, result);
    } catch (error) {
      listen(Response.withError, error);
    }
  }
}
