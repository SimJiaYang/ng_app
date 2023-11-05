import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/address_model.dart';
import 'package:nurserygardenapp/providers/address_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class AddressDetailScreen extends StatefulWidget {
  final String addressID;
  const AddressDetailScreen({super.key, required this.addressID});

  @override
  State<AddressDetailScreen> createState() => _AddressDetailScreenState();
}

class _AddressDetailScreenState extends State<AddressDetailScreen> {
  late AddressProvider address_prov =
      Provider.of<AddressProvider>(context, listen: false);
  Address address = Address();
  TextEditingController _addressController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  _loadData() {
    setState(() {
      address = address_prov.addressList.firstWhere(
        (element) => element.id.toString() == widget.addressID,
      );
      _addressController.text = address.address ?? "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isCenter: false,
        isBackButtonExist: false,
        isBgPrimaryColor: true,
        context: context,
        title: "Edit Address",
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: CustomTextField(
                  maxLines: 3,
                  inputType: TextInputType.streetAddress,
                  controller: _addressController,
                  hintText: "Address",
                  isShowBorder: true,
                  isShowPrefixIcon: true,
                  prefixIconUrl: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                  ),
                  inputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your address";
                    }
                  },
                ),
              ),
              Consumer<AddressProvider>(
                  builder: (context, addressProvider, child) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: CustomButton(
                    customTextStyle: TextStyle(color: Colors.white),
                    backgroundColor: Colors.red,
                    btnTxt: "Delete",
                    onTap: () async {
                      if (addressProvider.isLoading) return;
                      QuickAlert.show(
                        headerBackgroundColor: Colors.black,
                        barrierDismissible: false,
                        context: context,
                        type: QuickAlertType.warning,
                        showCancelBtn: true,
                        showConfirmBtn: true,
                        text: 'Do you want to delete this address',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: ColorResources.COLOR_PRIMARY,
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                        },
                        onConfirmBtnTap: () async {
                          Navigator.pop(context);
                          await addressProvider
                              .deleteAddress(
                                  context,
                                  new Address(
                                    id: address.id,
                                    address: _addressController.text,
                                  ))
                              .then((value) {
                            if (value) {
                              Navigator.pop(context, true);
                            }
                          });
                        },
                      );
                    },
                  ),
                );
              }),
              Consumer<AddressProvider>(
                  builder: (context, addressProvider, child) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: CustomButton(
                    btnTxt: "Save",
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) return;
                      if (addressProvider.isLoading) return;
                      await addressProvider
                          .updateAddress(
                              context,
                              new Address(
                                id: address.id,
                                address: _addressController.text,
                              ))
                          .then((value) {
                        if (value) {
                          Navigator.pop(context, true);
                        }
                      });
                    },
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
