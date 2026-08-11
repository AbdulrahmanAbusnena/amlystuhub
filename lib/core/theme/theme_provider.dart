import 'package:amlystuhub/core/theme/presets/classic_cyberdeck.dart';
import 'package:amlystuhub/core/theme/presets/lavendar_blueprint.dart';
import 'package:amlystuhub/core/theme/presets/sakura_cream.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = sakuraCreamMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == sakuraCreamMode) {
      themeData = cyberDeckMode;
    } else if (_themeData == cyberDeckMode) {
      themeData = lavenderBlueprintMode;
    } else {
      themeData = sakuraCreamMode;
    }
  }
}
