import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../bin/scielo_api_consumer.dart';
import 'scielo_api_consumer_test.mocks.dart';

const String identifierResponseString = '''
{
  "objects": [
     {
      "processing_date": "2019-06-27",
      "collection": "chl",
      "code": "0718-0950"
    }
  ],
  "meta": {
    "offset": 0,
    "total": 1935,
    "filter": {},
    "limit": 1000
  }
}
''';

@GenerateMocks(<Type>[Dio])
void main() {
  const String articleMetaUrl = 'http://articlemeta.scielo.org';
  const String journalEndpoint = 'api/v1/journal';
  const String articleEndpoint = 'api/v1/article';

  group('Testing models factory ', () {
    test(
        'IdentifiersResponse.fromJson should return a '
        'IdentifiersResponse object', () {
      expect(IdentifiersResponse.fromJson(jsonDecode(identifierResponseString)),
          isA<IdentifiersResponse>());
    });
  });

  group('Testing journals', () {
    test('description', () async {
      final dio = MockDio();
      final ScieloApiConsumer scieloApiConsumer = ScieloApiConsumer();

      when(dio.get('$articleMetaUrl/$journalEndpoint/identifiers')).thenAnswer(
        (_) async => Response(
          data: jsonDecode(identifierResponseString),
          statusCode: 200,
          requestOptions: RequestOptions(
              path: '$articleMetaUrl/$journalEndpoint/identifiers'),
        ),
      );
      expect(await scieloApiConsumer.getIdentifiers(dio),
          isA<IdentifiersResponse>());
    });
  });
}
