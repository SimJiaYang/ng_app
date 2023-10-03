import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';

class PlantGridItem extends StatefulWidget {
  const PlantGridItem({
    super.key,
    required this.plant,
    required this.onTap,
  });

  final Plant plant;
  final void Function() onTap;

  @override
  State<PlantGridItem> createState() => _PlantGridItemState();
}

class _PlantGridItemState extends State<PlantGridItem> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorResources.COLOR_WHITE),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: CachedNetworkImage(
                      filterQuality: FilterQuality.low,
                      imageUrl: "${widget.plant.imageURL!}",
                      memCacheHeight: 200,
                      memCacheWidth: 200,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: ColorResources.COLOR_GRAY,
                        )),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
                VerticalSpacing(),
                Text(
                  widget.plant.name!,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                ),
                VerticalSpacing(),
                Text(
                  "RM " + widget.plant.price!.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: ColorResources.COLOR_PRIMARY,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          )),
    );
  }
}
