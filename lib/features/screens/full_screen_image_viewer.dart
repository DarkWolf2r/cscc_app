import 'dart:typed_data';

import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final List<Uint8List> files;
  final int initialIndex;

  const FullScreenImageViewer({
    Key? key,
    required this.files,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: files.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.memory(
              files[index],
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}
