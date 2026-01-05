import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/account/viewmodels/profile_view_model.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:shop/route/route_constants.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('user_info_title')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, editProfileScreenRoute);
            },
            child: Text(loc.t('edit_profile_title')),
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.errorMessage != null && vm.profile == null) {
            return _ErrorState(
              message: vm.errorMessage!,
              onRetry: () => vm.load(),
            );
          }

          final profile = vm.profile!;
          return ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(profile.displayName),
                subtitle: Text(profile.email),
              ),
              const Divider(),
              _InfoRow(label: loc.t('field_display_name'), value: profile.displayName),
              _InfoRow(label: loc.t('field_email'), value: profile.email),
              _InfoRow(label: loc.t('field_phone'), value: profile.phoneNumber ?? '-'),
              _InfoRow(
                label: loc.t('field_avatar_url'),
                value: profile.avatarUrl ?? '-',
                isSelectable: true,
              ),
              if (vm.errorMessage != null) ...[
                const SizedBox(height: defaultPadding),
                _InlineError(message: vm.errorMessage!),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isSelectable = false,
  });

  final String label;
  final String value;
  final bool isSelectable;

  @override
  Widget build(BuildContext context) {
    final TextStyle? labelStyle = Theme.of(context).textTheme.bodyMedium;
    final TextStyle? valueStyle = Theme.of(context).textTheme.titleSmall;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: labelStyle)),
          const SizedBox(width: defaultPadding / 2),
          Expanded(
            child: isSelectable
                ? SelectableText(value, style: valueStyle)
                : Text(value, style: valueStyle),
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: errorColor.withAlpha((0.08 * 255).round()),
        borderRadius: const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: errorColor),
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
