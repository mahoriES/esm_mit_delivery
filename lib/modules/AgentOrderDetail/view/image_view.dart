import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
          : CachedNetworkImage(
              height: double.infinity,
              width: double.infinity,
              imageUrl: imageUrl ?? "",
              fit: BoxFit.contain,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, _) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
