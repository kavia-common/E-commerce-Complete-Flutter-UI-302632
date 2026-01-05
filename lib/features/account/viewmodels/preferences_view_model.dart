import 'package:flutter/foundation.dart';

import '../models/preferences.dart';
import '../repositories/preferences_repository.dart';

class PreferencesViewModel extends ChangeNotifier {
  PreferencesViewModel(this._repo);

  final PreferencesRepository _repo;

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;
  Preferences? preferences;

  // PUBLIC_INTERFACE
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.seedIfEmpty();
      preferences = await _repo.getPreferences();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _toggle(String key, bool value) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      preferences = await _repo.setPreference(key: key, value: value);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  Future<void> toggleAnalytics(bool value) => _toggle('analyticsEnabled', value);

  // PUBLIC_INTERFACE
  Future<void> togglePersonalization(bool value) =>
      _toggle('personalizationEnabled', value);

  // PUBLIC_INTERFACE
  Future<void> toggleMarketing(bool value) => _toggle('marketingEnabled', value);

  // PUBLIC_INTERFACE
  Future<void> toggleSocialMedia(bool value) =>
      _toggle('socialMediaEnabled', value);

  // PUBLIC_INTERFACE
  Future<void> resetToDefaults() async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      preferences = await _repo.updatePreferences(Preferences.defaults());
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
