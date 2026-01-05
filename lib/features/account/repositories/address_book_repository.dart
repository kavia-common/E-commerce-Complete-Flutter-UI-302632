import '../data/account_local_data_source.dart';
import '../models/address.dart';

abstract interface class AddressBookRepository {
  Future<List<Address>> listAddresses();
  Future<Address?> getAddress(String addressId);

  Future<Address> addAddress(Address address);
  Future<Address> updateAddress(Address address);
  Future<void> deleteAddress(String addressId);

  Future<void> setDefaultAddress(String addressId);

  Future<void> seedIfEmpty();
  Future<void> clear();
}

class LocalAddressBookRepository implements AddressBookRepository {
  LocalAddressBookRepository(this._local);

  final AccountLocalDataSource _local;

  @override
  Future<void> seedIfEmpty() async {
    final List<Map<String, Object?>> existing = await _local.readAddresses();
    if (existing.isNotEmpty) return;

    final DateTime now = DateTime.now();
    final Address seeded = Address(
      id: 'addr_1',
      userId: 'local-user',
      fullName: 'Sepide',
      phoneNumber: '+1 555 0100',
      line1: '123 Market Street',
      line2: 'Apt 4B',
      city: 'San Francisco',
      state: 'CA',
      postalCode: '94103',
      countryCode: 'US',
      isDefault: true,
      createdAt: now,
      updatedAt: now,
    );

    await _local.writeAddresses(<Map<String, Object?>>[seeded.toJson()]);
  }

  @override
  Future<List<Address>> listAddresses() async {
    final List<Map<String, Object?>> list = await _local.readAddresses();
    final List<Address> addresses = list.map(Address.fromJson).toList();
    addresses.sort((a, b) {
      if (a.isDefault && !b.isDefault) return -1;
      if (!a.isDefault && b.isDefault) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return addresses;
  }

  @override
  Future<Address?> getAddress(String addressId) async {
    final List<Address> addresses = await listAddresses();
    try {
      return addresses.firstWhere((a) => a.id == addressId);
    } catch (_) {
      return null;
    }
  }

  void _validate(Address a) {
    if (a.fullName.trim().isEmpty) throw ArgumentError('fullName_required');
    if (a.phoneNumber.trim().length < 6) {
      throw ArgumentError('phoneNumber_required');
    }
    if (a.line1.trim().isEmpty) throw ArgumentError('line1_required');
    if (a.city.trim().isEmpty) throw ArgumentError('city_required');
    if (a.postalCode.trim().isEmpty) throw ArgumentError('postalCode_required');
    if (a.countryCode.trim().isEmpty) {
      throw ArgumentError('countryCode_required');
    }
  }

  @override
  Future<Address> addAddress(Address address) async {
    _validate(address);

    final List<Address> addresses = await listAddresses();
    final List<Address> next = <Address>[
      ...addresses.map((a) => a.copyWith(isDefault: a.isDefault && !address.isDefault)),
      address,
    ];

    // If adding as default, ensure uniqueness.
    if (address.isDefault) {
      for (int i = 0; i < next.length; i++) {
        next[i] = next[i].copyWith(isDefault: next[i].id == address.id);
      }
    } else if (next.length == 1) {
      // First address becomes default.
      next[0] = next[0].copyWith(isDefault: true);
    }

    await _local.writeAddresses(next.map((e) => e.toJson()).toList());
    return address;
  }

  @override
  Future<Address> updateAddress(Address address) async {
    _validate(address);

    final List<Address> addresses = await listAddresses();
    final int idx = addresses.indexWhere((a) => a.id == address.id);
    if (idx < 0) throw StateError('Address not found');

    final List<Address> next = <Address>[...addresses];
    next[idx] = address;

    if (address.isDefault) {
      for (int i = 0; i < next.length; i++) {
        next[i] = next[i].copyWith(isDefault: next[i].id == address.id);
      }
    } else {
      // If no default remains, promote first.
      if (!next.any((a) => a.isDefault)) {
        next[0] = next[0].copyWith(isDefault: true);
      }
    }

    await _local.writeAddresses(next.map((e) => e.toJson()).toList());
    return address;
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    final List<Address> addresses = await listAddresses();
    final Address? toDelete =
        addresses.where((a) => a.id == addressId).firstOrNull;
    final List<Address> next =
        addresses.where((a) => a.id != addressId).toList();

    if (next.isNotEmpty && (toDelete?.isDefault ?? false)) {
      // Promote first remaining to default as per LLD acceptance.
      next[0] = next[0].copyWith(isDefault: true);
      for (int i = 1; i < next.length; i++) {
        next[i] = next[i].copyWith(isDefault: false);
      }
    }

    await _local.writeAddresses(next.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    final List<Address> addresses = await listAddresses();
    if (addresses.isEmpty) return;

    final List<Address> next = addresses
        .map((a) => a.copyWith(isDefault: a.id == addressId))
        .toList();

    await _local.writeAddresses(next.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> clear() async => _local.writeAddresses(<Map<String, Object?>>[]);
}

extension on Iterable<Address> {
  Address? get firstOrNull => isEmpty ? null : first;
}
