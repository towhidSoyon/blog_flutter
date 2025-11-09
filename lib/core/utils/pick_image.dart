import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async{
  try{
    final resFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(resFile!= null){
      return File(resFile.path);
    }
    return null;
  }catch (e){
    return null;
  }
}