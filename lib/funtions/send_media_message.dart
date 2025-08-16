// media_picker.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> sendMediaMessage(BuildContext context) async {
  final picker = ImagePicker();
  XFile? pickedFile;

  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take a Photo"),
            onTap: () async {
              Navigator.pop(context);
              pickedFile = await picker.pickImage(source: ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from Gallery"),
            onTap: () async {
              Navigator.pop(context);
              pickedFile = await picker.pickImage(source: ImageSource.gallery);
            },
          ),
        ],
      );
    },
  );

  return pickedFile;
}
