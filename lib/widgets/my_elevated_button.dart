import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {

  final Widget child;
  final Color color;
  final VoidCallback onPressed;

  const MyElevatedButton({super.key, required this.color, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          onSurface: color.withOpacity(0.8),
          primary: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
