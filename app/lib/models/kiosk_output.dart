import 'package:schemantic/schemantic.dart';

part 'kiosk_output.g.dart';

@Schema()
abstract class $KioskOutput {
  bool get success;
  String get imageUrl;
  String get caption;
}
