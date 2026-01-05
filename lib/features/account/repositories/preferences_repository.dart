import '../data/account_local_data_source.dart';
import '../models/preferences.dart';

abstract interface class PreferencesRepository {
  Future<Preferences> getPreferences();

  Future<Preferences> updatePreferences(Preferences preferences);

  /// Convenience update for a single toggle to reduce write churn.
  Future<Preferences> setPreference({
    required String key,
    required bool value,
  });

  Future<void> seedIfEmpty();
  Future<void> clear();
}

class LocalPreferencesRepository implements PreferencesRepository {
  LocalPreferencesRepository(this._local);

  final AccountLocalDataSource _local;

  @override
  Future<void> seedIfEmpty() async {
    final Map<String, Object?>? existing = await _local.readPreferences();
    if (existing != null) return;

    final Preferences p = Preferences.defaults();
    await _local.writePreferences(p.toJson());
  }

  @override
  Future<Preferences> getPreferences() async {
    final Map<String, Object?>? json = await _local.readPreferences();
    if (json == null) {
      throw StateError('Preferences not found');
    }
    return Preferences.fromJson(json);
  }

  @override
  Future<Preferences> updatePreferences(Preferences preferences) async {
    final Preferences updated = preferences.copyWith(updatedAt: DateTime.now());
    await _local.writePreferences(updated.toJson());
    return updated;
  }

  @override
  Future<Preferences> setPreference({
    required String key,
    required bool value,
  }) async {
    final Preferences current = await getPreferences();
    Preferences next = current;

    switch (key) {
      case 'analyticsEnabled':
        next = current.copyWith(analyticsEnabled: value);
        break;
      case 'personalizationEnabled':
        next = current.copyWith(personalizationEnabled: value);
        break;
      case 'marketingEnabled':
        next = current.copyWith(marketingEnabled: value);
        break;
      case 'socialMediaEnabled':
        next = current.copyWith(socialMediaEnabled: value);
        break;
      default:
        throw ArgumentError('Unknown preference key');
    }

    return updatePreferences(next);
  }

  @override
  Future<void> clear() async {
    await _local.writePreferences(<String, Object?>{});
  }
}
