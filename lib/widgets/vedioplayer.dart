import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({super.key, required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_controller),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                reverseDuration: const Duration(milliseconds: 200),
                child: _isPlaying
                    ? const SizedBox.shrink()
                    : Container(
                  color: Colors.black26,
                  child: Center(
                    child: IconButton(
                      iconSize: 80,
                      color: Colors.white,
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        setState(() {
                          _isPlaying = true;
                          _controller.play();
                        });
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 30,
                  color: Colors.black26,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 20,
                        color: Colors.white,
                        icon: Icon(_controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                            if (_isPlaying) {
                              _controller.play();
                            } else {
                              _controller.pause();
                            }
                          });
                        },
                      ),
                      Text(
                        "${_controller.value.position.inSeconds}/${_controller.value.duration.inSeconds}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

