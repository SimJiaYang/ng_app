import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/user_provider.dart';
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
            user_prov.userModel.data!.name + "'s Profile" ?? "User Profile";
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
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                );
        },
      ),
    );
  }
}
