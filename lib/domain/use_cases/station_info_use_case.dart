import 'package:radio_player/domain/entities/station_info_entity.dart';
import 'package:radio_player/domain/repositories_interfaces/i_station_info_repository.dart';

class StationInfoUseCase {
  StationInfoUseCase({required this.repository});

  final IStationInfoRepository repository;

  Future<List<StationInfoEntity>> getListStationInfo() async {
    return repository.getListStationInfo();
  }
}
