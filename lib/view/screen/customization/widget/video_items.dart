import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;

  VideoItems({
    Key? key,
    required this.videoPlayerController,
    required this.looping,
    required this.autoplay,
  }) : super(key: key);

  @override
  State<VideoItems> createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  late ChewieController _chewieController;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 9 / 16,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    _chewieController.setVolume(0);
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
    widget.videoPlayerController.dispose();
    widget.videoPlayerController.removeListener(_onVideoFirstLoad);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirstLoad) {
      widget.videoPlayerController.addListener(_onVideoFirstLoad);
    }
  }

  void _onVideoFirstLoad() {
    if (widget.videoPlayerController.value.isInitialized) {
      // Source has been loaded, remove the listener and update the UI
      widget.videoPlayerController.removeListener(_onVideoFirstLoad);
      setState(() {
        isFirstLoad = false;
      });
    }
  }

  // Expose a function to pause the video
  void pauseVideo() {
    _chewieController.pause();
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

    return WillPopScope(
      onWillPop: () async {
        await _chewieController.pause();
        return true;
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Theme(
          data: ThemeData.light().copyWith(
            platform: TargetPlatform.iOS,
          ),
          child: Stack(
            children: [
              Chewie(
                controller: _chewieController,
              ),

              //Custom Loading Screen
              if (isFirstLoad)
                Container(
                  width: double.infinity,
                  height: size.height,
                  color: ColorResources
                      .COLOR_DEFAULT, // Customize the background color
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                          color: ColorResources.COLOR_PRIMARY, size: 45),
                      Text(
                        "Your Customization Video is Loading...",
                        style: _subTitle,
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
