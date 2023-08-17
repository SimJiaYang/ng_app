import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/util/app_constants.dart';

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
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Expanded(
                  child: CachedNetworkImage(
                imageUrl: "${widget.plant.image!}",
                memCacheHeight: 400, //this line
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Image.asset("assets/image/app_icon.png"),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )),
              Text(
                widget.plant.name!,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ],
          )),
    );
  }
}
