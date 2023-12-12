import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nurserygardenapp/providers/address_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/screen/address/widget/empty_address.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late AddressProvider address_prov =
      Provider.of<AddressProvider>(context, listen: false);

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (address_prov.addressList.length < int.parse(params['limit']!)) return;
      int currentLimit = int.parse(params['limit']!);
      currentLimit += 8;
      params['limit'] = currentLimit.toString();
      _loadData(isLoadMore: true);
    }
  }

  // Param
  var params = {
    'limit': '8',
  };

  Future<void> _loadData({bool isLoadMore = false}) async {
    await address_prov.getAddressList(context, params,
        isLoadMore: isLoadMore, isLoad: true);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isCenter: false,
        isBackButtonExist: false,
        isBgPrimaryColor: true,
        context: context,
        title: "My Address",
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        width: double.infinity,
        child: Consumer<AddressProvider>(
            builder: (context, addressProvider, child) {
          return addressProvider.isLoading &&
                  addressProvider.addressList.isEmpty
              ? ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return EmptyAddress();
                  })
              : addressProvider.addressList.isEmpty &&
                      !addressProvider.isLoading
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'No Address Found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              onTap: () {
                                Navigator.pushNamed(
                                        context, Routes.getAddAddressRoute())
                                    .then((value) {
                                  if (value == true) {
                                    _loadData();
                                  }
                                });
                              },
                              backgroundColor: ColorResources.COLOR_PRIMARY,
                              btnTxt: "Add new address",
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(children: [
                      ListView.builder(
                          padding: (addressProvider
                                          .noMoreDataMessage.isNotEmpty &&
                                      !addressProvider.isLoading ||
                                  (addressProvider.noMoreDataMessage.isEmpty &&
                                      addressProvider.addressList.length < 8))
                              ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                              : EdgeInsets.only(
                                  bottom: 20, left: 10, right: 10, top: 0),
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: addressProvider.addressList.length +
                              ((addressProvider.isLoading &&
                                      addressProvider.addressList.length >= 8)
                                  ? 1
                                  : addressProvider.noMoreDataMessage.isNotEmpty
                                      ? 1
                                      : 0),
                          itemBuilder: (context, index) {
                            if (index >= addressProvider.addressList.length &&
                                addressProvider.noMoreDataMessage.isEmpty) {
                              return Center(
                                  child: LoadingAnimationWidget.waveDots(
                                      color: ColorResources.COLOR_PRIMARY,
                                      size: 40));
                            } else if (index >=
                                    addressProvider.addressList.length &&
                                addressProvider.noMoreDataMessage.isNotEmpty) {
                              return Container(
                                height: 50,
                              );
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context,
                                        Routes.getAddressDetailRoute(
                                          addressProvider.addressList[index].id!
                                              .toString(),
                                        )).then((value) => {
                                          if (value == true) {_loadData()}
                                        });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            offset: const Offset(0, 2),
                                            blurRadius: 10.0),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            addressProvider
                                                .addressList[index].address!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                      if (!addressProvider.isLoading)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: CustomButton(
                              onTap: () {
                                Navigator.pushNamed(
                                        context, Routes.getAddAddressRoute())
                                    .then((value) {
                                  if (value == true) {
                                    _loadData();
                                  }
                                });
                              },
                              backgroundColor: ColorResources.COLOR_PRIMARY,
                              btnTxt: "Add new address",
                            ),
                          ),
                        ),
                    ]);
        }),
      ),
    );
  }
}
