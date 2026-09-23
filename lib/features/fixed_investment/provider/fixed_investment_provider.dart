import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/repositories/fixed_investment_repository.dart';

class FixedInvestmentAsset {
  String id;
  String name;
  String market;
  double currentMetric;
  String indicator;
  double totalInvestment;
  double initialInvestment;
  int totalMonths;
  List<InvestmentRule> rules;

  FixedInvestmentAsset({
    required this.id,
    required this.name,
    required this.market,
    required this.currentMetric,
    required this.indicator,
    required this.totalInvestment,
    required this.initialInvestment,
    required this.totalMonths,
    required this.rules,
  });

  double calculateMonthlyInvestment() {
    double multiplier = 1.0;
    for (var rule in rules) {
      if (currentMetric >= rule.min && currentMetric < rule.max) {
        multiplier = rule.multiplier;
        break;
      }
    }
    double baseMonthly = (totalInvestment - initialInvestment) / totalMonths;
    return baseMonthly * multiplier;
  }
}

class InvestmentRule {
  double min;
  double max;
  double multiplier;

  InvestmentRule({required this.min, required this.max, required this.multiplier});
}

class FixedInvestmentProvider with ChangeNotifier {
  final IFixedInvestmentRepository _repository;
  List<FixedInvestmentAsset> _assets = [];
  bool _isLoading = false;

  FixedInvestmentProvider(this._repository);

  List<FixedInvestmentAsset> get assets => _assets;
  bool get isLoading => _isLoading;

  Future<void> loadAssets() async {
    _isLoading = true;
    notifyListeners();
    try {
      final models = await _repository.getAllFixedAssets();
      _assets = models.map((m) => FixedInvestmentAsset(
        id: m.id,
        name: m.name,
        market: m.market,
        currentMetric: m.currentMetric,
        indicator: m.indicator,
        totalInvestment: m.totalInvestment,
        initialInvestment: m.initialInvestment,
        totalMonths: m.totalMonths,
        rules: m.rules.map((r) => InvestmentRule(min: r.min, max: r.max, multiplier: r.multiplier)).toList(),
      )).toList();

      if (_assets.isEmpty) {
        _loadDefaultAssets();
      }
    } catch (e) {
      debugPrint('Error loading assets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadDefaultAssets() {
    _assets = [
      FixedInvestmentAsset(
        id: const Uuid().v4(),
        name: '中证A500',
        market: 'ashare',
        currentMetric: 69.09,
        indicator: 'pe_percentile',
        totalInvestment: 320000.0,
        initialInvestment: 30000.0,
        totalMonths: 24,
        rules: [
          InvestmentRule(min: 0, max: 20, multiplier: 2.0),
          InvestmentRule(min: 20, max: 30, multiplier: 1.5),
          InvestmentRule(min: 30, max: 50, multiplier: 1.0),
          InvestmentRule(min: 50, max: 80, multiplier: 0.5),
          InvestmentRule(min: 80, max: 100, multiplier: 0.3),
        ],
      ),
      // ... other defaults can be added here
    ];
  }

  void updateAsset(FixedInvestmentAsset asset) {
    final index = _assets.indexWhere((a) => a.id == asset.id);
    if (index != -1) {
      _assets[index] = asset;
      notifyListeners();
    }
  }

  Future<void> saveAsset(FixedInvestmentAsset asset) async {
    final model = FixedInvestmentAssetModel(
      id: asset.id,
      name: asset.name,
      market: asset.market,
      currentMetric: asset.currentMetric,
      indicator: asset.indicator,
      totalInvestment: asset.totalInvestment,
      initialInvestment: asset.initialInvestment,
      totalMonths: asset.totalMonths,
      rules: asset.rules.map((r) => InvestmentRuleModel(min: r.min, max: r.max, multiplier: r.multiplier)).toList(),
    );
    await _repository.saveFixedAsset(model);
  }

  Future<void> addAsset() async {
    final newAsset = FixedInvestmentAsset(
      id: const Uuid().v4(),
      name: '新资产',
      market: 'ashare',
      currentMetric: 50.0,
      indicator: 'pe_percentile',
      totalInvestment: 100000.0,
      initialInvestment: 0.0,
      totalMonths: 24,
      rules: [InvestmentRule(min: 0, max: 100, multiplier: 1.0)],
    );
    _assets.add(newAsset);
    notifyListeners();
  }

  Future<void> removeAsset(String id) async {
    _assets.removeWhere((a) => a.id == id);
    await _repository.deleteFixedAsset(id);
    notifyListeners();
  }
}
