import 'package:flutter/material.dart';
import 'package:radio_player/app/app_root.dart';
import 'package:radio_player/data/repositories/station_info_google_sheets_repository.dart';
import 'package:radio_player/domain/use_cases/station_info_use_case.dart';

StationInfoUseCase? stationInfoUseCase;

void main() {
  stationInfoUseCase = StationInfoUseCase(repository: StationInfoGoogleSheetsRepositoryImpl());

  runApp(AppRoot());
}