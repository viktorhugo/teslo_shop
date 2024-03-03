import 'package:image_picker/image_picker.dart';

import 'camera_gallery_service.dart';

class CameraGalleryServiceImpl extends CameraGalleryService {

  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async{
    // Pick an image.
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return null;
    
    return image.path;
  }

  @override
  Future<String?> takePhoto() async {
    // Capture a photo.
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear
    );

    if (photo == null) return null;
    
    return photo.path;
  }

}