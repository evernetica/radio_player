import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_player/app/scene/player/cubit/player_state.dart';
import 'package:radio_player/domain/entities/station_info_entity.dart';
import 'package:radio_player/main.dart';

class PlayerScreenCubit extends Cubit<PlayerScreenState> {
  StreamSubscription? subscriptionConnectionStatus;
  StreamSubscription? subscriptionAudioHandler;

  PlayerScreenCubit() : super(PlayerScreenState()) {
    // Notification buttons handler
    subscriptionAudioHandler = controller!.stream.listen((event) {
      switch (event) {
        case 1:
          prevStation();
          break;
        case 2:
          nextStation();
          break;
        default:
          playPause();
          break;
      }
    });

    // Internet connection listener
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

      _handleStationChange();
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

    _handleStationChange();
  }

  void playPause() async {
    if (!state.connection) return;

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

    _handleStationChange();
  }

  void nextStation() async {
    int stationId = state.currentStationId;

    stationId >= state.stationInfoList.length - 1 ? stationId = 0 : stationId++;

    emit(PlayerScreenState(
      stationInfoList: state.stationInfoList,
      currentStationId: stationId,
      isPlaying: state.isPlaying,
      connection: state.connection,
      animationDirection: 2,
    ));

    await audioPlayer!.setUrl(state.currentStationUrl);

    _handleStationChange();
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
      animationDirection: 1,
    ));

    await audioPlayer!.setUrl(state.currentStationUrl);

    _handleStationChange();
  }

  void _handleStationChange() {
    audioHandler!.playbackState.add(PlaybackState(
      playing: true,
      processingState: AudioProcessingState.ready,
      controls: [
        MediaControl.skipToPrevious,
        audioPlayer!.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
    ));

    audioHandler!.mediaItem.add(MediaItem(
        id: "${state.currentStationId}", title: state.currentStationName));
  }
}
