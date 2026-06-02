import 'dart:async';
import 'package:flutter/material.dart';

class FastAdjustButton extends StatefulWidget {
  final IconData icon;
  final void Function(int step) onStep;
  final int Function(int repeatCount)? holdStep;

  const FastAdjustButton({
    super.key,
    required this.icon,
    required this.onStep,
    this.holdStep,
  });

  @override
  State<FastAdjustButton> createState() => _FastAdjustButtonState();
}

class _FastAdjustButtonState extends State<FastAdjustButton> {
  Timer? _timer;
  int _repeatCount = 0;
  bool _didRepeat = false;
  bool _pressed = false;

  static const double _size = 64;
  static const double _circleSize = 46;

  void _tick() {
    if (!mounted) return;
    _didRepeat = true;
    if (widget.holdStep != null) {
      widget.onStep(widget.holdStep!(_repeatCount));
    } else {
      widget.onStep(1);
    }
    _repeatCount++;
    final delayMs = _repeatCount < 5 ? 250 : (_repeatCount < 15 ? 120 : 60);
    _timer = Timer(Duration(milliseconds: delayMs), _tick);
  }

  void _startHold() {
    setState(() => _pressed = true);
    _repeatCount = 0;
    _didRepeat = false;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), _tick);
  }

  void _stopHold() {
    _timer?.cancel();
    if (!_didRepeat) {
      widget.onStep(1);
    }
    _repeatCount = 0;
    _didRepeat = false;
    if (_pressed) {
      setState(() => _pressed = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _startHold(),
      onPointerUp: (_) => _stopHold(),
      onPointerCancel: (_) => _stopHold(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: _size,
        height: _size,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black87, width: 2),
          boxShadow: _pressed
              ? const []
              : const [
                  BoxShadow(
                    color: Color(0x66000000),
                    offset: Offset(0, 3),
                    blurRadius: 2,
                  ),
                ],
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            width: _circleSize,
            height: _circleSize,
            transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
            decoration: BoxDecoration(
              color: _pressed
                  ? const Color(0xFF1A1A1A)
                  : const Color.fromARGB(255, 172, 13, 13),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 126, 38, 38),
                width: 2,
              ),
              boxShadow: _pressed
                  ? const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 2,
                        spreadRadius: -1,
                      ),
                    ]
                  : const [
                      BoxShadow(
                        color: Color(0x80000000),
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
            ),
            child: Icon(widget.icon, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }
}

class SimpleAdjustButton extends StatefulWidget {
  final IconData icon;
  final void Function(int step) onStep;
  final int Function(int repeatCount)? holdStep;

  const SimpleAdjustButton({
    super.key,
    required this.icon,
    required this.onStep,
    this.holdStep,
  });

  @override
  State<SimpleAdjustButton> createState() => _SimpleAdjustButtonState();
}

class _SimpleAdjustButtonState extends State<SimpleAdjustButton> {
  Timer? _timer;
  int _repeatCount = 0;
  bool _didRepeat = false;
  bool _pressed = false;

  static const double _size = 45;
  static const double _iconSize = 35;

  void _tick() {
    if (!mounted) return;
    _didRepeat = true;
    if (widget.holdStep != null) {
      widget.onStep(widget.holdStep!(_repeatCount));
    } else {
      widget.onStep(1);
    }
    _repeatCount++;
    final delayMs = _repeatCount < 5 ? 250 : (_repeatCount < 15 ? 120 : 60);
    _timer = Timer(Duration(milliseconds: delayMs), _tick);
  }

  void _startHold() {
    setState(() => _pressed = true);
    _repeatCount = 0;
    _didRepeat = false;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), _tick);
  }

  void _stopHold() {
    _timer?.cancel();
    if (!_didRepeat) {
      widget.onStep(1);
    }
    _repeatCount = 0;
    _didRepeat = false;
    if (_pressed) {
      setState(() => _pressed = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _startHold(),
      onPointerUp: (_) => _stopHold(),
      onPointerCancel: (_) => _stopHold(),
      child: Container(
        width: _size,
        height: _size,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: _pressed
              ? const Color(0xFF1A1A1A)
              : const Color.fromARGB(255, 122, 121, 121),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black87, width: 1),
        ),
        child: Icon(widget.icon, color: Colors.white, size: _iconSize),
      ),
    );
  }
}
