import 'package:radio_player/domain/entities/station_info_entity.dart';

abstract class IStationInfoRepository {
  Future<List<StationInfoEntity>> getListStationInfo();
}