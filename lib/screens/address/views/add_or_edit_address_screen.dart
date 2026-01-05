import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/account/models/address.dart';
import 'package:shop/features/account/viewmodels/address_book_view_model.dart';
import 'package:shop/l10n/app_localizations.dart';

class AddOrEditAddressScreen extends StatefulWidget {
  const AddOrEditAddressScreen({super.key, this.addressId});

  final String? addressId;

  @override
  State<AddOrEditAddressScreen> createState() => _AddOrEditAddressScreenState();
}

class _AddOrEditAddressScreenState extends State<AddOrEditAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullName;
  late final TextEditingController _phone;
  late final TextEditingController _line1;
  late final TextEditingController _line2;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _postal;
  late final TextEditingController _country;

  bool _makeDefault = false;

  @override
  void initState() {
    super.initState();
    final vm = context.read<AddressBookViewModel>();
    final Address? existing = widget.addressId == null
        ? null
        : vm.addresses.where((a) => a.id == widget.addressId).cast<Address?>().firstOrNull;

    _fullName = TextEditingController(text: existing?.fullName ?? '');
    _phone = TextEditingController(text: existing?.phoneNumber ?? '');
    _line1 = TextEditingController(text: existing?.line1 ?? '');
    _line2 = TextEditingController(text: existing?.line2 ?? '');
    _city = TextEditingController(text: existing?.city ?? '');
    _state = TextEditingController(text: existing?.state ?? '');
    _postal = TextEditingController(text: existing?.postalCode ?? '');
    _country = TextEditingController(text: existing?.countryCode ?? 'US');
    _makeDefault = existing?.isDefault ?? false;
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _line1.dispose();
    _line2.dispose();
    _city.dispose();
    _state.dispose();
    _postal.dispose();
    _country.dispose();
    super.dispose();
  }

  String? _required(String? v, AppLocalizations loc) {
    if (v == null || v.trim().isEmpty) return loc.t('validation_required');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);
    final bool isEdit = widget.addressId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? loc.t('edit_address') : loc.t('add_address')),
      ),
      body: Consumer<AddressBookViewModel>(
        builder: (context, vm, _) {
          return AbsorbPointer(
            absorbing: vm.isLoading,
            child: ListView(
              padding: const EdgeInsets.all(defaultPadding),
              children: [
                if (vm.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: errorColor.withAlpha((0.08 * 255).round()),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadious),
                      ),
                    ),
                    child: Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: errorColor),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                ],
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _fullName,
                        decoration: InputDecoration(labelText: loc.t('address_full_name')),
                        validator: (v) => _required(v, loc),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _phone,
                        decoration: InputDecoration(labelText: loc.t('address_phone')),
                        validator: (v) => _required(v, loc),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _line1,
                        decoration: InputDecoration(labelText: loc.t('address_line1')),
                        validator: (v) => _required(v, loc),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _line2,
                        decoration: InputDecoration(labelText: loc.t('address_line2')),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _city,
                        decoration: InputDecoration(labelText: loc.t('address_city')),
                        validator: (v) => _required(v, loc),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _state,
                        decoration: InputDecoration(labelText: loc.t('address_state')),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _postal,
                        decoration:
                            InputDecoration(labelText: loc.t('address_postal_code')),
                        validator: (v) => _required(v, loc),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _country,
                        decoration:
                            InputDecoration(labelText: loc.t('address_country_code')),
                        validator: (v) => _required(v, loc),
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: defaultPadding),
                      SwitchListTile(
                        value: _makeDefault,
                        onChanged: (v) {
                          setState(() {
                            _makeDefault = v;
                          });
                        },
                        title: Text(loc.t('default_address')),
                      ),
                      const SizedBox(height: defaultPadding),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!(_formKey.currentState?.validate() ?? false)) return;

                            final DateTime now = DateTime.now();
                            final String id = isEdit
                                ? widget.addressId!
                                : 'addr_${now.microsecondsSinceEpoch}';

                            final Address address = Address(
                              id: id,
                              userId: 'local-user',
                              fullName: _fullName.text.trim(),
                              phoneNumber: _phone.text.trim(),
                              line1: _line1.text.trim(),
                              line2: _line2.text.trim().isEmpty ? null : _line2.text.trim(),
                              city: _city.text.trim(),
                              state: _state.text.trim().isEmpty ? null : _state.text.trim(),
                              postalCode: _postal.text.trim(),
                              countryCode: _country.text.trim().toUpperCase(),
                              isDefault: _makeDefault,
                              createdAt: isEdit
                                  ? (vm.addresses
                                          .where((a) => a.id == id)
                                          .cast<Address?>()
                                          .firstOrNull
                                          ?.createdAt ??
                                      now)
                                  : now,
                              updatedAt: now,
                            );

                            final bool ok = isEdit
                                ? await vm.edit(address)
                                : await vm.add(address);

                            if (!context.mounted) return;
                            if (ok) Navigator.pop(context);
                          },
                          child: vm.isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(loc.t('save')),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

extension on Iterable {
  Object? get firstOrNull => isEmpty ? null : first;
}
