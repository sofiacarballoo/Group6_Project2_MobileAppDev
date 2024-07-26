import 'package:flutter/material.dart';

class PawsAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallPaw;

  const PawsAnimation ({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallPaw = false,
  }) : super(key: key);

  @override
  _PawsAnimationState createState() => _PawsAnimationState();
}

class _PawsAnimationState extends State<PawsAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration.inMilliseconds,
      ),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);

    // Start animation if initially animating
    if (widget.isAnimating || widget.smallPaw) {
      startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant PawsAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating && !controller.isAnimating) {
      startAnimation();
    }
  }

  Future<void> startAnimation() async {
    if (widget.isAnimating || widget.smallPaw) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
