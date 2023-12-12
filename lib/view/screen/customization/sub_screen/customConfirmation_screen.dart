import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nurserygardenapp/providers/address_provider.dart';
import 'package:nurserygardenapp/providers/customize_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/custom_text_style.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/circular_indicator.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_helper/payment_type.dart';
import 'package:provider/provider.dart';

class CustomConfirmationScreen extends StatefulWidget {
  const CustomConfirmationScreen({
    super.key,
  });

  @override
  State<CustomConfirmationScreen> createState() =>
      _CustomConfirmationScreenState();
}

class _CustomConfirmationScreenState extends State<CustomConfirmationScreen> {
  late CustomizeProvider custom_prov =
      Provider.of<CustomizeProvider>(context, listen: false);
  late AddressProvider address_prov =
      Provider.of<AddressProvider>(context, listen: false);
  double totalAmount = 0;

  final String emptyAddress_msg =
      "Please add your address prior make the order.";

  final String error_msg = "Some error occur, please try again later.";

  String address = "";

  var params = {};

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return _getInitalData();
    });
  }

  _getInitalData() async {
    double total = 0;
    custom_prov.selectedItem.forEach((element) {
      total += element.quantity! * element.price!;
    });
    bool result = await address_prov.getAddressList(context, params);

    setState(() {
      totalAmount = total;
      if (result) {
        if (address_prov.addressList.length > 0) {
          address = address_prov.addressList[0].address ?? '';
        } else {
          address = emptyAddress_msg;
        }
      } else {
        address = error_msg;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorResources.COLOR_PRIMARY,
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            title: Text(
              "Checkout",
              style: CustomTextStyles(context).subTitleStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white),
            )),
        bottomNavigationBar: BottomAppBar(
            height: 60,
            padding: EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(0, 2),
                      blurRadius: 10.0),
                ],
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorResources.COLOR_WHITE,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Total RM: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: ColorResources.COLOR_BLACK),
                                ),
                                Text(totalAmount.toStringAsFixed(2),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: ColorResources.COLOR_PRIMARY))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<CustomizeProvider>(
                          builder: (context, customProvider, child) {
                        return GestureDetector(
                          onTap: () async {
                            if (address == emptyAddress_msg) {
                              EasyLoading.showError('Please add your address',
                                  dismissOnTap: true,
                                  duration: Duration(milliseconds: 500));
                              return;
                            }
                            if (address == error_msg) {
                              EasyLoading.showError(
                                  'Some error occur, please try again later',
                                  dismissOnTap: true,
                                  duration: Duration(milliseconds: 500));
                              return;
                            }
                            if (customProvider.isLoading) return;
                            await customProvider
                                .addOrder(context, address)
                                .then((value) {
                              if (value) {
                                if (value == true) {
                                  Navigator.pushReplacementNamed(
                                      context,
                                      Routes.getPaymentRoute(
                                          (PaymentType.card).toString(),
                                          customProvider.orderIdCreated));
                                }
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: address == emptyAddress_msg ||
                                      address == error_msg
                                  ? ColorResources.COLOR_PRIMARY
                                      .withOpacity(0.7)
                                  : ColorResources.COLOR_PRIMARY,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                customProvider.isLoading
                                    ? CircularProgress()
                                    : Text(
                                        'Place Order',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ]),
            )),
        body: Consumer2<AddressProvider, CustomizeProvider>(
            builder: (context, addressProvider, customProvider, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: addressProvider.isLoading
                ? LoadingThreeCircle()
                : SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                    context, Routes.getOrderAddressRoute())
                                .then((value) {
                              if (value == null) return;
                              setState(() {
                                address = value as String;
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivery Address",
                                  style: CustomTextStyles(context)
                                      .titleStyle
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  address,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Divider(
                            color: ColorResources.COLOR_GREY.withOpacity(0.1),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: customProvider.selectedItem.length < 2
                              ? MediaQuery.of(context).size.height / 5
                              : customProvider.selectedItem.length == 3
                                  ? MediaQuery.of(context).size.height / 2.8
                                  : MediaQuery.of(context).size.height / 2.5,
                          child: ListView.builder(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              shrinkWrap: true,
                              itemCount: customProvider.selectedItem.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    offset: const Offset(0, 2),
                                                    blurRadius: 10.0),
                                              ],
                                            ),
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                height: 120,
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    if (customProvider
                                                            .selectedItem[index]
                                                            .plantId !=
                                                        null)
                                                      Container(
                                                        height: 80,
                                                        width: 80,
                                                        child:
                                                            CachedNetworkImage(
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                          imageUrl:
                                                              "${customProvider.plantList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        customProvider
                                                                            .selectedItem[index]
                                                                            .plantId;
                                                                  }).first.imageURL!}",
                                                          memCacheHeight: 200,
                                                          memCacheWidth: 200,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color:
                                                                  ColorResources
                                                                      .COLOR_GRAY,
                                                            )),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    if (customProvider
                                                            .selectedItem[index]
                                                            .productId !=
                                                        null)
                                                      Container(
                                                        height: 80,
                                                        width: 80,
                                                        child:
                                                            CachedNetworkImage(
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                          imageUrl:
                                                              "${customProvider.productList.firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        customProvider
                                                                            .selectedItem[index]
                                                                            .productId,
                                                                    orElse: () =>
                                                                        customProvider
                                                                            .soilList
                                                                            .firstWhere(
                                                                      (element) =>
                                                                          element
                                                                              .id ==
                                                                          customProvider
                                                                              .selectedItem[index]
                                                                              .productId,
                                                                    ),
                                                                  ).imageURL}",
                                                          memCacheHeight: 200,
                                                          memCacheWidth: 200,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color:
                                                                  ColorResources
                                                                      .COLOR_GRAY,
                                                            )),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (customProvider
                                                                      .selectedItem[
                                                                          index]
                                                                      .plantId !=
                                                                  null)
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    child: Text(
                                                                      "${customProvider.plantList.where((element) {
                                                                            return element.id ==
                                                                                customProvider.selectedItem[index].plantId;
                                                                          }).first.name}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ),
                                                              if (customProvider
                                                                      .selectedItem[
                                                                          index]
                                                                      .productId !=
                                                                  null)
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    width: 100,
                                                                    child: Text(
                                                                      "${customProvider.productList.firstWhere((element) => element.id == customProvider.selectedItem[index].productId, orElse: () => customProvider.soilList.firstWhere(
                                                                            (element) =>
                                                                                element.id ==
                                                                                customProvider.selectedItem[index].productId,
                                                                          )).name}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                  "Quantity: ${customProvider.selectedItem[index].quantity}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                    "RM" +
                                                                        "${(customProvider.selectedItem[index].quantity! * customProvider.selectedItem[index].price!).toStringAsFixed(2)}",
                                                                    style: TextStyle(
                                                                        color: ColorResources
                                                                            .COLOR_PRIMARY,
                                                                        fontSize:
                                                                            16))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                    ]);
                              }),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Total",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "RM" + "${totalAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: ColorResources.COLOR_PRIMARY),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.monetization_on),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      "Payment Options",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Debit/Credit card",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: ColorResources.COLOR_PRIMARY),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }));
  }
}
