import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseApiClient {
  Future<dynamic> get(String collection, String id);
  Future<dynamic> delete(String collection, String id);
  Future<dynamic> getAll(String collection);
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
  Future getAll(String collection) async {
    List<Map<String, dynamic>> listData = [];

    final listDataDB = await firestore.collection(collection).get();

    listData = listDataDB.docs.map((element) => element.data()).toList();

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
