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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _thumbnail(context, state),
              _controlButtonsBar(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _thumbnail(BuildContext context, PlayerScreenState state) {
    return AspectRatio(
      aspectRatio: 1,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Align(
          child: AspectRatio(
            aspectRatio: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 4,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: state.currentStationArtUrl == "no_image"
                          ? Image.asset("assets/images/radio_placeholder.jpeg")
                          : Image.network(
                              state.currentStationArtUrl,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Image.asset(
                                    "assets/images/radio_placeholder.jpeg");
                              },
                            ),
                    ),
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
                            inherit: false,
                            color: Colors.black,
                            fontSize: 24.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlButtonsBar(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _controlsButton(
              context, Icons.skip_previous, 1, _previousStationAction),
          _controlsButton(context, Icons.play_arrow, 2, _playPauseAction),
          _controlsButton(context, Icons.skip_next, 1, _nextStationAction),
        ],
      ),
    );
  }

  Widget _controlsButton(BuildContext context, IconData icon, int flex,
      void Function(BuildContext context) callback) {
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
              onPressed: () => callback(context),
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

  void _playPauseAction(BuildContext context) {}

  void _nextStationAction(BuildContext context) {
    BlocProvider.of<PlayerScreenCubit>(context).nextStation();
  }

  void _previousStationAction(BuildContext context) {
    BlocProvider.of<PlayerScreenCubit>(context).prevStation();
  }
}
