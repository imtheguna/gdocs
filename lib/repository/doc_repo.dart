import 'dart:convert';

import 'package:docs/models/constants.dart';
import 'package:docs/models/doc.model.dart';
import 'package:docs/models/error.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final docRepositoryProvider = Provider(
  (_) => DocumentRepo(
    client: Client(),
  ),
);

class DocumentRepo {
  final Client _client;

  DocumentRepo({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexpected error occurred', data: null);
    try {
      var res = await _client.post(
        Uri.parse('$host/doc/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
        body: jsonEncode(
          {
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
        ),
      );

      /// Checking API Response
      switch (res.statusCode) {
        case 200:
          errorModel =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          errorModel = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }

    return errorModel;
  }

  Future<ErrorModel> getMyDocs(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexpected error occurred', data: null);
    try {
      var res = await _client.get(
        Uri.parse('$host/docs/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      /// Checking API Response
      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
              DocumentModel.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
          errorModel = ErrorModel(
            error: null,
            data: documents,
          );
          break;
        default:
          errorModel = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }

    return errorModel;
  }

  void updateDocTitile({
    required String token,
    required String docId,
    required String title,
  }) async {
    try {
      var res = await _client.post(
        Uri.parse('$host/doc/titleUp'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
        body: jsonEncode(
          {
            'id': docId,
            'title': title,
          },
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void updateSharedList({
    required String token,
    required String docId,
    required List emails,
  }) async {
    try {
      var res = await _client.post(
        Uri.parse('$host/doc/updatesharedemail'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
        body: jsonEncode(
          {
            'id': docId,
            'email': emails,
          },
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<ErrorModel> getMyDocByID(
      {required String token, required String id}) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexpected error occurred', data: null);
    try {
      var res = await _client.get(
        Uri.parse('$host/doc/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      /// Checking API Response
      switch (res.statusCode) {
        case 200:
          errorModel = ErrorModel(
            error: null,
            data: DocumentModel.fromJson(res.body),
          );
          break;
        default:
          throw "This Document does not exist";
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }

    return errorModel;
  }

  Future<ErrorModel> deleteDocById(
      {required String token, required String id}) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexpected error occurred', data: null);
    try {
      var res = await _client.post(
        Uri.parse('$host/doc/delete/$id'),
        body: jsonEncode(
          {
            'id': id,
          },
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      /// Checking API Response
      switch (res.statusCode) {
        case 200:
          print('done');
          break;
        default:
          throw "This Document does not exist";
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }

    return errorModel;
  }
}
