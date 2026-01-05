import '../data/account_local_data_source.dart';

abstract interface class LocaleRepository {
  Future<String?> getLocaleCode();
  Future<void> setLocaleCode(String? localeCode);

  Future<void> clear();
}

class LocalLocaleRepository implements LocaleRepository {
  LocalLocaleRepository(this._local);

  final AccountLocalDataSource _local;

  @override
  Future<String?> getLocaleCode() => _local.readLocaleCode();

  @override
  Future<void> setLocaleCode(String? localeCode) => _local.writeLocaleCode(localeCode);

  @override
  Future<void> clear() => _local.writeLocaleCode(null);
}
