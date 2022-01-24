import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          return Container(
            color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _thumbnail(context, state),
                _connectionIndicator(context, state),
                _controlButtonsBar(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _connectionIndicator(BuildContext context, PlayerScreenState state) {
    return Visibility(
        visible: !state.connection,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        maintainSemantics: true,
        child: const Icon(Icons.signal_cellular_connected_no_internet_4_bar));
  }

  Widget _thumbnail(BuildContext context, PlayerScreenState state) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Align(
        child: AspectRatio(
          aspectRatio: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    _thumbnailImage(
                      image:
                          Image.asset("assets/images/radio_placeholder.jpeg"),
                    ),
                    if (state.connection) _thumbnailImage(
                      image: Image.network(
                        state.currentStationArtUrl,
                        errorBuilder: (context, child, snapshot) => Container(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.currentStationName,
                      style: const TextStyle(
                          inherit: false, color: Colors.black, fontSize: 24.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
          _controlButton(context, Icons.skip_previous, 2, enableButtons,
              _previousStationAction),
          _controlButton(
              context,
              state.isPlaying ? Icons.pause : Icons.play_arrow,
              3,
              enableButtons,
              _playPauseAction),
          _controlButton(
              context, Icons.skip_next, 2, enableButtons, _nextStationAction),
        ],
      ),
    );
  }

  Widget _controlButton(BuildContext context, IconData icon, int flex,
      bool enabled, void Function(BuildContext context) callback) {
    return Expanded(
      flex: flex,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 5.0)),
            child: TextButton(
              style: ButtonStyle(
                overlayColor:
                    MaterialStateColor.resolveWith((states) => Colors.black54),
                shape: MaterialStateProperty.all<CircleBorder>(
                    const CircleBorder()),
              ),
              onPressed: enabled ? () => callback(context) : null,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: FittedBox(
                  child: Icon(
                    icon,
                    color: Colors.black,
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
