import 'package:flutter/material.dart';
import 'package:flutter_neo/l10n/app_localizations.dart';
import 'package:flutter_neo/features/settings/provider/locale_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(l10n.language),
            trailing: DropdownButton<Locale>(
              value: localeProvider.locale,
              items: [
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(l10n.langEn),
                ),
                DropdownMenuItem(
                  value: const Locale('zh'),
                  child: Text(l10n.langZh),
                ),
              ],
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  localeProvider.setLocale(newLocale);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
