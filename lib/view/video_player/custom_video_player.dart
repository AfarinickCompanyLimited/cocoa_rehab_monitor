/*
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  final bool? isFile;
  final String? path;
  const CustomVideoPlayer({Key? key, this.isFile, this.path}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {

  BetterPlayerController? _betterPlayerController;

  final BetterPlayerTheme _playerTheme = BetterPlayerTheme.cupertino;

  bool? controlsVisible;

  @override
  void initState() {
    super.initState();

    BetterPlayerDataSource betterPlayerDataSource = widget.isFile!
    ? BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.path!
    )
    : BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.path!
    );

    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          // deviceOrientationsAfterFullScreen: [
          //   DeviceOrientation.portraitDown,
          //   DeviceOrientation.portraitUp
          // ],
          controlsConfiguration: BetterPlayerControlsConfiguration(
            playerTheme: _playerTheme,
              enableOverflowMenu: false
          ),
        ),
        betterPlayerDataSource: betterPlayerDataSource,
    );

    _betterPlayerController!.addEventsListener((event){
      if(event.betterPlayerEventType == BetterPlayerEventType.controlsVisible){
        controlsVisible = true;
      }
      if(event.betterPlayerEventType == BetterPlayerEventType.controlsHiddenEnd){
        controlsVisible = false;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _betterPlayerController!.setControlsVisibility(!controlsVisible!);
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: _betterPlayerController!,
            ),
          ),
        ),
      ),
    );
  }
}
*/