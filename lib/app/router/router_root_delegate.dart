import 'package:flutter/material.dart';
import 'package:radio_player/app/router/cubit/router_cubit.dart';
import 'package:radio_player/app/router/cubit/router_state.dart';
import 'package:radio_player/app/scene/player/screen_player.dart';
import 'package:radio_player/app/scene/splash/screen_splash.dart';

class RouterRootDelegate extends RouterDelegate<RouterState> {
  final GlobalKey<NavigatorState> _navigatorKey;
  final RouterCubit _routerCubit;

  RouterRootDelegate(
      GlobalKey<NavigatorState> navigatorKey, RouterCubit routerCubit)
      : _navigatorKey = navigatorKey,
        _routerCubit = routerCubit;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        pages: _extraPages,
        onPopPage: _onPopPageParser,
      );

  List<Page> get _extraPages {
    List<Page> pages = [];

    if (_routerCubit.state is RouterStateSplashScreen) {
      pages.add(const MaterialPage(child:  ScreenSplash()));
    }
    if (_routerCubit.state is RouterStatePlayerScreen) {
      pages.add(const MaterialPage(child:  ScreenPlayer()));
    }

    return pages;
  }

  bool _onPopPageParser(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  @override
  Future<bool> popRoute() async {
    return true;
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  Future<void> setNewRoutePath(RouterState configuration) async {}
}
