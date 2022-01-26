import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_player/app/scene/app_sizes.dart';
import 'package:radio_player/app/scene/app_strings.dart';
import 'package:radio_player/app/scene/player/animated_splash_widget.dart';
import 'package:radio_player/app/scene/player/animated_wave_widget.dart';
import 'package:radio_player/app/scene/player/cubit/player_cubit.dart';
import 'package:radio_player/app/scene/player/cubit/player_state.dart';

class ScreenPlayer extends StatelessWidget {
  const ScreenPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayerScreenCubit(),
      child: BlocBuilder<PlayerScreenCubit, PlayerScreenState>(
        builder: (context, state) {
          AnimatedWave? animatedWave;

          if (state.animationDirection != AnimationDirection.none) {
            animatedWave = AnimatedWave(context, state.animationDirection);
          }

          return Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (animatedWave != null) animatedWave,
                _userInterface(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _userInterface(BuildContext context, PlayerScreenState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _thumbnail(context, state),
        Expanded(
          child: IntrinsicHeight(
            child: _bottomPanel(context, state),
          ),
        ),
      ],
    );
  }

  Widget _bottomPanel(BuildContext context, PlayerScreenState state) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
            alignment: Alignment.topCenter,
            child: _connectionIndicator(context, state)),
        _controlButtonsBar(context, state),
      ],
    );
  }

  Widget _connectionIndicator(BuildContext context, PlayerScreenState state) {
    return Visibility(
        visible: !state.connection,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        maintainSemantics: true,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(
            Icons.signal_cellular_connected_no_internet_4_bar,
            color: Colors.white,
          ),
        ));
  }

  Widget _thumbnail(BuildContext context, PlayerScreenState state) {
    AnimatedSplash? animatedSplash;

    if (state.animateSplash) {
      animatedSplash = AnimatedSplash(context, state.isPlaying);
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white, width: 1),
        ),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (animatedSplash != null) animatedSplash,
                FractionallySizedBox(
                  widthFactor: AppSizes.widthFractionThumbnailSizePlayerScreen,
                  child: Stack(
                    children: [
                      _thumbnailImage(
                        image: Image.asset(
                            AppStrings.pathPlaceholderImagePlayerScreen),
                      ),
                      if (state.connection)
                        _thumbnailImage(
                          image: Image.network(
                            state.currentStationArtUrl,
                            errorBuilder: (context, child, snapshot) =>
                                Container(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.currentStationName,
                style: const TextStyle(
                    inherit: false, color: Colors.white, fontSize: 24.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbnailImage({required Image image}) {
    return AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: image,
      ),
    );
  }

  Widget _controlButtonsBar(BuildContext context, PlayerScreenState state) {
    bool enableButtons = state.currentStationUrl != "" && state.connection;

    return FractionallySizedBox(
      widthFactor: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _controlButton(
              context: context,
              isMain: false,
              icon: Icons.skip_previous,
              flex: 2,
              enabled: enableButtons,
              callback: _previousStationAction),
          _controlButton(
              context: context,
              isMain: true,
              icon: state.isPlaying ? Icons.pause : Icons.play_arrow,
              flex: 3,
              enabled: enableButtons,
              callback: _playPauseAction),
          _controlButton(
              context: context,
              isMain: false,
              icon: Icons.skip_next,
              flex: 2,
              enabled: enableButtons,
              callback: _nextStationAction),
        ],
      ),
    );
  }

  Widget _controlButton(
      {required BuildContext context,
      required bool isMain,
      required IconData icon,
      required int flex,
      required bool enabled,
      required void Function(BuildContext context) callback}) {
    return Expanded(
      flex: flex,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    isMain ? Border.all(color: Colors.red, width: 1.0) : null),
            child: TextButton(
              style: ButtonStyle(
                overlayColor:
                    MaterialStateColor.resolveWith((states) => Colors.white60),
                shape: MaterialStateProperty.all<CircleBorder>(
                    const CircleBorder()),
              ),
              onPressed: enabled ? () => callback(context) : null,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: FittedBox(
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _playPauseAction(BuildContext context) {
    BlocProvider.of<PlayerScreenCubit>(context).playPause();
  }

  void _nextStationAction(BuildContext context) {
    BlocProvider.of<PlayerScreenCubit>(context).nextStation();
  }

  void _previousStationAction(BuildContext context) {
    BlocProvider.of<PlayerScreenCubit>(context).prevStation();
  }
}
