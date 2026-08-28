import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/ui_vibes.dart';

final uiVibeProvider = NotifierProvider<UiVibeNotifier, UiVibe>(() {
  return UiVibeNotifier();
});

class UiVibeNotifier extends Notifier<UiVibe> {
  @override
  UiVibe build() {
    return UiVibe.standard;
  }

  void setVibe(UiVibe vibe) {
    state = vibe;
  }
}
