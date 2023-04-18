import 'dart:convert';

KafkaConfiguration kafkaConfigFromJson(String str) =>
    KafkaConfiguration.fromJson(json.decode(str));

String kafkaConfigToJson(KafkaConfiguration data) => json.encode(data.toJson());

class KafkaConfiguration {
  KafkaConfiguration(
      {required this.serverAddress,
      this.topic = 'FIRST-TOPIC',
      this.partition = 0,
      this.port = 8080});

  final List<String> serverAddress;
  final int port;
  final String topic;
  final int partition;

  factory KafkaConfiguration.fromJson(Map<String, dynamic> json) =>
      KafkaConfiguration(
        serverAddress: List<String>.from(json["serverAddress"].map((x) => x)),
        topic: json["topic"],
        partition: json["partition"],
        port: json["port"],
      );

  Map<String, dynamic> toJson() => {
        "serverAddress": List<dynamic>.from(serverAddress.map((x) => x)),
        "topic": topic,
        "partition": partition,
        "port": port,
      };
}
