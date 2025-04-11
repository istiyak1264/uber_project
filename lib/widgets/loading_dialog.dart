import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class LoadingDialog extends StatefulWidget {
  String messageText;
  LoadingDialog({
    super.key,
    required this.messageText,
  });

  @override
  LoadingDialogState createState() => LoadingDialogState();
}

// Make the state class public
class LoadingDialogState extends State<LoadingDialog> {
  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();
  }

  void _onAnimationComplete() {
    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Full screen white background
      body: Center(
        child: _isAnimating
            ? Container(
                color: Colors.white, // Set white background for animation
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/bike_loader.json',
                    width: 150,
                    height: 150,
                    repeat: false, // Make sure the animation does not loop
                    onLoaded: (composition) {
                      // Listen to the animation's duration and completion
                      Future.delayed(
                          composition.duration, _onAnimationComplete);
                    },
                  ),
                ),
              )
            : Container(
                color: Colors.white, // Blank white screen after animation
              ),
      ),
    );
  }
}
