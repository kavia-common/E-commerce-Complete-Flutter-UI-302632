import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Minimal localization loader for this UI kit.
/// Uses ARB-like JSON assets under `lib/l10n/`.
///
/// Note: This is intentionally lightweight (not using gen-l10n) to avoid
/// template configuration changes while still enabling runtime locale switching.
class AppLocalizations {
  AppLocalizations(this.locale, this._strings);

  final Locale locale;
  final Map<String, String> _strings;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = <Locale>[
    Locale('en'),
  ];

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? loc =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(loc != null, 'AppLocalizations not found in widget tree');
    return loc!;
  }

  String t(String key) => _strings[key] ?? key;

  static Future<AppLocalizations> load(Locale locale) async {
    // Locale fallback: use languageCode only.
    final String code = locale.languageCode;
    final String path = 'lib/l10n/app_$code.arb';
    final String raw = await rootBundle.loadString(path);
    final Map<String, Object?> jsonMap =
        json.decode(raw) as Map<String, Object?>;

    // ARB keys include '@@locale' and '@key' metadata; ignore non-string values.
    final Map<String, String> strings = <String, String>{};
    for (final MapEntry<String, Object?> e in jsonMap.entries) {
      if (e.value is String && !e.key.startsWith('@')) {
        strings[e.key] = e.value as String;
      }
    }

    return AppLocalizations(locale, strings);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// PUBLIC_INTERFACE
class AppLocaleController extends ChangeNotifier {
  /// Holds and updates the app locale at runtime.
  AppLocaleController({Locale? initialLocale}) : _locale = initialLocale;

  Locale? _locale;

  Locale? get locale => _locale;

  // PUBLIC_INTERFACE
  void setLocale(Locale? locale) {
    _locale = locale;
    notifyListeners();
  }
}
