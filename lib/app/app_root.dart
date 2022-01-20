import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_player/app/router/cubit/router_cubit.dart';
import 'package:radio_player/app/router/cubit/router_state.dart';
import 'package:radio_player/app/router/router_root_delegate.dart';

class AppRoot extends StatelessWidget {
  AppRoot({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RouterCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: BlocBuilder<RouterCubit, RouterState>(
            builder: (context, state) => Router(
              routerDelegate: RouterRootDelegate(
                navigatorKey,
                context.read<RouterCubit>(),
              ),
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          ),
        ),
      ),
    );
  }
}
