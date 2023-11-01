import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/address_model.dart';
import 'package:nurserygardenapp/providers/address_provider.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_textfield.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  TextEditingController _addressController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
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
        title: "Add New Address",
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
                  hintText: "Please enter your address",
                  isShowBorder: true,
                  isShowPrefixIcon: true,
                  prefixIconUrl: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                  ),
                  inputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Address Field Cannot be empty";
                    }
                  },
                ),
              ),
              Consumer<AddressProvider>(
                  builder: (context, addressProvider, child) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomButton(
                    btnTxt: "Save",
                    onTap: () async {
                      if (addressProvider.isLoading) return;
                      await addressProvider
                          .addNewAddress(
                              context,
                              new Address(
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
