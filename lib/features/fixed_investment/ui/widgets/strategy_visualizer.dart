import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../provider/fixed_investment_provider.dart';
import '../../../../l10n/app_localizations.dart';

class StrategyVisualizer extends StatefulWidget {
  final FixedInvestmentAsset asset;

  const StrategyVisualizer({super.key, required this.asset});

  @override
  State<StrategyVisualizer> createState() => _StrategyVisualizerState();
}

class _StrategyVisualizerState extends State<StrategyVisualizer> {
  late double _simulatedMetric;

  @override
  void initState() {
    super.initState();
    _simulatedMetric = widget.asset.currentMetric;
  }

  @override
  void didUpdateWidget(covariant StrategyVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.asset.currentMetric != oldWidget.asset.currentMetric) {
      setState(() {
        _simulatedMetric = widget.asset.currentMetric;
      });
    }
  }

  double _calculateAmount(double metric) {
    double multiplier = 1.0;
    for (var rule in widget.asset.rules) {
      if (metric >= rule.min && metric < rule.max) {
        multiplier = rule.multiplier;
        break;
      }
    }
    double baseMonthly = (widget.asset.totalInvestment - widget.asset.initialInvestment) / widget.asset.totalMonths;
    return baseMonthly * multiplier;
  }

  String _formatCurrency(double amount, String market) {
    // Determine currency code based on market
    String currencyCode = (market == 'ashare') ? 'CNY' : 'USD';
    // Use simpleCurrency to get the localized symbol and formatting
    final formatter = NumberFormat.simpleCurrency(name: currencyCode);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // 1. 阶梯图 (显示倍数映射)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateStepSpots(),
                    isCurved: false,
                    barWidth: 3,
                    color: Colors.blueAccent,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 2. 模拟计算器
        Row(
          children: [
            Text(l10n.fixedMetricValue, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Expanded(
              child: Slider(
                value: _simulatedMetric,
                min: 0,
                max: 100,
                divisions: 100,
                label: "${_simulatedMetric.toStringAsFixed(1)}%",
                onChanged: (val) => setState(() => _simulatedMetric = val),
              ),
            ),
            Text("${_simulatedMetric.toStringAsFixed(1)}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.fixedMonthlyInvestment, style: const TextStyle(fontSize: 13)),
              Text(
                l10n.amount(_formatCurrency(_calculateAmount(_simulatedMetric), widget.asset.market)),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateStepSpots() {
    List<FlSpot> spots = [];
    // 为了形成阶梯状，每个规则需要两个点：(min, val) 和 (max, val)
    for (var rule in widget.asset.rules) {
      double val = rule.multiplier;
      spots.add(FlSpot(rule.min.toDouble(), val));
      spots.add(FlSpot(rule.max.toDouble(), val));
    }
    spots.sort((a, b) => a.x.compareTo(b.x));
    return spots;
  }
}
