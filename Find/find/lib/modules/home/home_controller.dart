import 'dart:io';

import 'package:find/models/missing_model.dart';
import 'package:find/services/missing_service.dart';
import 'package:find/shared/i18n/en-US.dart';
import 'package:firebase_mlvision/firebase_mlvision.dart';
import 'package:flutter/animation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

enum PickImageState { LOADING, SUCCESS, FAIL, IDLE }
enum MissingState { LOADING, SUCCESS, FAIL, IDLE }

abstract class _HomeController with Store {
  @observable
  File imageFile;

  @observable
  PickImageState pickImageState = PickImageState.IDLE;

  @observable
  MissingState missingState = MissingState.IDLE;

  @observable
  List<VisionEdgeImageLabel> scanResults;

  AnimationController animationController;

  final VisionEdgeImageLabeler _visionEdgeImageLabeler = FirebaseVision.instance
      .visionEdgeImageLabeler('person', ModelLocation.Local,
          VisionEdgeImageLabelerOptions(confidenceThreshold: 0.3));

  final MissingService _missingService = MissingService();

  @observable
  List<MissingModel> missingList = [];

  String message;

  @action
  Future<PickImageState> getAndScanImage() async {
    try {
      message = '';
      pickImageState = PickImageState.LOADING;

      File _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery)
          .whenComplete(() {
        if (imageFile != null && imageFile.path.isNotEmpty) {
          pickImageState = PickImageState.SUCCESS;
        } else {
          pickImageState = PickImageState.IDLE;
        }
      });

      if (_imageFile != null) {
        imageFile = _imageFile;
        pickImageState = PickImageState.SUCCESS;
        _searchMissing(imageFile);
        return PickImageState.SUCCESS;
      }

      return PickImageState.IDLE;
    } catch (e) {
      message = Strings.homeErrorMessagePickerImage;
      pickImageState = PickImageState.FAIL;
      print('home_controller - getAndScanImage(): $e');
      return PickImageState.FAIL;
    }
  }

  @action
  Future<void> _searchMissing(File imageFile) async {
    try {
      animationController.reset();
      missingState = MissingState.LOADING;
      scanResults = null;
      missingList = [];

      final FirebaseVisionImage _visionImage =
          FirebaseVisionImage.fromFile(imageFile);

      scanResults = await _visionEdgeImageLabeler.processImage(_visionImage);

      if (scanResults.isNotEmpty) {
        scanResults.forEach((data) async {
          final MissingModel _missing =
              await _missingService.getMissing(label: data.text);
          if (_missing != null) {
            final String _image = await _missingService.getMissingImagePath(
                image: _missing.images[0]);
            _missing.images[0] = _image;
            missingList.add(_missing);
          }
          missingState = MissingState.SUCCESS;
          animationController.forward();
        });
      } else {
        missingState = MissingState.SUCCESS;
        animationController.forward();
      }
    } catch (e) {
      missingState = MissingState.FAIL;
      print('home_controller - _scanImage(): $e');
    }
  }

  void dispose() {}
}
