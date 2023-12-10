import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/custom_style_model.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/customize_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/cart_model.dart';

class CustomizeProvider extends ChangeNotifier {
  final CustomizeRepo customizeRepo;
  final SharedPreferences sharedPreferences;

  CustomizeProvider(
      {required this.customizeRepo, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PlantModel _plantModel = PlantModel();
  PlantModel get plantModel => _plantModel;

  List<Plant> _plantList = [];
  List<Plant> get plantList => _plantList;

  String _plantNoMoreData = '';
  String get plantNoMoreData => _plantNoMoreData;

  /// ================== PLANT LIST ==================
  Future<bool> listOfPlant(BuildContext context, params,
      {bool isLoadMore = false, bool isLoad = true}) async {
    if (!isLoadMore) {
      _plantList = [];
      _plantNoMoreData = '';
    }

    bool result = false;
    String query = ResponseHelper.buildQuery(params);
    int limit = params['limit'] != null ? int.parse(params['limit']) : 8;

    _isLoading = isLoad;
    notifyListeners();

    ApiResponse apiResponse = await customizeRepo.getPlantList(query);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _plantModel = PlantModel.fromJson(apiResponse.response!.data);
        _plantList = _plantModel.data!.plantList!.plant ?? [];
        if (_plantList.length < limit && limit > 8) {
          _plantNoMoreData = AppConstants.NO_MORE_DATA;
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  /// ================== PRODUCT LIST ==================
  ProductModel _productModel = ProductModel();
  ProductModel get productModel => _productModel;

  List<Product> _productList = [];
  List<Product> get productList => _productList;

  String _productNoMoreData = '';
  String get productNoMoreData => _productNoMoreData;

  /// ================== PLANT LIST ==================
  Future<bool> listOfProduct(BuildContext context, params,
      {bool isLoadMore = false, bool isLoad = true}) async {
    if (!isLoadMore) {
      _productList = [];
      _productNoMoreData = '';
    }

    bool result = false;
    String query = ResponseHelper.buildQuery(params);
    int limit = params['limit'] != null ? int.parse(params['limit']) : 8;

    _isLoading = isLoad;
    notifyListeners();

    ApiResponse apiResponse = await customizeRepo.getProductList(query);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _productModel = ProductModel.fromJson(apiResponse.response!.data);
        _productList = _productModel.data!.productsList!.product ?? [];
        if (_productList.length < limit && limit > 8) {
          _productNoMoreData = AppConstants.NO_MORE_DATA;
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  /// ================== SOIL LIST ==================
  ProductModel _soilModel = ProductModel();
  ProductModel get soilModel => _soilModel;

  List<Product> _soilList = [];
  List<Product> get soilList => _soilList;

  String _soilNoMoreData = '';
  String get soilNoMoreData => _soilNoMoreData;

  /// ================== PLANT LIST ==================
  Future<bool> listOfSoil(BuildContext context, params,
      {bool isLoadMore = false, bool isLoad = true}) async {
    if (!isLoadMore) {
      _soilList = [];
      _soilNoMoreData = '';
    }

    bool result = false;
    String query = ResponseHelper.buildQuery(params);
    int limit = params['limit'] != null ? int.parse(params['limit']) : 8;

    _isLoading = isLoad;
    notifyListeners();

    ApiResponse apiResponse = await customizeRepo.getProductList(query);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _soilModel = ProductModel.fromJson(apiResponse.response!.data);
        _soilList = _soilModel.data!.productsList!.product ?? [];
        if (_soilList.length < limit && limit > 8) {
          _soilNoMoreData = AppConstants.NO_MORE_DATA;
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  /// ================== SHOW CUSTOM ==================
  List<Cart> _selectedItem = [];
  List<Cart> get selectedItem => _selectedItem;

  void addSelectedItem(List<Cart> cart) {
    _selectedItem = cart;
    notifyListeners();
  }

  void resetSelectedItem() {
    _selectedItem = [];
    notifyListeners();
  }

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  String item_url = '';

  Future<bool> getItemUrl(BuildContext context) async {
    bool result = false;

    _isFetching = true;
    notifyListeners();

    ApiResponse apiResponse = await customizeRepo.getItemURL(_selectedItem);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        item_url = apiResponse.response!.data['data']['URL'];
      }
    }

    _isFetching = false;
    notifyListeners();

    return result;
  }

  /// ================== GET STYLE LIST ==============
  CustomStyleModel _customStyleModel = CustomStyleModel();
  CustomStyleModel get customStyleModel => _customStyleModel;
  List<Custom> _customList = [];
  List<Custom> get customList => _customList;

  Future<bool> getStyle(BuildContext context) async {
    bool result = false;

    _isFetching = true;
    notifyListeners();

    ApiResponse apiResponse = await customizeRepo.getCustomStyle();

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _customStyleModel =
            CustomStyleModel.fromJson(apiResponse.response!.data);
        _customList = _customStyleModel.data!.custom ?? [];
      }
    }

    for (int i = 0; i < _customList.length; i++) {
      print(customList[i].name);
    }

    _isFetching = false;
    notifyListeners();

    return result;
  }

  /// ================== MAKE ORDER ==================
  String _orderIdCreated = '';
  String get orderIdCreated => _orderIdCreated;
  Future<bool> addOrder(BuildContext context, String address) async {
    bool result = false;

    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse =
        await customizeRepo.addOrder(_selectedItem, address);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _orderIdCreated =
            apiResponse.response!.data['data']['order_id'].toString();
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }
}
