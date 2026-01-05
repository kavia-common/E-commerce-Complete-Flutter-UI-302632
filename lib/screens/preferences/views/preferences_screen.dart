import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/account/viewmodels/preferences_view_model.dart';
import 'package:shop/l10n/app_localizations.dart';

import 'components/prederence_list_tile.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('cookie_preferences_title')),
        actions: [
          TextButton(
            onPressed: () {
              context.read<PreferencesViewModel>().resetToDefaults();
            },
            child: Text(loc.t('reset')),
          )
        ],
      ),
      body: Consumer<PreferencesViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.preferences == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final p = vm.preferences;

          if (p == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(vm.errorMessage ?? 'Failed to load preferences'),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () => vm.load(),
                      child: Text(loc.t('retry')),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Column(
              children: [
                if (vm.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Container(
                      width: double.infinity,
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
                  ),
                PreferencesListTile(
                  titleText: loc.t('pref_analytics'),
                  subtitleTxt:
                      "Analytics cookies help us improve our application by collecting and reporting info on how you use it. They collect information in a way that does not directly identify anyone.",
                  isActive: p.analyticsEnabled,
                  press: () => vm.toggleAnalytics(!p.analyticsEnabled),
                ),
                const Divider(height: defaultPadding * 2),
                PreferencesListTile(
                  titleText: loc.t('pref_personalization'),
                  subtitleTxt:
                      "Personalisation cookies collect information about your use of this app in order to display contect and experience that are relevant to you.",
                  isActive: p.personalizationEnabled,
                  press: () => vm.togglePersonalization(!p.personalizationEnabled),
                ),
                const Divider(height: defaultPadding * 2),
                PreferencesListTile(
                  titleText: loc.t('pref_marketing'),
                  subtitleTxt:
                      "Maarketing cookies collec information about your use of this and other apps to enable display ads and other marketing that is more relevant to you.",
                  isActive: p.marketingEnabled,
                  press: () => vm.toggleMarketing(!p.marketingEnabled),
                ),
                const Divider(height: defaultPadding * 2),
                PreferencesListTile(
                  titleText: loc.t('pref_social'),
                  subtitleTxt:
                      "These cookies are set by a range of social media services that we have added to the site to enable you to share our content with your friends and networks.",
                  isActive: p.socialMediaEnabled,
                  press: () => vm.toggleSocialMedia(!p.socialMediaEnabled),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
