import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_player/app/app_root.dart';
import 'package:radio_player/data/repositories/station_info_google_sheets_repository.dart';
import 'package:radio_player/domain/use_cases/station_info_use_case.dart';

StationInfoUseCase? stationInfoUseCase;
AudioPlayer? audioPlayer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  stationInfoUseCase =
      StationInfoUseCase(repository: StationInfoGoogleSheetsRepositoryImpl());
  audioPlayer = AudioPlayer();

  runApp(AppRoot());
}
