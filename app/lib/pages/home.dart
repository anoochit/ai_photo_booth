// ignore_for_file: use_build_context_synchronously

import 'package:app/pages/confirm.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // browse from gallery
            FilledButton.tonal(
              onPressed: () => _browseGallery(context),
              child: Text('Gallery'),
            ),

            // camera
            FilledButton(
              onPressed: () => _takePhoto(context),
              child: Text('Camera'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto(BuildContext context) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (xfile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmImagePage(image: xfile.path),
        ),
      );
    }
  }

  Future<void> _browseGallery(BuildContext context) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (xfile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmImagePage(image: xfile.path),
        ),
      );
    }
  }
}
