import 'package:flutter/foundation.dart';

import '../models/wishlist.dart';
import '../repositories/wishlist_repository.dart';

class WishlistViewModel extends ChangeNotifier {
  WishlistViewModel(this._repo);

  final WishlistRepository _repo;

  bool isLoading = false;
  String? errorMessage;
  Wishlist? wishlist;

  // PUBLIC_INTERFACE
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.seedIfEmpty();
      wishlist = await _repo.getWishlist();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  bool isWishlistedSync(String productId) {
    return wishlist?.contains(productId) ?? false;
  }

  // PUBLIC_INTERFACE
  Future<void> toggle(String productId) async {
    // No context usage here; just mutate primitive/model state.
    errorMessage = null;
    notifyListeners();

    try {
      wishlist = await _repo.toggle(productId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
