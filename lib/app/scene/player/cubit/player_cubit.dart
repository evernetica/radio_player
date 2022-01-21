import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_player/app/scene/player/cubit/player_state.dart';
import 'package:radio_player/domain/entities/station_info_entity.dart';
import 'package:radio_player/main.dart';

class PlayerScreenCubit extends Cubit<PlayerScreenState> {
  PlayerScreenCubit() : super(PlayerScreenState()) {
    if (state.stationInfoList.isEmpty) {
      getStationInfoList();
    }
  }

  Future<void> getStationInfoList() async {
    List<StationInfoEntity> stationInfoEntitiesList =
        await stationInfoUseCase!.getListStationInfo();

    for (StationInfoEntity entity in stationInfoEntitiesList) {
      state.stationInfoList.add(entity);
    }

    emit(PlayerScreenState(stationInfoList: stationInfoEntitiesList));
  }

  void nextStation() {
    int stationId = state.currentStationId;

    stationId >= state.stationInfoList.length - 1 ? stationId = 0 : stationId++;

    emit(PlayerScreenState(
      stationInfoList: state.stationInfoList,
      currentStationId: stationId,
    ));
  }

  void prevStation() {
    int stationId = state.currentStationId;

    stationId <= 0
        ? stationId = (state.stationInfoList.isNotEmpty
            ? state.stationInfoList.length - 1
            : 0)
        : stationId--;

    emit(PlayerScreenState(
      stationInfoList: state.stationInfoList,
      currentStationId: stationId,
    ));
  }
}
