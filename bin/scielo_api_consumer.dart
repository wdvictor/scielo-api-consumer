// ignore_for_file: constant_identifier_names, avoid_dynamic_calls

import 'dart:convert';

import 'package:dio/dio.dart';

void main(List<String> arguments) {
  ScieloApiConsumer scieloApiConsumer = ScieloApiConsumer();
  scieloApiConsumer
      .getIdentifiers()
      .then((CollectionResponse value) => value.objects.forEach((element) {
            print(element.collection);
          }))
      .onError((error, stackTrace) => print('$error'));
}

class ScieloApiConsumer {
  final String articleMetaUrl = 'http://articlemeta.scielo.org';
  final String journalEndpoint = 'api/v1/journal';
  final String articleEndpoint = 'api/v1/article';
  final String collectionEndpoint = 'api/v1/collection';

  Future<CollectionResponse> getIdentifiers() async {
    final Response<dynamic> response =
        await Dio().get('$articleMetaUrl/$journalEndpoint/identifiers');

    if (response.statusCode == 200) {
      return CollectionResponse.fromJson(response.data);
    } else {
      throw 'GIDTF-01';
    }
  }
}

class CollectionResponse {
  CollectionResponse({
    required this.objects,
    required this.meta,
  });

  factory CollectionResponse.fromRawJson(String str) =>
      CollectionResponse.fromJson(json.decode(str));

  factory CollectionResponse.fromJson(dynamic json) => CollectionResponse(
        objects: List<CollectionData>.from(
          json['objects'].map(
            (dynamic x) => CollectionData.fromJson(x),
          ),
        ),
        meta: Meta.fromJson(json['meta']),
      );

  List<CollectionData> objects;
  Meta meta;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'objects':
            List<dynamic>.from(objects.map((CollectionData x) => x.toJson())),
        'meta': meta.toJson(),
      };
}

class Meta {
  Meta({
    required this.limit,
    required this.offset,
    required this.total,
    required this.filter,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        limit: json['limit'],
        offset: json['offset'],
        total: json['total'],
        filter: Filter.fromJson(json['filter']),
      );

  int limit;
  int offset;
  int total;
  Filter filter;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'limit': limit,
        'offset': offset,
        'total': total,
        'filter': filter.toJson(),
      };
}

class Filter {
  Filter();

  factory Filter.fromRawJson(String str) => Filter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Filter.fromJson(Map<String, dynamic> json) => Filter();

  Map<String, dynamic> toJson() => {};
}

class CollectionData {
  CollectionData({
    required this.processingDate,
    required this.collection,
    required this.code,
  });

  factory CollectionData.fromJson(dynamic json) => CollectionData(
        processingDate: DateTime.parse(json['processing_date']),
        collection: collectionValues.map[json['collection']]!,
        code: json['code'],
      );
  factory CollectionData.fromRawJson(String str) =>
      CollectionData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  DateTime processingDate;
  Collection collection;
  String code;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'processing_date':
            "${processingDate.year.toString().padLeft(4, '0')}-${processingDate.month.toString().padLeft(2, '0')}-${processingDate.day.toString().padLeft(2, '0')}",
        'collection': collectionValues.reverse[collection],
        'code': code,
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

final EnumValues collectionValues = EnumValues({
  'arg': Collection.ARG,
  'bol': Collection.BOL,
  'chl': Collection.CHL,
  'cic': Collection.CIC,
  'col': Collection.COL,
  'cri': Collection.CRI,
  'cub': Collection.CUB,
  'esp': Collection.ESP,
  'mex': Collection.MEX,
  'per': Collection.PER,
  'prt': Collection.PRT,
  'pry': Collection.PRY,
  'psi': Collection.PSI,
  'rve': Collection.RVE,
  'scl': Collection.SCL,
  'spa': Collection.SPA,
  'sss': Collection.SSS,
  'sza': Collection.SZA,
  'ury': Collection.URY,
  'ven': Collection.VEN
});

class EnumValues<T> {
  EnumValues(this.map);
  Map<String, T> map;
  Map<T, String>? reverseMap;

  Map<T, String> get reverse {
    reverseMap ??= map.map(
      (String k, T v) => MapEntry<T, String>(v, k),
    );
    return reverseMap!;
  }
}
