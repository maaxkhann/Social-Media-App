import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/shared/console.dart';

class Pickers {
  static final ins = Pickers._internal();
  Pickers._internal();
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFile({
    ImageSource source = ImageSource.camera,
    int quality = 50,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: quality,
        preferredCameraDevice: preferredCameraDevice,
      );
      return File(file?.path ?? '');
    } catch (e) {
      console(e.toString());
      return null;
    }
  }

  Future<String?> pickImage({
    ImageSource source = ImageSource.gallery,
    int quality = 50,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: quality,
        preferredCameraDevice: preferredCameraDevice,
      );
      return file?.path;
    } catch (e) {
      console(e.toString());
      return null;
    }
  }

  Future<List<String>> pickImages({int quality = 50}) async {
    try {
      List<XFile> files = await _picker.pickMultiImage(imageQuality: quality);
      List<String> paths = [];
      for (XFile file in files) {
        paths.add(file.path);
      }
      return paths;
    } catch (e) {
      console(e.toString());
      return [];
    }
  }

  // static const List<String> _allowedExtensions = [
  //   'bmp',
  //   'doc',
  //   'docx',
  //   'gif',
  //   'jpeg',
  //   'jpg',
  //   'pdf',
  //   'png',
  //   'tif',
  //   'tiff',
  //   'xls',
  //   'xlsx'
  // ];
  // Future<FilePickerResult?> pickFile(
  //     {FileType type = FileType.custom,
  //     List<String> allowedExtensions = _allowedExtensions,
  //     bool allowCompression = true,
  //     bool allowMultiple = false}) async {
  //   try {
  //     return await FilePicker.platform.pickFiles(
  //         type: type,
  //         allowedExtensions: allowedExtensions,
  //         allowCompression: allowCompression,
  //         allowMultiple: allowMultiple);
  //   } catch (e) {
  //     console(e.toString());
  //     return null;
  //   }
  // }
}
