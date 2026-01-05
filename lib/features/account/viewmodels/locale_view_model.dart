import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../repositories/locale_repository.dart';

class LocaleViewModel extends ChangeNotifier {
  LocaleViewModel(this._repo);

  final LocaleRepository _repo;

  bool isLoading = false;
  String? errorMessage;
  Locale? locale;

  // PUBLIC_INTERFACE
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final String? code = await _repo.getLocaleCode();
      locale = (code == null || code.isEmpty) ? null : Locale(code);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  Future<void> setLocale(Locale? next) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      locale = next;
      await _repo.setLocaleCode(next?.languageCode);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
