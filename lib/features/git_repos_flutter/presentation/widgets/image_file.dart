import 'dart:io';

import 'package:flutter/material.dart';

class ImageFile extends StatelessWidget {
  final String filePath;
  final String userId;
  final File userFile;
  final double radius;

  ImageFile(
      {super.key,
      required this.filePath,
      required this.userId,
      required this.radius})
      : userFile = File('$filePath$userId');

  @override
  Widget build(BuildContext context) {
    if (userFile.existsSync()) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(userFile),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color.fromARGB(0, 0, 148, 246),
      );
    }
  }
}
