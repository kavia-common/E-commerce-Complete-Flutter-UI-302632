import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence keys are centralized to make future migrations easier.
class _AccountStorageKeys {
  static const String profile = 'account.profile.v1';
  static const String addresses = 'account.addresses.v1';
  static const String preferences = 'account.preferences.v1';
  static const String wishlist = 'account.wishlist.v1';
  static const String locale = 'account.locale.v1';
}

abstract interface class AccountLocalDataSource {
  Future<Map<String, Object?>?> readProfile();
  Future<void> writeProfile(Map<String, Object?> json);

  Future<List<Map<String, Object?>>> readAddresses();
  Future<void> writeAddresses(List<Map<String, Object?>> json);

  Future<Map<String, Object?>?> readPreferences();
  Future<void> writePreferences(Map<String, Object?> json);

  Future<Map<String, Object?>?> readWishlist();
  Future<void> writeWishlist(Map<String, Object?> json);

  Future<String?> readLocaleCode();
  Future<void> writeLocaleCode(String? localeCode);

  Future<void> deleteAll();
}

class SharedPrefsAccountLocalDataSource implements AccountLocalDataSource {
  SharedPrefsAccountLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static Future<SharedPrefsAccountLocalDataSource> create() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return SharedPrefsAccountLocalDataSource(prefs);
  }

  @override
  Future<Map<String, Object?>?> readProfile() async {
    final String? raw = _prefs.getString(_AccountStorageKeys.profile);
    if (raw == null || raw.isEmpty) return null;
    final Object decoded = json.decode(raw);
    return (decoded as Map<String, dynamic>).cast<String, Object?>();
  }

  @override
  Future<void> writeProfile(Map<String, Object?> jsonMap) async {
    await _prefs.setString(_AccountStorageKeys.profile, json.encode(jsonMap));
  }

  @override
  Future<List<Map<String, Object?>>> readAddresses() async {
    final String? raw = _prefs.getString(_AccountStorageKeys.addresses);
    if (raw == null || raw.isEmpty) return <Map<String, Object?>>[];
    final Object decoded = json.decode(raw);
    final List<dynamic> list = decoded as List<dynamic>;
    return list
        .map((e) => (e as Map<String, dynamic>).cast<String, Object?>())
        .toList();
  }

  @override
  Future<void> writeAddresses(List<Map<String, Object?>> jsonList) async {
    await _prefs.setString(_AccountStorageKeys.addresses, json.encode(jsonList));
  }

  @override
  Future<Map<String, Object?>?> readPreferences() async {
    final String? raw = _prefs.getString(_AccountStorageKeys.preferences);
    if (raw == null || raw.isEmpty) return null;
    final Object decoded = json.decode(raw);
    return (decoded as Map<String, dynamic>).cast<String, Object?>();
  }

  @override
  Future<void> writePreferences(Map<String, Object?> jsonMap) async {
    await _prefs.setString(_AccountStorageKeys.preferences, json.encode(jsonMap));
  }

  @override
  Future<Map<String, Object?>?> readWishlist() async {
    final String? raw = _prefs.getString(_AccountStorageKeys.wishlist);
    if (raw == null || raw.isEmpty) return null;
    final Object decoded = json.decode(raw);
    return (decoded as Map<String, dynamic>).cast<String, Object?>();
  }

  @override
  Future<void> writeWishlist(Map<String, Object?> jsonMap) async {
    await _prefs.setString(_AccountStorageKeys.wishlist, json.encode(jsonMap));
  }

  @override
  Future<String?> readLocaleCode() async {
    return _prefs.getString(_AccountStorageKeys.locale);
  }

  @override
  Future<void> writeLocaleCode(String? localeCode) async {
    if (localeCode == null || localeCode.isEmpty) {
      await _prefs.remove(_AccountStorageKeys.locale);
      return;
    }
    await _prefs.setString(_AccountStorageKeys.locale, localeCode);
  }

  @override
  Future<void> deleteAll() async {
    await _prefs.remove(_AccountStorageKeys.profile);
    await _prefs.remove(_AccountStorageKeys.addresses);
    await _prefs.remove(_AccountStorageKeys.preferences);
    await _prefs.remove(_AccountStorageKeys.wishlist);
    await _prefs.remove(_AccountStorageKeys.locale);
  }
}
