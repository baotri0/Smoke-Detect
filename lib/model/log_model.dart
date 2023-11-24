import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  int mq2;
  String Area;
  Timestamp? createdOn;

  Log({
    required this.mq2,
    required this.Area,
    this.createdOn
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'mq2': int mq2,
      'Area': String Area,
      } =>
          Log(
            mq2: mq2,
            Area: Area,
          ),
      _ => throw const FormatException('Failed to load Log.'),
    };
  }

  factory Log.fromJson1(Map<String, dynamic> json) => Log(
    mq2: json["value"],
    Area: json["Area"],
    createdOn: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "value": mq2,
    "title": Area,
  };

}