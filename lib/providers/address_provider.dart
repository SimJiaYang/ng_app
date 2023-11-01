import 'package:nurserygardenapp/data/model/address_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/address_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  final AddressRepo addressRepo;
  final SharedPreferences sharedPreferences;

  AddressProvider({required this.addressRepo, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AddressModel _addressModel = AddressModel();
  AddressModel get addressModel => _addressModel;

  List<Address> _addressList = [];
  List<Address> get addressList => _addressList;

  String _noMoreDataMessage = '';
  String get noMoreDataMessage => _noMoreDataMessage;

  /// ================== DELIVERY LIST ==================
  Future<bool> getAddressList(BuildContext context, params,
      {bool isLoadMore = false, bool isLoad = true}) async {
    if (!isLoadMore) {
      _addressList = [];
    }

    bool result = false;
    String query = ResponseHelper.buildQuery(params);
    int limit = params['limit'] != null ? int.parse(params['limit']) : 8;

    _isLoading = isLoad;
    notifyListeners();

    ApiResponse apiResponse = await addressRepo.getAddress(query);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _addressModel = AddressModel.fromJson(apiResponse.response!.data);
        _addressList = _addressModel.data!.addressList!.address ?? [];
        if (_addressList.length < limit && limit > 8) {
          _noMoreDataMessage = AppConstants.NO_MORE_DATA;
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<bool> updateAddress(BuildContext context, Address address) async {
    bool result = false;
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await addressRepo.updateAddress(address);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }
}
