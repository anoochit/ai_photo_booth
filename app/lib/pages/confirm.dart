import 'dart:io';

import 'package:app/pages/template.dart';
import 'package:flutter/material.dart';

class ConfirmImagePage extends StatefulWidget {
  final String image;
  const ConfirmImagePage({super.key, required this.image});

  @override
  State<ConfirmImagePage> createState() => _ConfirmImagePageState();
}

class _ConfirmImagePageState extends State<ConfirmImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // text
            Text('Choose this image ?'),
            // image
            Image.file(File(widget.image)),
            // action
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // cancel
                FilledButton.tonal(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                // ok
                FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TemplatePage(image: widget.image),
                    ),
                  ),
                  child: Text('Ok'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
