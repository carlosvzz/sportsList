import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sports_list/models/basemodel.dart';

class FirestoreService<T extends BaseModel> {
  String _firestorePath;
  CollectionReference _objectCollection;

  FirestoreService(this._firestorePath) {
    this._objectCollection = Firestore.instance.collection(this._firestorePath);
  }

  Future<dynamic> createObject(T obj) async {
    try {
      final TransactionHandler createTransaction = (Transaction tx) async {
        final DocumentSnapshot ds = await tx.get(_objectCollection.document());
        obj.id = ds.documentID;
        final Map<String, dynamic> data = obj.toMap();

        await tx.set(ds.reference, data);
        return data;
      };

      if (createTransaction != null) {
        return Firestore.instance
            .runTransaction(createTransaction)
            .then((mapData) {
          return mapData['id'];
        }).catchError((error) {
          return null;
        });
      }
    } catch (e) {
      print('db error : $e');
    }
  }

  Stream<QuerySnapshot> getList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = _objectCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  Future<dynamic> updateObject(T obj) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_objectCollection.document(obj.id));

      await tx.update(ds.reference, obj.toMap());
      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error : $error');
      return false;
    });
  }

  Future<dynamic> deleteObject(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(_objectCollection.document(id));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      //print({'error: ${error}'});
      return false;
    });
  }
} // Fin clase
