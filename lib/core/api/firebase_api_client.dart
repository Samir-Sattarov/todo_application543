import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

enum FirebaseApiFilterType {
  isEqualTo,
  isNotEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  whereIn,
  whereNotIn,
  isNull,
}

class FirebaseFilterEntity {
  final String field;
  final FirebaseApiFilterType operator;
  final dynamic value;

  FirebaseFilterEntity({
    required this.field,
    required this.operator,
    required this.value,
  });
}

abstract class FirebaseApiClient {
  Future<dynamic> get(String collection, String id);
  Future<dynamic> delete(String collection, String id);
  Future<dynamic> getAll(String collection,
      {List<FirebaseFilterEntity>? filters});
  Future<dynamic> post(String collection, Map<String, dynamic> data);
  Future<dynamic> update(String collection, Map<String, dynamic> data);
}

class FirebaseApiClientImpl extends FirebaseApiClient {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future get(String collection, String id) async {
    final data = await firestore.collection(collection).doc(id).get();

    final response = data.data();

    log("Response $collection $id $response");

    return response;
  }

  @override
  Future getAll(String collection,
      {List<FirebaseFilterEntity>? filters}) async {
    List<dynamic> listData = [];

    Query query = firestore.collection(collection);

    if (filters != null) {
      for (var filter in filters) {
        switch (filter.operator) {
          case FirebaseApiFilterType.isEqualTo:
            query = query.where(filter.field, isEqualTo: filter.value);
            break;
          case FirebaseApiFilterType.isNotEqualTo:
            query = query.where(filter.field, isNotEqualTo: filter.value);
            break;
          case FirebaseApiFilterType.isGreaterThan:
            query = query.where(filter.field, isGreaterThan: filter.value);
            break;
          case FirebaseApiFilterType.isGreaterThanOrEqualTo:
            query =
                query.where(filter.field, isGreaterThanOrEqualTo: filter.value);
            break;
          case FirebaseApiFilterType.isLessThan:
            query = query.where(filter.field, isLessThan: filter.value);
            break;
          case FirebaseApiFilterType.isLessThanOrEqualTo:
            query =
                query.where(filter.field, isLessThanOrEqualTo: filter.value);
            break;
          case FirebaseApiFilterType.arrayContains:
            query = query.where(filter.field, arrayContains: filter.value);
            break;
          case FirebaseApiFilterType.arrayContainsAny:
            query = query.where(filter.field, arrayContainsAny: filter.value);
            break;
          case FirebaseApiFilterType.whereIn:
            query = query.where(filter.field, whereIn: filter.value);
            break;
          case FirebaseApiFilterType.whereNotIn:
            query = query.where(filter.field, whereNotIn: filter.value);
            break;
          case FirebaseApiFilterType.isNull:
            query = query.where(filter.field, isNull: filter.value);
            break;
          default:
            throw ArgumentError('Unsupported operator: ${filter.operator}');
        }
      }
    }
    final response = await query.get();
    listData = response.docs.map((element) => element.data()).toList();

    log("Response $listData");

    return listData;
  }

  @override
  Future post(String collection, Map<String, dynamic> data) async {
    await firestore.collection(collection).doc(data['id'].toString()).set(data);
  }

  @override
  Future update(String collection, Map<String, dynamic> data) async {
    await firestore
        .collection(collection)
        .doc(data['id'].toString())
        .update(data);
  }

  @override
  Future delete(String collection, String id) async {
    await firestore.collection(collection).doc(id).delete();
  }
}
