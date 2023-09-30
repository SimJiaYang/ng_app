import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/user_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/images.dart';
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
  late UserProvider user_prov =
      Provider.of<UserProvider>(context, listen: false);
  String profileHeader = "";
  GlobalKey<FormState>? _formKey = GlobalKey<FormState>();
  String _countryDialCode = "+60";
  String _profileImage = "null";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();

  String _selectedDate = "";
  DateTime dateTime = DateTime.now();
  var dateFormat = DateFormat('yyyy-MM-dd');

  void _presentDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(1923, 1, 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDate,
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
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserInformation();
    });
  }

  Future<void> _getUserInformation() async {
    bool isSuccessful = await user_prov.showUserInformation(context);
    if (!mounted) return;
    if (isSuccessful) {
      debugPrint("User Name: " + user_prov.userModel.data!.name!);
      setState(() {
        profileHeader = user_prov.userModel.data!.name ?? "User";
        profileHeader = profileHeader + "\'s Profile";
        _nameController.text = user_prov.userModel.data!.name ?? "";
        _emailController.text = user_prov.userModel.data!.email ?? "";
        _phoneController.text = user_prov.userModel.data!.contactNumber ?? "";
        _addressController.text = user_prov.userModel.data!.address ?? "";
        _profileImage =
            user_prov.userModel.data!.image_url ?? Images.profile_header;
        _selectedDate = user_prov.userModel.data!.birthDate == null
            ? "Please enter your birth date"
            : DateFormat('yyyy-MM-dd')
                .format(user_prov.userModel.data!.birthDate!)
                .toString();
      });
    }
  }

  Future<void> _handleSubmission() async {
    if (_formKey!.currentState!.validate()) {
      print(_nameController.text);
      print(_emailController.text);
      print(_addressController.text);
      print(_phoneController.text);
      print(_profileImage);
      print(_selectedDate);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();
    _phoneFocus.dispose();
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
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 160,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage(Images.profile_bg),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        top: 100,
                                        child: ClipOval(
                                          child: SizedBox.fromSize(
                                              size: Size.fromRadius(
                                                  50), // Image radius
                                              child: _profileImage ==
                                                          Images
                                                              .profile_header ||
                                                      _profileImage == "null"
                                                  ? Image.asset(
                                                      Images.profile_header,
                                                      fit: BoxFit.cover)
                                                  : CachedNetworkImage(
                                                      filterQuality:
                                                          FilterQuality.low,
                                                      imageUrl: _profileImage,
                                                      memCacheHeight: 200,
                                                      memCacheWidth: 200,
                                                      placeholder:
                                                          (context, url) =>
                                                              Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          color: ColorResources
                                                              .COLOR_GRAY,
                                                        )),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              Images
                                                                  .profile_header,
                                                              fit:
                                                                  BoxFit.cover),
                                                    )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalSpacing(
                                  height: 10,
                                ),
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
                                  isReadOnly: true,
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
                                  "Birth Date",
                                  style: TextStyle(
                                      color: ColorResources.COLOR_GREY_CHATEAU),
                                ),
                                VerticalSpacing(),
                                InkWell(
                                    onTap: () {
                                      _presentDatePicker(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 18),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1,
                                            color: ColorResources
                                                .COLOR_GREY_CHATEAU,
                                            style: BorderStyle.solid),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: Colors.grey,
                                            size: 15,
                                          ),
                                          HorizontalSpacing(
                                            width: 13,
                                          ),
                                          Text(
                                            _selectedDate,
                                            style: _selectedDate ==
                                                    "Please enter your birth date"
                                                ? TextStyle(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_DEFAULT,
                                                    color: ColorResources
                                                        .COLOR_GREY_CHATEAU)
                                                : Theme.of(context)
                                                    .textTheme
                                                    .displayMedium
                                                    ?.copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE),
                                          )
                                        ],
                                      ),
                                    )),
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
                                  onTap: () async {
                                    await _handleSubmission();
                                  },
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