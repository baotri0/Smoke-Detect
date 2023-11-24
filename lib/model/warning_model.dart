import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

WarningModel productModelFromJson(String str) =>
    WarningModel.fromJson(json.decode(str));

String warningModelToJson(WarningModel data) => json.encode(data.toJson());

class WarningModel {
  WarningModel({
    required this.id,
    required this.title,
    required this.createdOn,
  });

  String id;
  String title;
  Timestamp createdOn;

  factory WarningModel.fromJson(Map<String, dynamic> json) => WarningModel(
        id: json["id"],
        title: json["title"],
        createdOn: json["createdOn"],
      );


  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "createdOn": createdOn,
      };

  WarningModel copyWith({
    String? title,
    Timestamp? createdOn,
  }) =>
      WarningModel(
        id: id ?? this.id,
        title: title ?? this.title,
        createdOn: createdOn ?? this.createdOn,
      );
}
