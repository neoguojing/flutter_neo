import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_neo/l10n/app_localizations.dart';
import '../../provider/fixed_investment_provider.dart';
import 'strategy_visualizer.dart';

class AssetDetailSheet extends StatelessWidget {
  final FixedInvestmentAsset asset;

  const AssetDetailSheet({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<FixedInvestmentProvider>(context, listen: false);

    return StatefulBuilder(
      builder: (context, setSheetState) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  asset.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // 1. 基础配置区
                _buildSectionTitle(l10n.fixedAssetName, Icons.settings),
                const SizedBox(height: 12),
                _buildTextField(
                  label: l10n.fixedAssetName,
                  controller: TextEditingController(text: asset.name),
                  onChanged: (val) => asset.name = val,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: l10n.fixedMetricValue,
                        controller: TextEditingController(text: asset.currentMetric.toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => asset.currentMetric = double.tryParse(val) ?? 0.0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        label: l10n.fixedIndicator,
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
                      child: _buildTextField(
                        label: l10n.fixedTotalInvestment,
                        controller: TextEditingController(text: asset.totalInvestment.toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => asset.totalInvestment = double.tryParse(val) ?? 0.0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        label: l10n.fixedInitialInvestment,
                        controller: TextEditingController(text: asset.initialInvestment.toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => asset.initialInvestment = double.tryParse(val) ?? 0.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: l10n.fixedTerm,
                  controller: TextEditingController(text: asset.totalMonths.toString()),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => asset.totalMonths = int.tryParse(val) ?? 1,
                ),

                const Divider(height: 40),

                // 2. 可视化分析区
                _buildSectionTitle(l10n.fixedStrategyAnalysis, Icons.analytics),
                const SizedBox(height: 12),
                StrategyVisualizer(asset: asset),

                const Divider(height: 40),

                // 3. 规则细节区
                _buildSectionTitle(l10n.fixedInvestmentRules, Icons.list),
                const SizedBox(height: 12),
                ...asset.rules.map((rule) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text("${rule.min}% → ${rule.max}%")),
                      const SizedBox(width: 10),
                      Text(l10n.fixedMultiplier(rule.multiplier.toString()), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )).toList(),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.updateAsset(asset);
                      provider.saveAsset(asset);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.fixedSave, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
