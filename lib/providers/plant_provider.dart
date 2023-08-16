import 'package:flutter/widgets.dart';
import 'package:nurserygardenapp/data/model/plant_model.dart';
import 'package:nurserygardenapp/data/model/response/api_response.dart';
import 'package:nurserygardenapp/data/repositories/plant_repo.dart';

class PlantProvider extends ChangeNotifier {
  final PlantRepo plantRepo;
  PlantProvider({required this.plantRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PlantModel _plantModel = PlantModel();
  PlantModel get plantModel => _plantModel;

  List<Plant> _plantList = [];
  List<Plant> get plantList => _plantList;

  Future<bool> getPlantList() async {
    _isLoading = true;
    ApiResponse apiResponse = await plantRepo.getPlantList();
    _plantModel = PlantModel.fromJson(apiResponse.response!.data);
    // print(apiResponse.response!.data);
    notifyListeners();

    if (_plantModel.success!) {
      _plantList = _plantModel.data!.plant!;
    }

    _isLoading = false;
    notifyListeners();
    return _plantModel.success!;
  }
}
