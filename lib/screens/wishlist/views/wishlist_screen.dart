import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/account/viewmodels/wishlist_view_model.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  String _productId(ProductModel p) => '${p.brandName}|${p.title}|${p.image}';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('wishlist_title')),
      ),
      body: Consumer<WishlistViewModel>(
        builder: (context, vm, _) {
          final Set<String> ids = vm.wishlist?.productIds ?? <String>{};
          final List<ProductModel> all = demoPopularProducts;
          final List<ProductModel> wished =
              all.where((p) => ids.contains(_productId(p))).toList();

          if (vm.isLoading && vm.wishlist == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (wished.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loc.t('wishlist_empty_title'),
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    Text(
                      loc.t('wishlist_empty_body'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: defaultPadding,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final ProductModel p = wished[index];
                      return ProductCard(
                        image: p.image,
                        brandName: p.brandName,
                        title: p.title,
                        price: p.price,
                        priceAfetDiscount: p.priceAfetDiscount,
                        dicountpercent: p.dicountpercent,
                        isWishlisted: true,
                        onToggleWishlist: () {
                          context.read<WishlistViewModel>().toggle(_productId(p));
                        },
                        press: () {
                          Navigator.pushNamed(context, productDetailsScreenRoute);
                        },
                      );
                    },
                    childCount: wished.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
