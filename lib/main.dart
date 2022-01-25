import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_player/app/app_root.dart';
import 'package:radio_player/data/repositories/station_info_google_sheets_repository.dart';
import 'package:radio_player/domain/use_cases/station_info_use_case.dart';

StationInfoUseCase? stationInfoUseCase;
StreamController<int>? controller;
AudioPlayer? audioPlayer;
BaseAudioHandler? audioHandler;
AudioSession? session;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  session = await AudioSession.instance;
  await session!.configure(const AudioSessionConfiguration.music());

  stationInfoUseCase =
      StationInfoUseCase(repository: StationInfoGoogleSheetsRepositoryImpl());

  audioPlayer = AudioPlayer();

  controller = StreamController<int>();

  startForegroundService();

  runApp(AppRoot());
}

void startForegroundService() async {
  await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 5);
  await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  await FlutterForegroundPlugin.startForegroundService(
    holdWakeLock: false,
    onStarted: () async {
      audioHandler = await AudioService.init(
        builder: () => MyAudioHandler(controller),
        config: const AudioServiceConfig(
          androidStopForegroundOnPause: false,
          androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
          androidNotificationChannelName: 'Music playback',
        ),
      );
    },
    onStopped: () {},
    title: "Flutter Foreground Service",
    content: "This is Content",
    iconName: "ic_launcher",
  );
}

void globalForegroundService() async {
  debugPrint("====================================== current datetime is ${DateTime.now()} \n\taudio state is: ${audioPlayer!.processingState.name} \n\taudio handler state is: ${audioHandler!.playbackState.stream.value} \n\t connection: ${(await Connectivity().checkConnectivity()).name}");
}

class MyAudioHandler extends BaseAudioHandler {
  MyAudioHandler(StreamController<int>? controller) : super();

  @override
  Future<void> play() {
    controller?.add(0);
    return super.play();
  }

  @override
  Future<void> pause() {
    controller?.add(0);
    return super.pause();
  }

  @override
  Future<void> skipToPrevious() {
    controller?.add(1);
    return super.skipToPrevious();
  }

  @override
  Future<void> skipToNext() {
    controller?.add(2);
    return super.skipToNext();
  }
}
