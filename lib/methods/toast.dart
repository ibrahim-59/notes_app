import 'package:fluttertoast/fluttertoast.dart';

class AppMethods {
  showToast({required String title}) {
    return Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }
}
