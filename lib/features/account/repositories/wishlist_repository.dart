import '../data/account_local_data_source.dart';
import '../models/wishlist.dart';

abstract interface class WishlistRepository {
  Future<Wishlist> getWishlist();
  Future<Wishlist> toggle(String productId);
  Future<bool> isWishlisted(String productId);

  Future<void> seedIfEmpty();
  Future<void> clear();
}

class LocalWishlistRepository implements WishlistRepository {
  LocalWishlistRepository(this._local);

  final AccountLocalDataSource _local;

  @override
  Future<void> seedIfEmpty() async {
    final Map<String, Object?>? existing = await _local.readWishlist();
    if (existing != null) return;

    await _local.writeWishlist(Wishlist.empty().toJson());
  }

  @override
  Future<Wishlist> getWishlist() async {
    final Map<String, Object?>? json = await _local.readWishlist();
    if (json == null) {
      throw StateError('Wishlist not found');
    }
    return Wishlist.fromJson(json);
  }

  @override
  Future<bool> isWishlisted(String productId) async {
    final Wishlist w = await getWishlist();
    return w.contains(productId);
  }

  @override
  Future<Wishlist> toggle(String productId) async {
    final Wishlist current = await getWishlist();
    final Set<String> nextIds = <String>{...current.productIds};
    if (nextIds.contains(productId)) {
      nextIds.remove(productId);
    } else {
      nextIds.add(productId);
    }
    final Wishlist next =
        current.copyWith(productIds: nextIds, updatedAt: DateTime.now());
    await _local.writeWishlist(next.toJson());
    return next;
  }

  @override
  Future<void> clear() async {
    await _local.writeWishlist(<String, Object?>{});
  }
}
