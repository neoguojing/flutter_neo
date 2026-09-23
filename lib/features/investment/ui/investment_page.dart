import 'package:flutter/material.dart';
import 'package:flutter_neo/l10n/app_localizations.dart';
import 'package:flutter_neo/features/diversified_investment/ui/diversified_investment_page.dart';
import 'package:flutter_neo/features/fixed_investment/ui/fixed_investment_page.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.investment),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.diversifiedInvestment),
              Tab(text: l10n.fixedInvestment),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DiversifiedInvestmentPage(),
            FixedInvestmentPage(),
          ],
        ),
      ),
    );
  }
}