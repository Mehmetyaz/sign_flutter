import 'package:flutter/material.dart';

/// Built Notifier paints a temporary color overlay over your widget whenever it rebuilds.
class BuiltNotifier extends StatefulWidget {
  /// It reaches from specified color to
  /// transparent color in the specified time.
  const BuiltNotifier({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.color = const Color(0x66FF0000),
  });

  /// Your widget
  final Widget child;

  /// Built color
  final Color color;

  /// To transparent duration
  final Duration duration;

  @override
  State<BuiltNotifier> createState() => _BuiltNotifierState();
}

class _BuiltNotifierState extends State<BuiltNotifier>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = _controller.drive(
      ColorTween(begin: widget.color, end: Colors.transparent),
    );
  }

  @override
  void didUpdateWidget(covariant BuiltNotifier oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color || oldWidget.duration != widget.duration) {
      _animation = _controller.drive(
        ColorTween(begin: widget.color, end: Colors.transparent),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerFlash() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _triggerFlash();
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentColor = _animation.value;
        if (currentColor == null || currentColor.a == 0) {
          return child!;
        }
        return DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            color: currentColor,
            border: Border.all(
              color: currentColor.withAlpha(255),
              width: 1.5,
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
