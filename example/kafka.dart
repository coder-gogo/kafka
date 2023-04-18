import 'package:kafka/kafka.dart';

void main() {
  KafkaService().pushStream(
    body: 'KAFKA DATA (BODY)',
    kafkaConfig: KafkaConfiguration(
      serverAddress: ['192.168.0.150'],
      partition: 1,
      port: 9192,
      topic: 'Example-Topic',
    ),
    listen: (response, object) {
      if (response == Response.done) {
        print("SUCCESS");
      } else {
        print("Failure");
      }
    },
  );
}
