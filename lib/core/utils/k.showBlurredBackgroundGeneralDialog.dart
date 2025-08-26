import 'package:flutter/material.dart';
import 'dart:ui';

typedef DialogBuilder = Widget Function(BuildContext context);

Future<T?> showBlurredBackGroundGeneralDialog<T>({
  required BuildContext context,
  required DialogBuilder builder,
  String barrierLabel = 'Dialog',
  Color barrierColor = const Color(0x66000000),
  double blurSigma = 4,
  Duration transitionDuration = const Duration(milliseconds: 400),
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    pageBuilder: (context, anim1, anim2) {
      // Layer 1: BackdropFilter + ModalBarrier for blur
      return SafeArea(
        child: Stack(
          children: [
            // Blurred background under the dialog
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: const SizedBox.expand(),
            ),
            // Dismiss handler & dialog
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (barrierDismissible) Navigator.of(context).pop();
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: () {}, // Prevent tap-through on dialog content
                  child: builder(context),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final animation = CurvedAnimation(parent: anim1, curve: Curves.easeInOut);
      return RepaintBoundary(
        child: FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
      );
    },
  );
}
