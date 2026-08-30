import 'package:flutter/material.dart';
import '../utils/theme.dart';

class AuctionTimer extends StatelessWidget {
  final int seconds;
  final bool isUrgent;

  const AuctionTimer({
    super.key,
    required this.seconds,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isUrgent ? AppColors.error : AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isUrgent ? AppColors.error : AppColors.primary,
          width: 2,
        ),
        boxShadow: isUrgent
            ? [
                BoxShadow(
                  color: AppColors.error.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: isUrgent ? Colors.white : AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            '${seconds}s',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isUrgent ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  final int seconds;
  final VoidCallback? onEnd;

  const TimerWidget({
    super.key,
    required this.seconds,
    this.onEnd,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.seconds),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onEnd?.call();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final timeLeft = (_animation.value * widget.seconds).round();
        final isUrgent = timeLeft <= 10;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 6,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isUrgent ? AppColors.error : AppColors.primary,
                ),
              ),
            ),
            // Time text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$timeLeft',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isUrgent ? AppColors.error : AppColors.textPrimary,
                  ),
                ),
                Text(
                  'sec',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
