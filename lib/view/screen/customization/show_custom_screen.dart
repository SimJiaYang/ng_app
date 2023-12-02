import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nurserygardenapp/providers/customize_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:nurserygardenapp/view/screen/customization/widget/video_items.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ShowCustomScreen extends StatefulWidget {
  const ShowCustomScreen({super.key});

  @override
  State<ShowCustomScreen> createState() => _ShowCustomScreenState();
}

class _ShowCustomScreenState extends State<ShowCustomScreen> {
  late CustomizeProvider custom_prov =
      Provider.of<CustomizeProvider>(context, listen: false);

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  _loadData() async {
    await custom_prov.getItemUrl(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context).textTheme;
    TextStyle _title = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.8),
    );
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: const Color.fromRGBO(45, 45, 45, 1).withOpacity(0.6),
    );

    return Scaffold(
        appBar: CustomAppBar(
          isBgPrimaryColor: true,
          title: 'Your Customization',
          isBackButtonExist: false,
          context: context,
          isCenter: false,
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<CustomizeProvider>(
                    builder: (context, customProvider, child) {
                  if (customProvider.isFetching) {
                    return Container(
                        height: size.height,
                        width: size.width,
                        child: Center(
                          child: LoadingAnimationWidget.inkDrop(
                              color: ColorResources.COLOR_PRIMARY, size: 43),
                        ));
                  } else {
                    return Container(
                      height: size.height * 0.7,
                      width: size.width,
                      child: VideoItems(
                        // ignore: deprecated_member_use
                        videoPlayerController:
                            // ignore: deprecated_member_use
                            VideoPlayerController.networkUrl(
                          Uri.parse(
                            customProvider.item_url.toString(),
                          ),
                          videoPlayerOptions: VideoPlayerOptions(
                            mixWithOthers: false,
                            allowBackgroundPlayback: false,
                          ),
                        ),
                        looping: true,
                        autoplay: true,
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ));
  }
}