import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';

class PlantGridItem extends StatelessWidget {
  const PlantGridItem({
    super.key,
    required this.plant,
    required this.onTap,
  });

  final Plant plant;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          plant.name!,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    );
  }
}
