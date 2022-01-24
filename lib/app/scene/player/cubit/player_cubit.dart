import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_player/app/scene/player/cubit/player_state.dart';
import 'package:radio_player/domain/entities/station_info_entity.dart';
import 'package:radio_player/main.dart';

class PlayerScreenCubit extends Cubit<PlayerScreenState> {
  StreamSubscription? subscriptionConnectionStatus;

  PlayerScreenCubit() : super(PlayerScreenState()) {
    subscriptionConnectionStatus = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      bool connected = result.index != 2;

      if (!connected) {
        await Future.delayed(const Duration(seconds: 10)).then((value) async {
          connected = (await Connectivity().checkConnectivity()).index != 2;
          if (!connected) {
            audioPlayer!.stop();
          }
        });
      } else {
        if (state.stationInfoList.isEmpty) {
          getStationInfoList();
        }
      }

      emit(PlayerScreenState(
        stationInfoList: state.stationInfoList,
        currentStationId: state.currentStationId,
        isPlaying: audioPlayer!.playing,
        connection: connected,
      ));
    });
  }

  Future<void> getStationInfoList() async {
    List<StationInfoEntity> stationInfoEntitiesList =
        await stationInfoUseCase!.getListStationInfo();

    for (StationInfoEntity entity in stationInfoEntitiesList) {
      state.stationInfoList.add(entity);
    }

    emit(PlayerScreenState(
      stationInfoList: stationInfoEntitiesList,
      connection: true,
    ));

    await audioPlayer!.setUrl(state.currentStationUrl);
    audioPlayer!.play();
    emit(PlayerScreenState(
      stationInfoList: stationInfoEntitiesList,
      currentStationId: state.currentStationId,
      isPlaying: audioPlayer!.playing,
      connection: state.connection,
    ));
  }

  void playPause() async {
    if (audioPlayer!.playing) {
      await audioPlayer!.stop();
    } else {
      audioPlayer!.play();
    }

    emit(PlayerScreenState(
      stationInfoList: state.stationInfoList,
      currentStationId: state.currentStationId,
      isPlaying: audioPlayer!.playing,
      connection: state.connection,
    ));
  }

  void nextStation() async {
    int stationId = state.currentStationId;

    stationId >= state.stationInfoList.length - 1 ? stationId = 0 : stationId++;

    emit(PlayerScreenState(
      stationInfoList: state.stationInfoList,
      currentStationId: stationId,
      isPlaying: state.isPlaying,
      connection: state.connection,
    ));

    await audioPlayer!.setUrl(state.currentStationUrl);
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
      connection: state.connection,
    ));

    await audioPlayer!.setUrl(state.currentStationUrl);
  }
}
