import 'package:flutter/foundation.dart';

import '../models/address.dart';
import '../repositories/address_book_repository.dart';

class AddressBookViewModel extends ChangeNotifier {
  AddressBookViewModel(this._repo);

  final AddressBookRepository _repo;

  bool isLoading = false;
  String? errorMessage;
  List<Address> addresses = <Address>[];

  // PUBLIC_INTERFACE
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.seedIfEmpty();
      addresses = await _repo.listAddresses();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  Future<bool> add(Address address) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.addAddress(address);
      addresses = await _repo.listAddresses();
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
  Future<bool> edit(Address address) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.updateAddress(address);
      addresses = await _repo.listAddresses();
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
  Future<void> delete(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.deleteAddress(id);
      addresses = await _repo.listAddresses();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  Future<void> setDefault(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.setDefaultAddress(id);
      addresses = await _repo.listAddresses();
    } catch (e) {
      errorMessage = e.toString();
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
