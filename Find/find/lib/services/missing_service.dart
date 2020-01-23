import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/data/missing_data.dart';
import 'package:find/models/missing_model.dart';
import 'package:flutter/foundation.dart';

class MissingService {
  final MissingData _missingData = MissingData();

  Future<MissingModel> getMissing({@required label}) async {
    final QuerySnapshot _missing = await _missingData.loadMissing(label: label);
    List<DocumentSnapshot> _missingDocuments = _missing.documents;
    return MissingModel.fromFirestore(_missingDocuments.first);
  }

  Future<String> getMissingImagePath({@required image}) async {
    final String _image =
        await _missingData.loadMissingImage(image: image).getDownloadURL();
    return _image;
  }
}
