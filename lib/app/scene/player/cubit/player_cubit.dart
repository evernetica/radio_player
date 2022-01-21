import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    while (true) {
      try {
        List<StationInfoEntity> stationInfoEntitiesList =
            await stationInfoUseCase!.getListStationInfo();

        for (StationInfoEntity entity in stationInfoEntitiesList) {
          state.stationInfoList.add(entity);
        }

        emit(PlayerScreenState(stationInfoList: stationInfoEntitiesList));

        await audioPlayer!.setUrl(state.currentStationUrl, preload: false);
        audioPlayer!.play();
        emit(PlayerScreenState(
          stationInfoList: stationInfoEntitiesList,
          currentStationId: state.currentStationId,
          isPlaying: audioPlayer!.playing,
        ));

        break;
      } catch (ex) {
        Fluttertoast.showToast(
          msg: "Network error. Please check your internet connection",
        );
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  void playPause() async {
    if (audioPlayer!.playing) {
      await audioPlayer!.stop();
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          audioPlayer!.play();
        }
      } on SocketException catch (_) {
        Fluttertoast.showToast(
          msg: "Network error. Please check your internet connection",
        );
      }
    }

    emit(PlayerScreenState(
      stationInfoList: state.stationInfoList,
      currentStationId: state.currentStationId,
      isPlaying: audioPlayer!.playing,
    ));
  }

  void nextStation() async {
    int stationId = state.currentStationId;

    stationId >= state.stationInfoList.length - 1 ? stationId = 0 : stationId++;

    emit(PlayerScreenState(
      stationInfoList: state.stationInfoList,
      currentStationId: stationId,
      isPlaying: state.isPlaying,
    ));

    await audioPlayer!.setUrl(state.currentStationUrl, preload: false);
  }

  void prevStation() async {
    int stationId = state.currentStationId;

    stationId <= 0
        ? stationId = (state.stationInfoList.isNotEmpty
            ? state.stationInfoList.length - 1
            : 0)
        : stationId--;

    emit(PlayerScreenState(
      stationInfoList: state.stationInfoList,
      currentStationId: stationId,
      isPlaying: state.isPlaying,
    ));

    await audioPlayer!.setUrl(state.currentStationUrl, preload: false);
  }
}
