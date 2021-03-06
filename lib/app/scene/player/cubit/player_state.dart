import 'package:equatable/equatable.dart';
import 'package:radio_player/app/scene/player/animated_wave_widget.dart';
import 'package:radio_player/domain/entities/station_info_entity.dart';

class PlayerScreenState extends Equatable {
  PlayerScreenState({
    List<StationInfoEntity>? stationInfoList,
    int? currentStationId,
    bool? isPlaying,
    bool? connection,
    AnimationDirection? animationDirection,
    bool? animateSplash,
  })  : _stationInfoList = stationInfoList ?? [],
        _currentStationId = currentStationId ?? 0,
        _isPlaying = isPlaying ?? false,
        _connection = connection ?? true,
        _animationDirection = animationDirection ?? AnimationDirection.none,
        _animateSplash = animateSplash ?? false,
        super();

  final int _currentStationId;

  final bool _isPlaying;

  final bool _connection;

  final AnimationDirection _animationDirection;

  final bool _animateSplash;

  final List<StationInfoEntity> _stationInfoList;

  List<StationInfoEntity> get stationInfoList => _stationInfoList;

  int get currentStationId => _currentStationId;

  bool get isPlaying => _isPlaying;

  bool get connection => _connection;

  bool get animateSplash => _animateSplash;

  AnimationDirection get animationDirection => _animationDirection;

  String get currentStationUrl => _stationInfoList.isNotEmpty
      ? _stationInfoList[_currentStationId].url
      : "";

  String get currentStationName => _stationInfoList.isNotEmpty
      ? _stationInfoList[_currentStationId].name
      : "No station";

  String get currentStationArtUrl => _stationInfoList.isNotEmpty
      ? _stationInfoList[_currentStationId].artUrl
      : "";

  @override
  List<Object?> get props =>
      [_stationInfoList, _currentStationId, _isPlaying, _connection];
}
