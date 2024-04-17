import 'package:flutter/material.dart';

class ReusableButton extends StatefulWidget {
  final String msg;
  final Color bgColors;
  final VoidCallback? callback;
  final Color textColors;

  const ReusableButton({
    super.key,
    required this.bgColors,
    required this.msg,
    this.callback,
    required this.textColors,
  });

  @override
  State<ReusableButton> createState() => _ReusableButtonState();
}

class _ReusableButtonState extends State<ReusableButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Animation controller setup
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Customize duration to suit your needs
    );
    // Define the opacity animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // Always dispose of the controller to avoid memory leaks
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: InkWell(
        onTap: () {
          // You can perform additional actions here before calling the callback
          if (widget.callback != null) {
            widget.callback!();
          }
        },
        child: Container(
            height: 50,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.bgColors
            ),
            child: const Icon(Icons.close)
        ),
      ),
    );
  }
}
