import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';

class ImageEnlargeWidget extends StatefulWidget {
  final String tag;
  final String url;

  ImageEnlargeWidget({required this.tag, required this.url});

  @override
  _ImageEnlargeWidgetState createState() => _ImageEnlargeWidgetState();
}

class _ImageEnlargeWidgetState extends State<ImageEnlargeWidget> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          child: Center(
            child: Hero(
              tag: widget.tag,
              child: CachedNetworkImage(
                imageUrl: widget.url,
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: ColorResources.COLOR_GRAY,
                  )),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
