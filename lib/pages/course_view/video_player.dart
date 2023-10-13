import "dart:async";
import "package:flutter/material.dart";

import "package:video_player/video_player.dart" as video_player;

enum VideoType { network, asset, file }

class VideoPlayer extends StatefulWidget {
  final String? url;
  final VideoType videoType;
  final Function? onClickPrev;
  final Function? onClickNext;
  final Function? onVisibilityChanged;

  const VideoPlayer({
    super.key,
    this.url,
    this.onClickPrev,
    this.onClickNext,
    required this.videoType,
    this.onVisibilityChanged,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayer();
}

class _VideoPlayer extends State<VideoPlayer> {
  late video_player.VideoPlayerController _controller;

  Timer? timer;
  int _timeout = 0;

  final _height = 250.0;
  final _seekDuration = const Duration(seconds: 1);

  int _currentPosition = 0;
  int get _totalDuration => _controller.value.duration.inSeconds;

  double get _percentageComplete =>
      _controller.value.position.inSeconds /
      _controller.value.duration.inSeconds;

  String get _currentTime =>
      "${_controller.value.position.inMinutes.toString().padLeft(2, "0")}"
      ":"
      "${_controller.value.position.inSeconds.remainder(60).toString().padLeft(2, "0")}";

  @override
  void initState() {
    super.initState();
    if (widget.url != null) {
      _controller =
          video_player.VideoPlayerController.networkUrl(Uri.parse(widget.url!))
            ..initialize().then((_) {
              _controller.setLooping(true);
              _controller.addListener(() {
                setState(() {
                  _currentPosition = _controller.value.position.inSeconds;
                });
              });
              setState(() {});
            });
    }
  }

  void _resetTimeout() {
    setState(() {
      _timeout = 3;
      if (timer != null) timer!.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeout > 0) {
          setState(() {
            _timeout--;
          });
        } else {
          timer.cancel();
        }
      });
    });
  }

  Widget _buildOpacity({required Widget child}) {
    return GestureDetector(
      onTap: () {
        _resetTimeout();
        widget.onVisibilityChanged!();
      },
      child: AnimatedOpacity(
        opacity: _timeout == 0 ? 0 : 0.7,
        duration: const Duration(milliseconds: 400),
        child: Container(
          color: Colors.black,
          child: child,
        ),
      ),
    );
  }

  Widget _buildViewController() {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (_timeout != 0) {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              }
              _resetTimeout();
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _controller.value.isPlaying
                      ? const Icon(
                          size: 70,
                          color: Colors.white,
                          Icons.pause_circle_outline,
                        )
                      : const Icon(
                          size: 70,
                          color: Colors.white,
                          Icons.play_circle_outline,
                        ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          height: _height,
          width: (MediaQuery.of(context).size.width / 2) - 40,
          child: GestureDetector(
            onTap: _timeout == 0
                ? null
                : () {
                    _controller.seekTo(_seekDuration);
                    // widget.onClickPrev!();
                  },
            child: const Icon(
              size: 60,
              Icons.replay_10,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          height: _height,
          width: (MediaQuery.of(context).size.width / 2) - 40,
          child: GestureDetector(
            onTap: _timeout == 0
                ? null
                : () {
                    _controller.seekTo(_seekDuration);
                    // widget.onClickNext!();
                  },
            child: const Icon(
              size: 60,
              Icons.forward_10,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {
              showBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: const Center(
                        child: Text(
                          "Video player settings",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                size: 32,
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 2,
          height: 30,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              children: [
                Text(
                  _currentTime,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: MediaQuery.of(context).size.width - 91,
                      color: Colors.grey[800],
                    ),
                    Container(
                      height: 8,
                      width: (MediaQuery.of(context).size.width - 91) *
                          _percentageComplete,
                      color: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print("Full Screen");
                    });
                  },
                  child: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayer() {
    return SizedBox(
      height: _height,
      child: Stack(
        children: [
          video_player.VideoPlayer(_controller),
          Positioned.fill(
            child: _buildOpacity(
              child: _buildViewController(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.url != null && _controller.value.isInitialized
        ? _buildPlayer()
        : Container(
            color: Colors.grey[500],
            height: 250,
          );
  }

  @override
  void didUpdateWidget(VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _controller.dispose();
      _controller =
          video_player.VideoPlayerController.networkUrl(Uri.parse(widget.url!))
            ..initialize().then((_) {
              _controller.addListener(() {
                setState(() {
                  _currentPosition = _controller.value.position.inSeconds;
                });
              });
              setState(() {});
            });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
