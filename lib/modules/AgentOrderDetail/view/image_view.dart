import 'dart:io';

import 'package:esamudaayapp/utilities/colors.dart';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final File image;
  final String imageUrl;

  const ImageDisplay({Key key, this.image, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.icColors,
            ),
            onPressed: () async {
              Navigator.pop(context);
            }),
      ),
      body: image != null
          ? Image.file(
              image,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
    );
  }
}
