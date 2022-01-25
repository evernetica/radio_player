import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_player/app/router/cubit/router_state.dart';

class RouterCubit extends Cubit<RouterState> {
  RouterCubit() : super(const RouterStatePlayerScreen());
}
