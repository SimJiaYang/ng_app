import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/user_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/images.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class UploadImageWidget extends StatefulWidget {
  final String? title;
  final String imageUrl;
  final bool isAllowUploadFile;
  final bool isDisabled;
  final String name;
  final Function(String, String, String) resultUrl;
  const UploadImageWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.resultUrl,
    this.title,
    this.isAllowUploadFile = false,
    this.isDisabled = false,
  });

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  // Provider
  late UserProvider _userProv =
      Provider.of<UserProvider>(context, listen: false);

  // Data Type
  final picker = ImagePicker();
  final String _loadFailedImageUrl = Images.load_image_failed;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(covariant UploadImageWidget oldWidget) {
    if (widget.imageUrl != oldWidget.imageUrl) {
      setState(() {
        imageUrl = widget.imageUrl;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _showFilePicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
            child: Wrap(
          children: <Widget>[
            if (widget.isAllowUploadFile)
              ListTile(
                  leading: const Icon(Icons.description),
                  title: Text('Document'),
                  onTap: () {
                    _fileFromDucument(context);
                    Navigator.of(context).pop();
                  }),
            ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  _handleImage(context, ImageSource.gallery);
                  Navigator.of(context).pop();
                }),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text("Cemera"),
              onTap: () {
                _handleImage(context, ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
      },
    );
  }

  _fileFromDucument(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null && context.mounted) {
      EasyLoading.show(status: 'Uploading...');
      File file = File(result.files.single.path!);
      await _handleUploadImage(file, context);
    }
  }

  _handleImage(BuildContext context, ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null && context.mounted) {
      EasyLoading.show(status: 'Uploading...');
      File image = File(pickedFile.path);
      await _handleUploadImage(image, context);
    }
  }

  _handleUploadImage(File file, BuildContext context) async {
    _userProv.resetImageUrl();
    await _userProv.upload(file, 'image', context);
    widget.resultUrl(widget.name, _userProv.imageUrl, _userProv.imageName);
    EasyLoading.dismiss();
  }

  bool _isImage(String filePath) {
    final validImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final extension = filePath.toLowerCase().split('.').last;
    return validImageExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return GestureDetector(
        onTap: () {
          if (widget.isDisabled || userProvider.isUploading) return;
          _showFilePicker(context);
        },
        child: ClipOval(
          child: SizedBox.fromSize(
              size: Size.fromRadius(50), // Image radius
              child: imageUrl == Images.profile_header || imageUrl == "null"
                  ? Image.asset(Images.profile_header, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      filterQuality: FilterQuality.low,
                      imageUrl: imageUrl,
                      memCacheHeight: 200,
                      memCacheWidth: 200,
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: ColorResources.COLOR_GRAY,
                        )),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset(Images.profile_header, fit: BoxFit.cover),
                    )),
        ),
      );
    });

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Consumer<UserProvider>(builder: (context, userProvider, child) {
    //       return GestureDetector(
    //         child:

    //         Container(
    //           width: MediaQuery.of(context).size.width,
    //           height: 130,
    //           decoration: BoxDecoration(
    //             color: Theme.of(context).cardColor,
    //             border: Border.all(
    //                 color: ColorResources.COLOR_LIGHT_GREY, width: 1),
    //             borderRadius: BorderRadius.circular(10),
    //             image: (widget.imageUrl.isNotEmpty && _isImage(widget.imageUrl))
    //                 ? DecorationImage(
    //                     image: NetworkImage(imageUrl),
    //                     onError: (exception, stackTrace) {
    //                       setState(() {
    //                         imageUrl = _loadFailedImageUrl;
    //                       });
    //                     },
    //                   )
    //                 : null,
    //           ),
    //           child: (!userProvider.isUploading && widget.imageUrl.isEmpty)
    //               ? Center(
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Icon(Icons.edit_document,
    //                           size: 34, color: ColorResources.COLOR_LIGHT_GREY),
    //                       const SizedBox(
    //                         height: 10,
    //                       ),
    //                       Text(
    //                         "Choose File",
    //                         style: const TextStyle(
    //                             fontWeight: FontWeight.w500,
    //                             fontSize: Dimensions.FONT_SIZE_DEFAULT,
    //                             color: ColorResources.COLOR_LIGHT_GREY),
    //                       )
    //                     ],
    //                   ),
    //                 )
    //               : Center(
    //                   child: _isImage(widget.imageUrl)
    //                       ? null
    //                       : Text(
    //                           '${widget.name} 1',
    //                         ),
    //                 ),
    //         ),
    //       );
    //     }),
    //   ],
    // );
  }
}
