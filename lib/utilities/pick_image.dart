import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  try {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    if (pickedImage == null) {
      return null;
    }
    return pickedImage;
  } catch (e) {
    return null;
  }
}

Future<String?> uploadImageFromBytes(Uint8List data, String fileName) async {
  try {

    final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');

    await storageRef.putData(data);

    final downloadUrl = await storageRef.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}


