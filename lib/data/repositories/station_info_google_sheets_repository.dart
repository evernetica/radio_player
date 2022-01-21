import 'dart:convert';

import 'package:radio_player/data/models/station_info_model.dart';
import 'package:radio_player/domain/entities/station_info_entity.dart';
import 'package:radio_player/domain/mappers/station_info_mapper.dart';
import 'package:radio_player/domain/repositories_interfaces/i_station_info_repository.dart';
import 'package:http/http.dart' as http;

class StationInfoGoogleSheetsRepositoryImpl implements IStationInfoRepository {
  final Uri getScriptUrl = Uri.https("script.google.com",
      "macros/s/AKfycbzB0nZAPVqhaYNhzkMokKzMYggNnVGkV06OyOfKjQqGwQ51mruRNOrZcAiHUlpgvxSLow/exec");

  @override
  Future<List<StationInfoEntity>> getListStationInfo() async {
    List<StationInfoEntity> stationInfoEntitiesList = [];

    await http.get(getScriptUrl).then((response) {
      dynamic jsonFeedback = jsonDecode(response.body) as List;

      for (Map<String, dynamic> item in jsonFeedback) {
        stationInfoEntitiesList.add(StationInfoMapper().map(StationInfoModel(
            url: item["url"], name: item["name"], artUrl: item["artUrl"])));
      }
    });

    return stationInfoEntitiesList;
  }
}
