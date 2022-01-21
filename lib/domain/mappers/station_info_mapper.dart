import 'package:radio_player/data/models/station_info_model.dart';
import 'package:radio_player/domain/entities/station_info_entity.dart';

class StationInfoMapper {
  StationInfoEntity map(StationInfoModel model) =>
      StationInfoEntity(url: model.url, name: model.name, artUrl: model.artUrl);
}