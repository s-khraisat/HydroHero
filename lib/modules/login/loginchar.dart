import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'login_animation_controller.dart' as controller;

class LoginAnimation extends StatefulWidget {
  const LoginAnimation({super.key});

  @override
  State<LoginAnimation> createState() => _LoginAnimationState();
}

class _LoginAnimationState extends State<LoginAnimation> {
  void _onInit(Artboard artboard) {
    controller.riveController = StateMachineController.fromArtboard(
      artboard,
      'Login Machine', 
    );

    if (controller.riveController == null) return;

    artboard.addController(controller.riveController!);

    controller.isTyping = controller.riveController!.findInput<bool>('isChecking');
    controller.isHandsUp = controller.riveController!.findInput<bool>('isHandsUp');
    controller.success = controller.riveController!.findInput<bool>('trigSuccess');
    controller.fail = controller.riveController!.findInput<bool>('trigFail');

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: RiveAnimation.asset(
        'assets/rive/login_animation.riv',
        onInit: _onInit,
        fit: BoxFit.contain,
      ),
    );
  }
}
