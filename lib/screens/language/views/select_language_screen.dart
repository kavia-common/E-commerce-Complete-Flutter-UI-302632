import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/account/viewmodels/locale_view_model.dart';
import 'package:shop/l10n/app_localizations.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('language_title')),
      ),
      body: Consumer<LocaleViewModel>(
        builder: (context, vm, _) {
          final String? code = vm.locale?.languageCode;

          return ListView(
            children: [
              RadioListTile<String>(
                value: 'en',
                groupValue: code ?? 'en',
                onChanged: (value) {
                  if (value == null) return;
                  vm.setLocale(Locale(value));
                },
                title: Text(loc.t('language_english')),
              ),
            ],
          );
        },
      ),
    );
  }
}
