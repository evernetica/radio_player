import 'dart:async';

import 'package:android_power_manager/android_power_manager.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
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

  await AndroidPowerManager.requestIgnoreBatteryOptimizations();

  session = await AudioSession.instance;
  await session!.configure(const AudioSessionConfiguration.music());

  stationInfoUseCase =
      StationInfoUseCase(repository: StationInfoGoogleSheetsRepositoryImpl());

  audioPlayer = AudioPlayer();

  controller = StreamController<int>();

  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(controller),
    config: const AudioServiceConfig(
      androidStopForegroundOnPause: false,
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );

  runApp(AppRoot());
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
