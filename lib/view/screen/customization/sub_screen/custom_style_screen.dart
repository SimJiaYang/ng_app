import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/customize_provider.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:provider/provider.dart';

class CustomStyleScreen extends StatefulWidget {
  const CustomStyleScreen({super.key});

  @override
  State<CustomStyleScreen> createState() => _CustomStyleScreenState();
}

class _CustomStyleScreenState extends State<CustomStyleScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(
        isCenter: false,
        isBgPrimaryColor: true,
        title: 'Select the Style',
        isBackButtonExist: false,
        context: context,
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: Consumer<CustomizeProvider>(
            builder: (context, customProvider, child) {
              return customProvider.isFetching &&
                      customProvider.customList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width * 0.3,
                          height: 15,
                          color: Colors.grey[400],
                        ),
                        LoadingThreeCircle(),
                      ],
                    )
                  : customProvider.customList.isEmpty &&
                          !customProvider.isLoading
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'No Customize Data Available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          width: size.width,
                          height: size.height,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '4: Please select the style that you are prefer.',
                                  style: CustomTextStyles(context).titleStyle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'In this section, you are required to select the style of customization from the practical example.',
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '*You can select the style by clicking on the image.',
                                  style: CustomTextStyles(context)
                                      .subTitleStyle
                                      .copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  // color: Colors.white,
                                  width: double.infinity,
                                  height: size.height * 0.8,
                                  // height: size.height * 0.5,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          customProvider.customList.length,
                                      itemBuilder: (context, index) {
                                        if (index >=
                                            customProvider.customList.length) {
                                          return LoadingThreeCircle();
                                        } else if (index >=
                                            customProvider.customList.length) {
                                          // return Container(
                                          //   height: 50,
                                          // );
                                        } else {
                                          return Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      customProvider.item_url =
                                                          customProvider
                                                                  .customList[
                                                                      index]
                                                                  .videoUrl ??
                                                              '';
                                                    });
                                                    customProvider
                                                        .setSelectedCustomStyle(
                                                            customProvider
                                                                    .customList[
                                                                        index]
                                                                    .name ??
                                                                '');
                                                    Navigator.pushNamed(
                                                        context,
                                                        Routes
                                                            .getCustomizationShowRoute());
                                                  },
                                                  child: Container(
                                                    height: size.height * 0.6,
                                                    width: size.width * 0.9,
                                                    child: CachedNetworkImage(
                                                      filterQuality:
                                                          FilterQuality.high,
                                                      imageUrl:
                                                          "${customProvider.customList[index].imageUrl}",
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder:
                                                          (context, url) =>
                                                              Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 20,
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        );
            },
          )),
    );
  }
}
