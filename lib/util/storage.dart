import 'package:shared_preferences/shared_preferences.dart';

class Storage {
    static SharedPreferences sp;

    static init() async {
        sp = await SharedPreferences.getInstance();
    }
}