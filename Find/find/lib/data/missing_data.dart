import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/services/firebase_store_service.dart';
import 'package:find/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class MissingData {
  Future<QuerySnapshot> loadMissing({@required String label}) {
    return FirestoreService.firestore
        .collection("missing")
        .where("label", isEqualTo: label)
        .getDocuments();
  }

  StorageReference loadMissingImage({@required image}) {
    StorageReference _storageImage =
        FirebaseStoreService.firebaseStorage.ref().child(image);
    return _storageImage;
  }
}
