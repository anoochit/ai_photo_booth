import 'package:app/pages/generate.dart';
import 'package:flutter/material.dart';

class TemplatePage extends StatefulWidget {
  final String image;
  const TemplatePage({super.key, required this.image});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  final _template = [
    'cyberpunk',
    'fantasy',
    'anime',
    'steampunk',
    'retrowave',
    'solarpunk',
    'dieselpunk',
    'vaporwave',
    'kawaii-pop',
    'low-poly',
    'flat-illustration',
    'impressionism ',
    'baroque',
    'watercolor',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: _template.length,
          itemBuilder: (context, index) => Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenerateImagePage(
                    image: widget.image,
                    template: _template[index],
                  ),
                ),
              ),
              child: Center(child: Text(_template[index])),
            ),
          ),
        ),
      ),
    );
  }
}
