import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsforms/Screens/Companies/company_handler.dart';
import 'package:rsforms/Screens/pageview_controller.dart';

import 'auth_screen.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  /*
    Listens to AuthStream and handles the AuthState.
    If AuthState has data Continue To accountCreationHandler.
  */
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: context.watch<User?>(),
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 750),
          layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
          transitionBuilder: (child, animation) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
          child: snapshot.hasData ? const CompanyHandler() : const AuthScreen(),
        );
      },
    );
  }
}
