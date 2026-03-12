import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> takePhoto() async {
    try {
      // Sur Chrome, cela ouvrira une fenêtre pour choisir un fichier ou utiliser la webcam
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      return photo;
    } catch (e) {
      print("Erreur Camera: $e");
      return null;
    }
  }
}
