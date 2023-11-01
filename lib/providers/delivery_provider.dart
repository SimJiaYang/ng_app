import 'package:nurserygardenapp/data/repositories/address_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  final AddressRepo addressRepo;
  final SharedPreferences sharedPreferences;

  AddressProvider({required this.addressRepo, required this.sharedPreferences});
}
