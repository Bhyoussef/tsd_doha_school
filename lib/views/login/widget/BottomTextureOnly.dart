import 'package:flutter/material.dart';

class BottomTextureOnly extends StatelessWidget {
  const BottomTextureOnly({
    Key? key,
     this.child,
  }) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Image.asset('assets/imgs/splashBackgroundTextureBottom.png'),
        ),
        child!,
      ],
    );
  }
}
