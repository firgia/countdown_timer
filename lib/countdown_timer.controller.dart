part of countdown_timer;

/// Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
class CountdownTimerController {
  CountDownTimerState? _state;
  bool? _isReverse;
  bool isStarted = false,
      isPaused = false,
      isResumed = false,
      isRestarted = false;
  int? _initialDuration, _duration;

  /// This Method Starts the Countdown Timer
  void start() {
    if (_isReverse != null && _state != null && _state?._controller != null) {
      if (_isReverse!) {
        _state?._controller.reverse(
            from: _initialDuration == 0
                ? 1
                : 1 - (_initialDuration! / _duration!));
      } else {
        _state?._controller.forward(
            from: _initialDuration == 0 ? 0 : (_initialDuration! / _duration!));
      }
      isStarted = true;
      isPaused = false;
      isResumed = false;
      isRestarted = false;
    }
  }

  /// This Method Pauses the Countdown Timer
  void pause() {
    if (_state != null && _state?._controller != null) {
      _state?._controller.stop(canceled: false);
      isPaused = true;
      isRestarted = false;
      isResumed = false;
    }
  }

  /// This Method Resumes the Countdown Timer
  void resume() {
    if (_isReverse != null && _state != null && _state?._controller != null) {
      if (_isReverse!) {
        _state?._controller.reverse(from: _state!._controller.value);
      } else {
        _state?._controller.forward(from: _state!._controller.value);
      }
      isResumed = true;
      isRestarted = false;
      isPaused = false;
    }
  }

  /// This Method Restarts the Countdown Timer,
  /// Here optional int parameter **duration** is the updated duration for countdown timer

  void restart({int? duration}) {
    if (_isReverse != null && _state != null && _state?._controller != null) {
      _state?._controller.duration = Duration(
          seconds: duration ?? _state!._controller.duration!.inSeconds);
      if (_isReverse!) {
        _state?._controller.reverse(from: 1);
      } else {
        _state?._controller.forward(from: 0);
      }
      isStarted = true;
      isRestarted = true;
      isPaused = false;
      isResumed = false;
    }
  }

  /// This Method resets the Countdown Timer
  void reset() {
    if (_state != null && _state?._controller != null) {
      _state?._controller.reset();
      isStarted = _state?.widget.autoStart ?? false;
      isRestarted = false;
      isPaused = false;
      isResumed = false;
    }
  }
}
