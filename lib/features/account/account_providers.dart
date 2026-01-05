import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'data/account_local_data_source.dart';
import 'repositories/address_book_repository.dart';
import 'repositories/locale_repository.dart';
import 'repositories/preferences_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/wishlist_repository.dart';
import 'viewmodels/address_book_view_model.dart';
import 'viewmodels/locale_view_model.dart';
import 'viewmodels/preferences_view_model.dart';
import 'viewmodels/profile_view_model.dart';
import 'viewmodels/wishlist_view_model.dart';

/// Provides account-related repositories and view models.
///
/// Backend swapping note:
/// Replace Local*Repository with API-backed ones (or sync repositories) without
/// changing UI widgets; only this provider composition should change.
class AccountProviders extends StatelessWidget {
  const AccountProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPrefsAccountLocalDataSource>(
      future: SharedPrefsAccountLocalDataSource.create(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Keep UI kit simple: show the app shell quickly with empty providers.
          // Screens will show loading spinners until local source is ready.
          return child;
        }

        final AccountLocalDataSource local = snapshot.data!;

        return MultiProvider(
          providers: [
            Provider<ProfileRepository>(create: (_) => LocalProfileRepository(local)),
            Provider<AddressBookRepository>(
                create: (_) => LocalAddressBookRepository(local)),
            Provider<PreferencesRepository>(
                create: (_) => LocalPreferencesRepository(local)),
            Provider<WishlistRepository>(create: (_) => LocalWishlistRepository(local)),
            Provider<LocaleRepository>(create: (_) => LocalLocaleRepository(local)),

            ChangeNotifierProvider<ProfileViewModel>(
              create: (ctx) => ProfileViewModel(ctx.read<ProfileRepository>())..load(),
            ),
            ChangeNotifierProvider<AddressBookViewModel>(
              create: (ctx) => AddressBookViewModel(ctx.read<AddressBookRepository>())..load(),
            ),
            ChangeNotifierProvider<PreferencesViewModel>(
              create: (ctx) =>
                  PreferencesViewModel(ctx.read<PreferencesRepository>())..load(),
            ),
            ChangeNotifierProvider<WishlistViewModel>(
              create: (ctx) =>
                  WishlistViewModel(ctx.read<WishlistRepository>())..load(),
            ),
            ChangeNotifierProvider<LocaleViewModel>(
              create: (ctx) => LocaleViewModel(ctx.read<LocaleRepository>())..load(),
            ),
          ],
          child: child,
        );
      },
    );
  }
}
