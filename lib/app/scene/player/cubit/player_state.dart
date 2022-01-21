import 'package:equatable/equatable.dart';
import 'package:radio_player/domain/entities/station_info_entity.dart';

class PlayerScreenState extends Equatable {
  PlayerScreenState(
      {List<StationInfoEntity>? stationInfoList,
      int? currentStationId,
      bool? isPlaying})
      : _stationInfoList = stationInfoList ?? [],
        _currentStationId = currentStationId ?? 0,
        _isPlaying = isPlaying ?? false,
        super();

  final int _currentStationId;

  final bool _isPlaying;

  final List<StationInfoEntity> _stationInfoList;

  List<StationInfoEntity> get stationInfoList => _stationInfoList;

  int get currentStationId => _currentStationId;

  bool get isPlaying => _isPlaying;

  String get currentStationUrl => _stationInfoList.isNotEmpty
      ? _stationInfoList[_currentStationId].url
      : "";

  String get currentStationName => _stationInfoList.isNotEmpty
      ? _stationInfoList[_currentStationId].name
      : "No station";

  String get currentStationArtUrl => _stationInfoList.isNotEmpty
      ? _stationInfoList[_currentStationId].artUrl
      : "no_image";

  @override
  List<Object?> get props => [_stationInfoList, _currentStationId, _isPlaying];
}
