import 'package:flutter/widgets.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/plant_repo.dart';
import 'package:nurserygardenapp/helper/api_checker.dart';
import 'package:nurserygardenapp/util/app_constants.dart';
import 'package:nurserygardenapp/view/base/custom_snackbar.dart';

class PlantProvider extends ChangeNotifier {
  final PlantRepo plantRepo;
  PlantProvider({required this.plantRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PlantModel _plantModel = PlantModel();
  PlantModel get plantModel => _plantModel;

  List<Plant> _plantList = [];
  List<Plant> get plantList => _plantList;

  Future<bool> getPlantList(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await plantRepo.getPlantList();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data['success']) {
        _plantModel = PlantModel.fromJson(apiResponse.response!.data);
        _plantList = _plantModel.data!.plant!;
      } else {
        showCustomSnackBar(apiResponse.response!.data!['error'], context);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }
}
