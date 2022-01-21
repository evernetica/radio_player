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
        BlocProvider.of<PlayerScreenCubit>(context).getStationInfoList();

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
                  child: Container(
                    color: Colors.black,
                    child: const FittedBox(
                      child: Icon(
                        Icons.image,
                        color: Colors.blue,
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
                        "google sheets loaded: ${state.stationInfoList.isNotEmpty}",
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

  Widget _controlsButton(
      BuildContext context, IconData icon, int flex, void Function() callback) {
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
              onPressed: callback,
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

  void _playPauseAction() {}

  void _nextStationAction() {}

  void _previousStationAction() {}
}
