import 'package:flutter/material.dart';
import 'package:flutter_neo/features/fixed_investment/provider/fixed_investment_provider.dart';
import 'package:flutter_neo/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'widgets/strategy_visualizer.dart';

class FixedInvestmentPage extends StatelessWidget {
  const FixedInvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FixedInvestmentProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fixedInvestment),
        actions: [
          IconButton(
            tooltip: '添加投资工具',
            icon: const Icon(Icons.add_chart_outlined),
            onPressed: () => _showAddToolDialog(context),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '为每个投资标的设置指标区间与定投倍率。配置会在保存后自动恢复。',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ...provider.assets.map(
                  (asset) => FixedInvestmentCard(key: ValueKey(asset.id), asset: asset),
                ),
                OutlinedButton.icon(
                  onPressed: provider.addAsset,
                  icon: const Icon(Icons.add),
                  label: const Text('新增定投标的'),
                ),
              ],
            ),
    );
  }

  Future<void> _showAddToolDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final marketController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('添加投资工具'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: '工具名称'),
            ),
            TextField(
              controller: marketController,
              decoration: const InputDecoration(labelText: '市场（可选）'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              await context.read<FixedInvestmentProvider>().addTool(
                    nameController.text,
                    marketController.text,
                  );
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
    nameController.dispose();
    marketController.dispose();
  }
}

class FixedInvestmentCard extends StatefulWidget {
  final FixedInvestmentAsset asset;

  const FixedInvestmentCard({super.key, required this.asset});

  @override
  State<FixedInvestmentCard> createState() => _FixedInvestmentCardState();
}

class _FixedInvestmentCardState extends State<FixedInvestmentCard> {
  late final TextEditingController _metricController;
  late final TextEditingController _totalController;
  late final TextEditingController _initialController;
  late final TextEditingController _monthsController;

  @override
  void initState() {
    super.initState();
    _metricController = TextEditingController(text: widget.asset.currentMetric.toString());
    _totalController = TextEditingController(text: widget.asset.totalInvestment.toString());
    _initialController = TextEditingController(text: widget.asset.initialInvestment.toString());
    _monthsController = TextEditingController(text: widget.asset.totalMonths.toString());
  }

  @override
  void dispose() {
    _metricController.dispose();
    _totalController.dispose();
    _initialController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<FixedInvestmentProvider>();
    final l10n = AppLocalizations.of(context)!;
    final asset = widget.asset;
    final selectedToolId = provider.tools.any((tool) => tool.id == asset.toolId)
        ? asset.toolId
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedToolId,
                    decoration: const InputDecoration(labelText: '投资工具'),
                    items: provider.tools
                        .map((tool) => DropdownMenuItem(value: tool.id, child: Text(tool.name)))
                        .toList(),
                    onChanged: (toolId) {
                      if (toolId == null) return;
                      final tool = provider.tools.firstWhere((item) => item.id == toolId);
                      setState(() {
                        asset.toolId = tool.id;
                        asset.name = tool.name;
                        asset.market = tool.market;
                      });
                    },
                  ),
                ),
                IconButton(
                  tooltip: '删除标的',
                  onPressed: () => provider.removeAsset(asset.id),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _numberField(
                    controller: _metricController,
                    label: l10n.fixedMetricValue,
                    onChanged: (value) => asset.currentMetric = value,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: FixedInvestmentProvider.supportedIndicators.contains(asset.indicator)
                        ? asset.indicator
                        : FixedInvestmentProvider.supportedIndicators.first,
                    decoration: InputDecoration(labelText: l10n.fixedIndicator),
                    items: FixedInvestmentProvider.supportedIndicators
                        .map((indicator) => DropdownMenuItem(value: indicator, child: Text(_indicatorName(indicator))))
                        .toList(),
                    onChanged: (indicator) => setState(() => asset.indicator = indicator!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _numberField(controller: _totalController, label: l10n.fixedTotalInvestment, onChanged: (value) => asset.totalInvestment = value)),
                const SizedBox(width: 12),
                Expanded(child: _numberField(controller: _initialController, label: l10n.fixedInitialInvestment, onChanged: (value) => asset.initialInvestment = value)),
              ],
            ),
            const SizedBox(height: 12),
            _numberField(
              controller: _monthsController,
              label: l10n.fixedTerm,
              integer: true,
              onChanged: (value) => asset.totalMonths = value.round().clamp(1, 1000).toInt(),
            ),
            const SizedBox(height: 16),
            _buildRules(),
            const SizedBox(height: 8),
            StrategyVisualizer(asset: asset),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  provider.updateAsset(asset);
                  await provider.saveAsset(asset);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saveSuccess)));
                  }
                },
                icon: const Icon(Icons.save_outlined),
                label: Text(l10n.fixedSave),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberField({required TextEditingController controller, required String label, required ValueChanged<double> onChanged, bool integer = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.numberWithOptions(decimal: !integer),
      onChanged: (text) => onChanged(double.tryParse(text) ?? 0),
    );
  }

  Widget _buildRules() {
    final rules = widget.asset.rules;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('规则区间与定投倍率', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...rules.asMap().entries.map((entry) => _RuleRow(
              key: ValueKey('${widget.asset.id}-${entry.key}'),
              rule: entry.value,
              onDelete: rules.length == 1 ? null : () => setState(() => rules.removeAt(entry.key)),
            )),
        TextButton.icon(
          onPressed: () => setState(() => rules.add(InvestmentRule(min: 0, max: 100, multiplier: 1))),
          icon: const Icon(Icons.add),
          label: const Text('新增规则行'),
        ),
      ],
    );
  }

  String _indicatorName(String indicator) => switch (indicator) {
        'pe_percentile' => '估值百分位',
        'forward_pe_percentile' => '均线偏离度',
        'shiller_pe_ratio' => '股债性价比',
        _ => indicator,
      };
}

class _RuleRow extends StatelessWidget {
  final InvestmentRule rule;
  final VoidCallback? onDelete;

  const _RuleRow({super.key, required this.rule, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: _field('下限', rule.min, (value) => rule.min = value)),
          const SizedBox(width: 8),
          Expanded(child: _field('上限', rule.max, (value) => rule.max = value)),
          const SizedBox(width: 8),
          Expanded(child: _field('倍率', rule.multiplier, (value) => rule.multiplier = value)),
          IconButton(
            tooltip: '删除规则',
            onPressed: onDelete,
            icon: const Icon(Icons.remove_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, double value, ValueChanged<double> onChanged) => TextFormField(
        initialValue: value.toString(),
        decoration: InputDecoration(labelText: label, isDense: true),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (text) => onChanged(double.tryParse(text) ?? 0),
      );
}
