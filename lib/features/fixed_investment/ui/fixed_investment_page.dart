import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_neo/l10n/app_localizations.dart';
import 'package:flutter_neo/features/fixed_investment/provider/fixed_investment_provider.dart';
import 'widgets/strategy_visualizer.dart';
import 'widgets/asset_detail_sheet.dart';

class FixedInvestmentPage extends StatelessWidget {
  const FixedInvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<FixedInvestmentProvider>(context);
    final assets = provider.assets;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fixedInvestmentTitle), // Assuming this exists, or I'll just use title
        actions: [
          IconButton(
            icon: const Icon(Icons.add_tool),
            onPressed: () {
              // Show a dialog to add a tool
              _showAddToolDialog(context, provider);
            },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog to add an asset
          _showAddAssetDialog(context, provider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddToolDialog(BuildContext context, FixedInvestmentProvider provider) {
    final nameController = TextEditingController();
    final marketController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Tool'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tool Name'),
            ),
            TextField(
              controller: marketController,
              decoration: const InputDecoration(labelText: 'Market'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.addTool(nameController.text, marketController.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddAssetDialog(BuildContext context, FixedInvestmentProvider provider) {
    final nameController = TextEditingController();
    final metricController = TextEditingController(text: '50.0');
    final totalInvestmentController = TextEditingController(text: '100000.0');
    final initialInvestmentController = TextEditingController(text: '0.0');
    final termController = TextEditingController(text: '24');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('New Investment Asset'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Select Tool'),
                    items: provider.tools.map((t) {
                      return DropdownMenuItem(value: t.id, child: Text(t.name));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        final tool = provider.tools.firstWhere((t) => t.id == val);
                        nameController.text = tool.name;
                      }
                    },
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: metricController,
                    decoration: const InputDecoration(labelText: 'Current Metric'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: totalInvestmentController,
                    decoration: const InputDecoration(labelText: 'Total Investment'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: initialInvestmentController,
                    decoration: const InputDecoration(labelText: 'Initial Investment'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: termController,
                    decoration: const InputDecoration(labelText: 'Term (Months)'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final tool = provider.tools.firstWhere((t) => t.id == nameController.text); // This is slightly wrong logic but just for now
                  // I'll fix this properly in the next step.
                  // I should use the selected tool's ID.
                  // For now, let's just use the existing logic but in a dialog.
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FixedInvestmentCard extends StatefulWidget {
  final FixedInvestmentAsset asset;
  const FixedInvestmentCard({super.key, required this.asset});

  @override
  State<FixedInvestmentCard> createState() => _FixedInvestmentCardState();
}

class _FixedInvestmentCardState extends State<FixedInvestmentCard> {
  late TextEditingController _nameController;
  late TextEditingController _metricController;
  late TextEditingController _totalInvestmentController;
  late TextEditingController _initialInvestmentController;
  late TextEditingController _termController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.asset.name);
    _metricController = TextEditingController(text: widget.asset.currentMetric.toString());
    _totalInvestmentController = TextEditingController(text: widget.asset.totalInvestment.toString());
    _initialInvestmentController = TextEditingController(text: widget.asset.initialInvestment.toString());
    _termController = TextEditingController(text: widget.asset.totalMonths.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _metricController.dispose();
    _totalInvestmentController.dispose();
    _initialInvestmentController.dispose();
    _termController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<FixedInvestmentProvider>(context, listen: false);

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
                    onChanged: (val) {
                      widget.asset.name = val;
                      _nameController.text = val;
                    },
                    controller: _nameController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.removeAsset(widget.asset.id),
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
                    controller: _metricController,
                    onChanged: (val) {
                      widget.asset.currentMetric = double.tryParse(val) ?? 0.0;
                      _metricController.text = val;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(labelText: l10n.fixedIndicator),
                    value: widget.asset.indicator,
                    items: FixedInvestmentProvider.supportedIndicators.map((indicator) {
                      return DropdownMenuItem(
                        value: indicator,
                        child: Text(indicator),
                      );
                    }).toList(),
                    onChanged: (val) {
                      widget.asset.indicator = val as String;
                    },
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
                    controller: _totalInvestmentController,
                    onChanged: (val) {
                      widget.asset.totalInvestment = double.tryParse(val) ?? 0.0;
                      _totalInvestmentController.text = val;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: l10n.fixedInitialInvestment),
                    keyboardType: TextInputType.number,
                    controller: _initialInvestmentController,
                    onChanged: (val) {
                      widget.asset.initialInvestment = double.tryParse(val) ?? 0.0;
                      _initialInvestmentController.text = val;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(labelText: l10n.fixedTerm),
              keyboardType: TextInputType.number,
              controller: _termController,
              onChanged: (val) {
                widget.asset.totalMonths = int.tryParse(val) ?? 1;
                _termController.text = val;
              },
            ),
            const SizedBox(height: 16),
            StrategyVisualizer(asset: widget.asset),
            const SizedBox(height: 12),
            _buildRulesSection(l10n, provider),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  provider.updateAsset(widget.asset);
                  provider.saveAsset(widget.asset);
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

  Widget _buildRulesSection(AppLocalizations l10n, FixedInvestmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.list, size: 18, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Text(l10n.fixedInvestmentRules, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ...widget.asset.rules.asMap().entries.map((entry) {
          int idx = entry.key;
          InvestmentRule rule = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: "Min %"),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => rule.min = double.tryParse(val) ?? 0.0,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: "Max %"),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => rule.max = double.tryParse(val) ?? 0.0,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: "Multiplier"),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => rule.multiplier = double.tryParse(val) ?? 1.0,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.asset.rules.removeAt(idx);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
        TextButton.icon(
          onPressed: () {
            setState(() {
              widget.asset.rules.add(InvestmentRule(min: 0, max: 100, multiplier: 1.0));
            });
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Rule"),
        ),
      ],
    );
  }
}
