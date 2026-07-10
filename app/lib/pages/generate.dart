import 'dart:developer';
import 'dart:io';

import 'package:app/config.dart';
import 'package:app/models/kiosk_input.dart';
import 'package:app/models/kiosk_output.dart';
import 'package:app/pages/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:genkit/client.dart';

class GenerateImagePage extends StatefulWidget {
  final String image;
  final String template;
  const GenerateImagePage({
    super.key,
    required this.image,
    required this.template,
  });

  @override
  State<GenerateImagePage> createState() => _GenerateImagePageState();
}

class _GenerateImagePageState extends State<GenerateImagePage> {
  bool _finish = false;
  String _status = 'upload image';
  String _resultImageUrl = '';
  String _cpation = '';

  @override
  void initState() {
    super.initState();
    if (!_finish) {
      _uploadToStorage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            // generate image
            (_finish == false) ? _showProgressbar() : _showResultImage(context),
      ),
    );
  }

  Widget _showResultImage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(_resultImageUrl),
        Padding(padding: const EdgeInsets.all(8.0), child: Text(_cpation)),
        FilledButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          ),
          child: Text("Start New"),
        ),
      ],
    );
  }

  Center _showProgressbar() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [CircularProgressIndicator(), Text(_status)],
      ),
    );
  }

  Future<void> _uploadToStorage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final filename =
        'kiosk_images/${DateTime.now().millisecondsSinceEpoch}_stylized.png';
    final ref = storage.ref(filename);

    final metadata = SettableMetadata(contentType: 'image/png');

    final uploadTask = ref.putFile(File(widget.image), metadata);

    uploadTask.snapshotEvents.listen(
      (TaskSnapshot snapshot) async {
        switch (snapshot.state) {
          case TaskState.running:
            // Calculate progress percentage
            final progress =
                100.0 * (snapshot.bytesTransferred / snapshot.totalBytes);
            log('Upload is ${progress.toStringAsFixed(2)}% complete.');

            setState(() {
              _status = 'Upload is ${progress.toStringAsFixed(2)}%';
            });
            break;

          case TaskState.paused:
            log('Upload is paused.');
            break;

          case TaskState.canceled:
            log('Upload was canceled.');
            break;

          case TaskState.error:
            log('Upload encountered an error.');
            break;

          case TaskState.success:
            log('Upload complete!');
            // set status
            setState(() {
              _status = 'Upload complete!';
            });
            final _imageUrl = await snapshot.storage
                .ref(filename)
                .getDownloadURL();
            // call genkit to generate image
            await _callGenKit(imageUrl: _imageUrl, templateId: widget.template);
            break;
        }
      },
      onError: (e) {
        // Handle any errors that happen during the stream
        log('Error during upload stream: $e');
      },
    );
  }

  Future<void> _callGenKit({
    required String imageUrl,
    required String templateId,
  }) async {
    // define flow and action
    final genkitAction = defineRemoteAction(
      url: flowUrl,
      inputSchema: KioskInput.$schema,
      outputSchema: KioskOutput.$schema,
    );

    // log original image url from storage
    log('Original image url: ${imageUrl}');

    // TODO: test image for debug mode
    if (kDebugMode) {
      imageUrl =
          "https://www.anthropics.com/portraitpro/img/page-images/homepage/v22/what-can-it-do-2B.jpg";
    }

    setState(() {
      _status = "Generating...";
    });

    final result = await genkitAction.call(
      input: KioskInput(imageUrl: imageUrl, templateId: templateId),
    );

    log('$result');

    var resultImageUrl = result.imageUrl;

    // TODO: replace url
    if (kDebugMode) {
      if (Platform.isAndroid) {
        resultImageUrl = result.imageUrl.replaceAll('127.0.0.1', '10.0.2.2');
      }
    }

    setState(() {
      _resultImageUrl = resultImageUrl;
      _cpation = result.caption;
      _finish = true;
    });
  }
}
