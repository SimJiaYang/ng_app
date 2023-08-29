import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/user_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/base/custom_button.dart';
import 'package:nurserygardenapp/view/base/custom_space.dart';
import 'package:nurserygardenapp/view/base/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late var user_prov;
  String profileHeader = "User Profile";
  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  String _countryDialCode = "+60";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();

  late String _selectedDate;
  DateTime dateTime = DateTime.now();
  var dateFormat = DateFormat('yyyy-MM-dd');

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      if (pickedDate == null) return;
      dateTime = pickedDate;
      _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    });
  }

  @override
  void initState() {
    user_prov = Provider.of<UserProvider>(context, listen: false);
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserInformation();
    });
  }

  Future<void> getUserInformation() async {
    bool isSuccessful = await user_prov.showUserInformation(context);
    if (isSuccessful) {
      setState(() {
        profileHeader =
            user_prov.userModel.data!.name + "\'s Profile" ?? "User Profile";
        _nameController.text = user_prov.userModel.data!.name ?? "";
        _emailController.text = user_prov.userModel.data!.email ?? "";
        _phoneController.text = user_prov.userModel.data!.contactNumber ?? "";
        _addressController.text = user_prov.userModel.data!.address ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          profileHeader,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return userProvider.isLoading
              ? Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      color: ColorResources.COLOR_GREY_CHATEAU),
                                ),
                                VerticalSpacing(),
                                CustomTextField(
                                  hintText: "Please enter your name",
                                  isShowBorder: true,
                                  isShowPrefixIcon: true,
                                  prefixIconUrl: Icon(
                                    Icons.perm_identity_rounded,
                                    color: Colors.grey,
                                  ),
                                  focusNode: _nameFocus,
                                  nextFocus: _emailFocus,
                                  controller: _nameController,
                                  inputType: TextInputType.text,
                                ),
                                VerticalSpacing(
                                  height: 16,
                                ),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: ColorResources.COLOR_GREY_CHATEAU),
                                ),
                                VerticalSpacing(),
                                CustomTextField(
                                  hintText: "Please enter your email",
                                  isShowBorder: true,
                                  isShowPrefixIcon: true,
                                  prefixIconUrl: Icon(
                                    Icons.email_outlined,
                                    color: Colors.grey,
                                  ),
                                  focusNode: _emailFocus,
                                  nextFocus: _phoneFocus,
                                  controller: _emailController,
                                  inputType: TextInputType.emailAddress,
                                ),
                                VerticalSpacing(
                                  height: 16,
                                ),
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                      color: ColorResources.COLOR_GREY_CHATEAU),
                                ),
                                VerticalSpacing(),
                                Row(children: [
                                  CountryCodePicker(
                                    enabled: true,
                                    onChanged: (CountryCode countryCode) {
                                      _countryDialCode = countryCode.dialCode!;
                                    },
                                    initialSelection: _countryDialCode,
                                    favorite: [_countryDialCode],
                                    showDropDownButton: true,
                                    padding: EdgeInsets.zero,
                                    showFlagMain: true,
                                    dialogBackgroundColor:
                                        Theme.of(context).cardColor,
                                    backgroundColor:
                                        Theme.of(context).cardColor,
                                    textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .color),
                                  ),
                                  Expanded(
                                      child: CustomTextField(
                                    hintText: "Please enter your phone number",
                                    isShowBorder: true,
                                    isShowPrefixIcon: true,
                                    prefixIconUrl: const Icon(
                                      Icons.phone_outlined,
                                      color: Colors.grey,
                                    ),
                                    controller: _phoneController,
                                    focusNode: _phoneFocus,
                                    inputType: TextInputType.phone,
                                    nextFocus: _addressFocus,
                                    isCountryPicker: true,
                                  )),
                                ]),
                                VerticalSpacing(
                                  height: 16,
                                ),
                                Text(
                                  "Address",
                                  style: TextStyle(
                                      color: ColorResources.COLOR_GREY_CHATEAU),
                                ),
                                VerticalSpacing(),
                                CustomTextField(
                                  hintText: "Please enter your address",
                                  isShowBorder: true,
                                  isShowPrefixIcon: true,
                                  prefixIconUrl: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey,
                                  ),
                                  focusNode: _addressFocus,
                                  controller: _addressController,
                                  inputType: TextInputType.streetAddress,
                                  maxLines: 3,
                                  inputAction: TextInputAction.done,
                                ),
                                VerticalSpacing(
                                  height: 16,
                                ),
                                CustomButton(
                                  btnTxt: 'Save',
                                  onTap: () async {},
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
