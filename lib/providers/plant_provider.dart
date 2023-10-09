import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/plant_repo.dart';
import 'package:nurserygardenapp/helper/response_helper.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlantProvider extends ChangeNotifier {
  final PlantRepo plantRepo;
  final SharedPreferences sharedPreferences;
  PlantProvider({required this.plantRepo, required this.sharedPreferences});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PlantModel _plantModel = PlantModel();
  PlantModel get plantModel => _plantModel;

  List<Plant> _plantList = [];
  List<Plant> get plantList => _plantList;

  String _noMoreDataMessage = '';
  String get noMoreDataMessage => _noMoreDataMessage;

  /// ================== PLANT LIST ==================
  Future<bool> listOfPlant(BuildContext context, params,
      {bool isLoadMore = false, bool isLoad = true}) async {
    if (!isLoadMore) {
      _plantList = [];
      _noMoreDataMessage = '';
      clearPlantListData();
    }

    bool result = false;
    String query = ResponseHelper.buildQuery(params);
    int limit = params['limit'] != null ? int.parse(params['limit']) : 8;

    _isLoading = isLoad;
    notifyListeners();

    ApiResponse apiResponse = await plantRepo.getPlantList(query);

    if (context.mounted) {
      result = ResponseHelper.responseHelper(context, apiResponse);
      if (result) {
        _plantModel = PlantModel.fromJson(apiResponse.response!.data);
        _plantList = _plantModel.data!.plantList!.plant ?? [];
        setPlantListInfo(_plantList);
        if (_plantList.length < limit && limit > 8) {
          _noMoreDataMessage = AppConstants.NO_MORE_DATA;
        }
      }
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  /// ================== PLANT SAVE IN LOCAL ==================
  Future<void> setPlantListInfo(plantInfo) async {
    try {
      await sharedPreferences.setString(
          AppConstants.PLANT_TOKEN, json.encode(plantInfo));
    } catch (e) {
      rethrow;
    }
  }

  void getPlantListInfo() {
    String plantInfo =
        sharedPreferences.getString(AppConstants.PLANT_TOKEN) ?? '';
    if (plantInfo.isNotEmpty) {
      List<dynamic> decodedData = json.decode(plantInfo);
      List<Plant> plantListInfo =
          decodedData.map((item) => Plant.fromJson(item)).toList();
      _plantList = plantListInfo;
      notifyListeners();
    } else {
      _plantList = [];
    }
  }

  Future<void> clearPlantListData() async {
    await sharedPreferences.remove(AppConstants.PLANT_TOKEN);
  }
}
