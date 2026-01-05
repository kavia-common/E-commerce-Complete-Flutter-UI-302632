import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/account/viewmodels/profile_view_model.dart';
import 'package:shop/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers are safe because we only use them in sync callbacks.
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    final vm = context.read<ProfileViewModel>();
    final p = vm.profile;

    _nameController = TextEditingController(text: p?.displayName ?? '');
    _emailController = TextEditingController(text: p?.email ?? '');
    _phoneController = TextEditingController(text: p?.phoneNumber ?? '');
    _avatarController = TextEditingController(text: p?.avatarUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? v, AppLocalizations loc) {
    if (v == null || v.trim().isEmpty) return loc.t('validation_required');
    return null;
  }

  String? _validateEmail(String? v, AppLocalizations loc) {
    final String value = (v ?? '').trim();
    if (value.isEmpty) return loc.t('validation_required');
    final RegExp re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(value)) return loc.t('validation_invalid_email');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('edit_profile_title')),
      ),
      body: Consumer<ProfileViewModel>(
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: loc.t('field_display_name'),
                        ),
                        validator: (v) => _validateRequired(v, loc),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: loc.t('field_email'),
                        ),
                        validator: (v) => _validateEmail(v, loc),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: loc.t('field_phone'),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: defaultPadding),
                      TextFormField(
                        controller: _avatarController,
                        decoration: InputDecoration(
                          labelText: loc.t('field_avatar_url'),
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: defaultPadding * 1.5),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Avoid context usage across async gap:
                            // validate synchronously and call VM; navigation after awaits is avoided.
                            if (!(_formKey.currentState?.validate() ?? false)) return;

                            final bool ok = await vm.updateProfile(
                              displayName: _nameController.text,
                              email: _emailController.text,
                              phoneNumber: _phoneController.text,
                              avatarUrl: _avatarController.text,
                            );

                            if (!context.mounted) return;
                            if (ok) {
                              Navigator.pop(context);
                            }
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
