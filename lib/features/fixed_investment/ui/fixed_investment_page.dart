import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_neo/l10n/app_localizations.dart';
import 'package:flutter_neo/features/fixed_investment/provider/fixed_investment_provider.dart';
import 'widgets/strategy_visualizer.dart';

class FixedInvestmentPage extends StatelessWidget {
  const FixedInvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<FixedInvestmentProvider>(context);
    final assets = provider.assets;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fixedInvestment),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => provider.addAsset(),
          ),
        ],
      ),
      body: provider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              return FixedInvestmentCard(asset: assets[index]);
            },
          ),
    );
  }
}

class FixedInvestmentCard extends StatelessWidget {
  final FixedInvestmentAsset asset;
  const FixedInvestmentCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<FixedInvestmentProvider>(context, listen: false);
    final monthlyAmount = asset.calculateMonthlyInvestment();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: l10n.fixedAssetName),
                    onChanged: (val) => asset.name = val,
                    controller: TextEditingController(text: asset.name),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.removeAsset(asset.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: l10n.fixedMetricValue),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: asset.currentMetric.toString()),
                    onChanged: (val) => asset.currentMetric = double.tryParse(val) ?? 0.0,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: l10n.fixedIndicator),
                    controller: TextEditingController(text: asset.indicator),
                    onChanged: (val) => asset.indicator = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: l10n.fixedTotalInvestment),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: asset.totalInvestment.toString()),
                    onChanged: (val) => asset.totalInvestment = double.tryParse(val) ?? 0.0,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: l10n.fixedInitialInvestment),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: asset.initialInvestment.toString()),
                    onChanged: (val) => asset.initialInvestment = double.tryParse(val) ?? 0.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(labelText: l10n.fixedTerm),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: asset.totalMonths.toString()),
              onChanged: (val) => asset.totalMonths = int.tryParse(val) ?? 1,
            ),
            const SizedBox(height: 16),
            StrategyVisualizer(asset: asset),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.fixedMonthlyInvestment, style: Theme.of(context).textTheme.titleMedium),
                  Text('￥${monthlyAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  provider.updateAsset(asset);
                  provider.saveAsset(asset);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
                },
                child: Text(l10n.fixedSave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
