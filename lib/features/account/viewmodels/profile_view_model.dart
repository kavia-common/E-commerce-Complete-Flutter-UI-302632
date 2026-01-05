import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repo);

  final ProfileRepository _repo;

  bool isLoading = false;
  String? errorMessage;
  UserProfile? profile;

  // PUBLIC_INTERFACE
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.seedIfEmpty();
      profile = await _repo.getProfile();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  Future<bool> updateProfile({
    required String displayName,
    required String email,
    String? avatarUrl,
    String? phoneNumber,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _repo.updateProfile(
        displayName: displayName,
        email: email,
        avatarUrl: avatarUrl,
        phoneNumber: phoneNumber,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
