// ignore_for_file: constant_identifier_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

void main() {
  ScieloApiConsumer scieloApiConsumer = ScieloApiConsumer();
  final Dio dio = Dio();

  scieloApiConsumer
      .getIdentifiers(dio)
      .then((IdentifiersResponse value) => print('ok'))
      .onError((error, stackTrace) => print('$error'));
}

class ScieloApiConsumer {
  final String articleMetaUrl = 'http://articlemeta.scielo.org';
  final String journalEndpoint = 'api/v1/journal';
  final String articleEndpoint = 'api/v1/article';
  final String collectionEndpoint = 'api/v1/collection';

  Future<IdentifiersResponse> getIdentifiers(Dio dio) async {
    final Response<dynamic> response =
        await dio.get('$articleMetaUrl/$journalEndpoint/identifiers');

    print(response.requestOptions.headers);
    if (response.statusCode == 200) {
      return IdentifiersResponse.fromJson(response.data);
    } else {
      throw 'GIDTF-01 ${response.statusCode}';
    }
  }
}

class IdentifiersResponse {
  IdentifiersResponse({
    required this.objects,
    required this.meta,
  });

  factory IdentifiersResponse.fromRawJson(String str) =>
      IdentifiersResponse.fromJson(json.decode(str));

  factory IdentifiersResponse.fromJson(dynamic json) => IdentifiersResponse(
        objects: List<IdentifierData>.from(
          json['objects'].map(
            (dynamic x) => IdentifierData.fromJson(x),
          ),
        ),
        meta: Meta.fromJson(json['meta']),
      );

  List<IdentifierData> objects;
  Meta meta;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'objects':
            List<dynamic>.from(objects.map((IdentifierData x) => x.toJson())),
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

class IdentifierData {
  IdentifierData({
    required this.processingDate,
    required this.collection,
    required this.code,
  });

  factory IdentifierData.fromJson(dynamic json) => IdentifierData(
        processingDate: DateTime.parse(json['processing_date']),
        collection: collectionValues.map[json['collection']]!,
        code: json['code'],
      );
  factory IdentifierData.fromRawJson(String str) =>
      IdentifierData.fromJson(json.decode(str));

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
