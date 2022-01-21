import 'package:equatable/equatable.dart';
import 'package:radio_player/domain/entities/station_info_entity.dart';

class PlayerScreenState extends Equatable {
  PlayerScreenState({List<StationInfoEntity>? stationInfoList}) : _stationInfoList = stationInfoList ?? [], super();

  final List<StationInfoEntity> _stationInfoList;

  List<StationInfoEntity> get stationInfoList => _stationInfoList;

  @override
  List<Object?> get props => [_stationInfoList];
}
