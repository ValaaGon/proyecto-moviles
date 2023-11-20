import 'package:image_picker/image_picker.dart';

Future<XFile?> getImage() async {
  final ImagePicker seleccionador = ImagePicker();
  final XFile? imagen =
      await seleccionador.pickImage(source: ImageSource.gallery);

  return imagen;
}
