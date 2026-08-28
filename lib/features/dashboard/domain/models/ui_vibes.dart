enum UiVibe { standard, minimalist, dense, cozyPastel }

extension UiVibeExtension on UiVibe {
  String get displayName {
    switch (this) {
      case UiVibe.standard:
        return 'Standard';
      case UiVibe.minimalist:
        return 'Minimalist';
      case UiVibe.dense:
        return 'Pro Dense';
      case UiVibe.cozyPastel:
        return 'Cozy Pastel';
    }
  }
}
