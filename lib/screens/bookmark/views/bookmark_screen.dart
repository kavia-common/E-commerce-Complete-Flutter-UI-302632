import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/features/account/viewmodels/wishlist_view_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  String _productId(ProductModel p) => '${p.brandName}|${p.title}|${p.image}';

  @override
  Widget build(BuildContext context) {
    final WishlistViewModel wishlist = context.watch<WishlistViewModel>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // While loading use 👇
          //  BookMarksSlelton(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
                childAspectRatio: 0.66,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final ProductModel p = demoPopularProducts[index];
                  final String id = _productId(p);

                  return ProductCard(
                    image: p.image,
                    brandName: p.brandName,
                    title: p.title,
                    price: p.price,
                    priceAfetDiscount: p.priceAfetDiscount,
                    dicountpercent: p.dicountpercent,
                    isWishlisted: wishlist.isWishlistedSync(id),
                    onToggleWishlist: () {
                      context.read<WishlistViewModel>().toggle(id);
                    },
                    press: () {
                      Navigator.pushNamed(context, productDetailsScreenRoute);
                    },
                  );
                },
                childCount: demoPopularProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
