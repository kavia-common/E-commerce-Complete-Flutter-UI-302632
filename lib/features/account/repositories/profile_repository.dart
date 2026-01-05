import 'package:flutter/foundation.dart';

import '../data/account_local_data_source.dart';
import '../models/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile> getProfile();

  Future<UserProfile> updateProfile({
    String? displayName,
    String? email,
    String? avatarUrl,
    String? phoneNumber,
  });

  /// Seeds a local profile if none exists (for demo/offline).
  Future<void> seedIfEmpty();

  Future<void> clear();
}

class LocalProfileRepository implements ProfileRepository {
  LocalProfileRepository(this._local);

  final AccountLocalDataSource _local;

  @override
  Future<void> seedIfEmpty() async {
    final Map<String, Object?>? existing = await _local.readProfile();
    if (existing != null) return;

    final DateTime now = DateTime.now();
    final UserProfile seeded = UserProfile(
      id: 'local-user',
      displayName: 'Sepide',
      email: 'theflutterway@gmail.com',
      avatarUrl: 'https://i.imgur.com/IXnwbLk.png',
      phoneNumber: null,
      createdAt: now,
      updatedAt: now,
    );
    await _local.writeProfile(seeded.toJson());
  }

  @override
  Future<UserProfile> getProfile() async {
    final Map<String, Object?>? json = await _local.readProfile();
    if (json == null) {
      throw StateError('Profile not found');
    }
    return UserProfile.fromJson(json);
  }

  bool _isValidEmail(String email) {
    // Pragmatic email validation for offline UI kit.
    final RegExp re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return re.hasMatch(email.trim());
  }

  @override
  Future<UserProfile> updateProfile({
    String? displayName,
    String? email,
    String? avatarUrl,
    String? phoneNumber,
  }) async {
    final UserProfile current = await getProfile();

    final String? newDisplayName = displayName?.trim();
    final String? newEmail = email?.trim();

    if (newDisplayName != null && newDisplayName.isEmpty) {
      throw ArgumentError('displayName_required');
    }
    if (newEmail != null && !_isValidEmail(newEmail)) {
      throw ArgumentError('invalid_email');
    }

    final UserProfile updated = current.copyWith(
      displayName: newDisplayName ?? current.displayName,
      email: newEmail ?? current.email,
      avatarUrl: avatarUrl?.trim().isEmpty == true ? null : avatarUrl?.trim(),
      phoneNumber:
          phoneNumber?.trim().isEmpty == true ? null : phoneNumber?.trim(),
      updatedAt: DateTime.now(),
    );

    await _local.writeProfile(updated.toJson());
    return updated;
  }

  @override
  Future<void> clear() => _local.writeProfile(<String, Object?>{});

  /// Helper for debugging / future extension.
  @visibleForTesting
  AccountLocalDataSource get debugLocalDataSource => _local;
}
