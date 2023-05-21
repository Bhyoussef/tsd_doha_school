import 'package:flutter_device_type/flutter_device_type.dart';

import '../model/auth_model.dart';

class Res {
  static bool isPhone = Device.get().isPhone;
  static const host = 'https://tsdoha.com';
  static Authentificate? USER;
}
