import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/account/models/address.dart';
import 'package:shop/features/account/viewmodels/address_book_view_model.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:shop/route/route_constants.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('addresses_title')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, addOrEditAddressScreenRoute);
            },
            child: Text(loc.t('add_address')),
          )
        ],
      ),
      body: Consumer<AddressBookViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.addresses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null && vm.addresses.isEmpty) {
            return _ErrorState(
              message: vm.errorMessage!,
              onRetry: () => vm.load(),
            );
          }

          if (vm.addresses.isEmpty) {
            return _EmptyState(
              onAdd: () => Navigator.pushNamed(context, addOrEditAddressScreenRoute),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: vm.addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: defaultPadding),
            itemBuilder: (context, index) {
              final Address a = vm.addresses[index];
              return _AddressCard(address: a);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, addOrEditAddressScreenRoute),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});

  final Address address;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withAlpha((0.08 * 255).round())),
        borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  address.fullName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2,
                    vertical: defaultPadding / 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha((0.12 * 255).round()),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(defaultBorderRadious),
                    ),
                  ),
                  child: Text(
                    loc.t('default_address'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(address.phoneNumber),
          const SizedBox(height: defaultPadding / 2),
          Text('${address.line1}${address.line2 == null || address.line2!.trim().isEmpty ? '' : '\n${address.line2}'}'),
          Text('${address.city}${address.state == null || address.state!.trim().isEmpty ? '' : ', ${address.state}'} ${address.postalCode}'),
          Text(address.countryCode),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    addOrEditAddressScreenRoute,
                    arguments: address.id,
                  );
                },
                icon: const Icon(Icons.edit, size: 18),
                label: Text(loc.t('edit_address')),
              ),
              const SizedBox(width: defaultPadding / 2),
              TextButton.icon(
                onPressed: () {
                  context.read<AddressBookViewModel>().delete(address.id);
                },
                icon: const Icon(Icons.delete_outline, size: 18),
                label: Text(loc.t('delete_address')),
              ),
              const Spacer(),
              TextButton(
                onPressed: address.isDefault
                    ? null
                    : () {
                        context.read<AddressBookViewModel>().setDefault(address.id);
                      },
                child: Text(loc.t('set_default')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.t('no_addresses_title'),
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              loc.t('no_addresses_body'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: onAdd,
              child: Text(loc.t('add_address')),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(loc.t('retry')),
            ),
          ],
        ),
      ),
    );
  }
}
