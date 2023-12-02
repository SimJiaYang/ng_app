import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:nurserygardenapp/providers/customize_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:provider/provider.dart';

class ShowCustomScreen extends StatefulWidget {
  const ShowCustomScreen({super.key});

  @override
  State<ShowCustomScreen> createState() => _ShowCustomScreenState();
}

class _ShowCustomScreenState extends State<ShowCustomScreen> {
  late CustomizeProvider custom_prov =
      Provider.of<CustomizeProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() async {
    await custom_prov.getItemUrl(context);
  }

  // @override
  // void setState(VoidCallback fn) {
  //   if (mounted) {
  //     super.setState(fn);
  //   }
  // }

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
          child: Consumer<CustomizeProvider>(
            builder: (context, customProvider, child) {
              return customProvider.isFetching &&
                      customProvider.item_url.isEmpty
                  ? Container()
                  : customProvider.item_url.isEmpty &&
                          !customProvider.isFetching
                      ? Center(
                          child: Text(
                            'No Item Selected',
                            style: _title,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200,
                                child: Container(),
                              )
                            ],
                          ),
                        );
            },
          ),
        ));
  }
}
