import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_neo/l10n/app_localizations.dart';
import 'package:flutter_neo/features/main/ui/main_shell.dart';
import 'package:provider/provider.dart';
import 'core/repositories/investment_repository_impl.dart';
import 'features/diversified_investment/provider/investment_provider.dart';
import 'features/settings/provider/locale_provider.dart';
import 'features/fixed_investment/provider/fixed_investment_provider.dart';
import 'core/repositories/fixed_investment_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: InvestmentRepositoryImpl()),
        ChangeNotifierProvider(
          create: (context) => InvestmentProvider(
            context.read<InvestmentRepositoryImpl>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (context) => FixedInvestmentProvider(
            FixedInvestmentRepositoryImpl(),
          )..loadAssets(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Flutter Neo',
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}
