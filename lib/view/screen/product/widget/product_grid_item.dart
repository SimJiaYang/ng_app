import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';

class ProductGridItem extends StatefulWidget {
  const ProductGridItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final void Function() onTap;

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
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
                    child: Container(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: "${widget.product.image!}",
                    memCacheHeight: 400, //this line
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: ColorResources.COLOR_GRAY,
                      )),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )),
                VerticalSpacing(),
                Text(
                  widget.product.name!,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                ),
                VerticalSpacing(),
                Text(
                  "RM " + widget.product.price!.toString(),
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
