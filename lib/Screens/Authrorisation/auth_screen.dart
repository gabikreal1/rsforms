import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rsforms/Screens/Authrorisation/login_form.dart';
import 'package:rsforms/Screens/Authrorisation/register_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _displayFront = true;
  bool _transitionstate = false;

  void navigateToTermsAndConditions() async {
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const TermsAndConditions()),
    // );
  }

  void navigateToPrivacyPolicy() async {
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
    // );
  }

  Future<void> flipAuthForm() async {
    if (_transitionstate) {
      return;
    }
    _transitionstate = true;
    setState(() {
      _displayFront = !_displayFront;
    });
    await Future.delayed(const Duration(seconds: 1));
    _transitionstate = false;
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    var secondaryColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Less Paperworking',
                  textStyle: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                  speed: const Duration(milliseconds: 75),
                ),
                TypewriterAnimatedText(
                  'More Locksmithing',
                  textStyle: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                  speed: const Duration(milliseconds: 75),
                ),
                TypewriterAnimatedText(
                  'Welcome to RS Forms.',
                  textStyle: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                  speed: const Duration(milliseconds: 75),
                ),
              ],
              totalRepeatCount: 2,
              isRepeatingAnimation: true,
              stopPauseOnTap: true,
              onFinished: () {},
            ),
            const SizedBox(
              height: 90,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 420,
                  width: 350,
                  child: form(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "By signing in, you agree to our ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                        text: "Terms & Conditions",
                        style: const TextStyle(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap = () => navigateToTermsAndConditions()),
                    const TextSpan(text: "\nLearn how we process your data in our \n"),
                    TextSpan(
                        text: "Privacy Policy",
                        style: const TextStyle(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap = () => navigateToPrivacyPolicy()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //A switcher which controlls switch between sign in and sign up cards.
  Widget form() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
      switchInCurve: Curves.ease,
      transitionBuilder: _transition,
      switchOutCurve: Curves.ease.flipped,
      child: _displayFront
          ? LoginForm(
              flip: flipAuthForm,
            )
          : RegisterForm(
              flip: flipAuthForm,
            ),
    );
  }

  //Card Flipping Animation
  Widget _transition(Widget widget, Animation<double> animation) {
    //It Works
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_displayFront) != widget!.key);

        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;

        tilt *= isUnder ? -1.0 : 1.0;

        final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 0, tilt)
            ..rotateY(value),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}
