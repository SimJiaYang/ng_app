import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/data/model/product_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/customize_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
