import 'package:flutter/animation.dart';

class StoryPlaybackController {
  StoryPlaybackController({
    required TickerProvider vsync,
    required Duration duration,
    required VoidCallback onCompleted,
  })  : _onCompleted = onCompleted,
        _controller = AnimationController(vsync: vsync, duration: duration) {
    _controller.addStatusListener(_handleStatus);
  }

  final AnimationController _controller;
  final VoidCallback _onCompleted;

  Animation<double> get animation => _controller;

  void start() {
    _controller.forward(from: 0);
  }

  void pause() {
    _controller.stop();
  }

  void resume() {
    if (!_controller.isAnimating) {
      _controller.forward();
    }
  }

  void reset() {
    _controller.reset();
  }

  void dispose() {
    _controller
      ..removeStatusListener(_handleStatus)
      ..dispose();
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onCompleted();
    }
  }
}
