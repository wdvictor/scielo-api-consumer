// To parse this JSON data, do
//
//     final collectionResponse = collectionResponseFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

class CollectionResponse {
  CollectionResponse({
    required this.objects,
    required this.meta,
  });

  List<Object> objects;
  Meta meta;

  factory CollectionResponse.fromRawJson(String str) =>
      CollectionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CollectionResponse.fromJson(Map<String, dynamic> json) =>
      CollectionResponse(
        objects:
            List<Object>.from(json["objects"].map((x) => Object.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "objects": List<dynamic>.from(objects.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Meta {
  Meta({
    required this.limit,
    required this.offset,
    required this.total,
    required this.filter,
  });

  int limit;
  int offset;
  int total;
  Filter filter;

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        limit: json["limit"],
        offset: json["offset"],
        total: json["total"],
        filter: Filter.fromJson(json["filter"]),
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "offset": offset,
        "total": total,
        "filter": filter.toJson(),
      };
}

class Filter {
  Filter();

  factory Filter.fromRawJson(String str) => Filter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Filter.fromJson(Map<String, dynamic> json) => Filter();

  Map<String, dynamic> toJson() => {};
}

class Object {
  Object({
    required this.processingDate,
    required this.collection,
    required this.code,
  });

  DateTime processingDate;
  Collection collection;
  String code;

  factory Object.fromRawJson(String str) => Object.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Object.fromJson(Map<String, dynamic> json) => Object(
        processingDate: DateTime.parse(json["processing_date"]),
        collection: collectionValues.map[json["collection"]]!,
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "processing_date":
            "${processingDate.year.toString().padLeft(4, '0')}-${processingDate.month.toString().padLeft(2, '0')}-${processingDate.day.toString().padLeft(2, '0')}",
        "collection": collectionValues.reverse[collection],
        "code": code,
      };
}

enum Collection {
  PSI,
  CUB,
  SSS,
  SCL,
  VEN,
  CIC,
  PRT,
  COL,
  ARG,
  MEX,
  SPA,
  CRI,
  ESP,
  SZA,
  BOL,
  RVE,
  PRY,
  CHL,
  PER,
  URY
}

final collectionValues = EnumValues({
  "arg": Collection.ARG,
  "bol": Collection.BOL,
  "chl": Collection.CHL,
  "cic": Collection.CIC,
  "col": Collection.COL,
  "cri": Collection.CRI,
  "cub": Collection.CUB,
  "esp": Collection.ESP,
  "mex": Collection.MEX,
  "per": Collection.PER,
  "prt": Collection.PRT,
  "pry": Collection.PRY,
  "psi": Collection.PSI,
  "rve": Collection.RVE,
  "scl": Collection.SCL,
  "spa": Collection.SPA,
  "sss": Collection.SSS,
  "sza": Collection.SZA,
  "ury": Collection.URY,
  "ven": Collection.VEN
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map(
      (k, v) => MapEntry(v, k),
    );
    return reverseMap!;
  }
}
