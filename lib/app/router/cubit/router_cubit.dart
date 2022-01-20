import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_player/app/router/cubit/router_state.dart';

class RouterCubit extends Cubit<RouterState> {
  RouterCubit() : super(const RouterStateSplashScreen()) {
    startApp();
  }

  void startApp() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    emit(const RouterStatePlayerScreen());
  }
}
