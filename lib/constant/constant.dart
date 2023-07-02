import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tsdoha/model/auth_model.dart';

class Res {
  static bool isPhone = Device.get().isPhone;
  static const host = 'https://tsdoha.com';
  static Authentificate? USER;
}
class CircularProgressBar extends StatelessWidget {
  final Color color;

  const CircularProgressBar({Key? key, this.color = Colors.blue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: SpinKitFadingCircle(
        color: color,
        size: 48.0,
      ),
    );
  }
}


