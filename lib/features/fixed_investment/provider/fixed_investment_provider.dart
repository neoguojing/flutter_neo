import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/repositories/fixed_investment_repository.dart';

class FixedInvestmentAsset {
  String id;
  String toolId; // Changed from name to toolId
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
    required this.toolId,
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
  List<InvestmentToolModel> _tools = [];
  bool _isLoading = false;

  FixedInvestmentProvider(this._repository);

  List<FixedInvestmentAsset> get assets => _assets;
  List<InvestmentToolModel> get tools => _tools;
  bool get isLoading => _isLoading;

  static const List<String> supportedIndicators = [
    'pe_percentile',
    'forward_pe_percentile',
    'shiller_pe_ratio',
  ];

  Future<void> loadAssets() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Load tools first
      _tools = await _repository.getAllTools();
      if (_tools.isEmpty) {
        await _loadDefaultTools();
      }

      final models = await _repository.getAllFixedAssets();
      _assets = models.map((m) => FixedInvestmentAsset(
        id: m.id,
        toolId: _toolIdFor(m),
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
        await _loadDefaultAssets();
      }
    } catch (e) {
      debugPrint('Error loading assets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _toolIdFor(FixedInvestmentAssetModel model) {
    if (model.toolId.isNotEmpty && _tools.any((tool) => tool.id == model.toolId)) {
      return model.toolId;
    }
    return _tools
        .where((tool) => tool.name == model.name)
        .map((tool) => tool.id)
        .firstOrNull ??
        (_tools.isNotEmpty ? _tools.first.id : '');
  }

  Future<void> _loadDefaultTools() async {
    final defaultTools = [
      InvestmentToolModel(id: '1', name: '中证A500', market: 'ashare'),
      InvestmentToolModel(id: '2', name: '科创50', market: 'ashare'),
      InvestmentToolModel(id: '3', name: '标普500', market: 'us'),
      InvestmentToolModel(id: '4', name: '纳斯达克100', market: 'us'),
    ];
    for (var tool in defaultTools) {
      await _repository.saveTool(tool);
    }
    _tools = defaultTools;
  }

  Future<void> _loadDefaultAssets() async {
    _assets = [
      _defaultAsset(
        toolId: '1',
        name: '中证A500',
        market: 'ashare',
        currentMetric: 69.09,
        totalInvestment: 320000,
        initialInvestment: 30000,
        rules: const [
          (0, 20, 2.0),
          (20, 30, 1.5),
          (30, 50, 1.0),
          (50, 80, 0.5),
          (80, 100, 0.3),
        ],
      ),
      _defaultAsset(
        toolId: '2',
        name: '科创50',
        market: 'ashare',
        currentMetric: 50,
        totalInvestment: 100000,
        initialInvestment: 0,
        rules: const [
          (0, 20, 2.0),
          (20, 40, 1.5),
          (40, 60, 1.0),
          (60, 80, 0.7),
          (80, 100, 0.5),
        ],
      ),
      _defaultAsset(
        toolId: '3',
        name: '标普500',
        market: 'us',
        currentMetric: 40.73,
        indicator: 'shiller_pe_ratio',
        totalInvestment: 230000,
        initialInvestment: 5600,
        rules: const [
          (0, 25, 2.0),
          (25, 30, 1.5),
          (30, 35, 1.0),
          (35, 40, 0.6),
          (40, 100, 0.4),
        ],
      ),
      _defaultAsset(
        toolId: '4',
        name: '纳斯达克100',
        market: 'us',
        currentMetric: 21.7,
        indicator: 'forward_pe_percentile',
        totalInvestment: 150000,
        initialInvestment: 4200,
        rules: const [
          (0, 20, 2.0),
          (20, 40, 1.5),
          (40, 60, 1.0),
          (60, 80, 0.5),
          (80, 100, 0.3),
        ],
      ),
    ];
    for (final asset in _assets) {
      await saveAsset(asset);
    }
  }

  FixedInvestmentAsset _defaultAsset({
    required String toolId,
    required String name,
    required String market,
    required double currentMetric,
    required double totalInvestment,
    required double initialInvestment,
    required List<(double, double, double)> rules,
    String indicator = 'pe_percentile',
  }) {
    return FixedInvestmentAsset(
      id: const Uuid().v4(),
      toolId: toolId,
      name: name,
      market: market,
      currentMetric: currentMetric,
      indicator: indicator,
      totalInvestment: totalInvestment,
      initialInvestment: initialInvestment,
      totalMonths: 24,
      rules: [
        for (final rule in rules)
          InvestmentRule(min: rule.$1, max: rule.$2, multiplier: rule.$3),
      ],
    );
  }

  void updateAsset(FixedInvestmentAsset asset) {
    final index = _assets.indexWhere((a) => a.id == asset.id);
    if (index != -1) {
      _assets[index] = asset;
      notifyListeners();
    }
  }

  Future<void> saveAsset(FixedInvestmentAsset asset) async {
    // Resolve toolId to name for the persistence model
    final tool = _tools.firstWhere(
      (t) => t.id == asset.toolId,
      orElse: () => InvestmentToolModel(id: 'unknown', name: 'Unknown', market: 'unknown'),
    );

    final model = FixedInvestmentAssetModel(
      id: asset.id,
      toolId: asset.toolId,
      name: tool.name,
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
    final firstTool = _tools.isNotEmpty ? _tools.first : InvestmentToolModel(id: 'temp', name: '新资产', market: 'ashare');
    final newAsset = FixedInvestmentAsset(
      id: const Uuid().v4(),
      toolId: firstTool.id,
      name: firstTool.name,
      market: firstTool.market,
      currentMetric: 50.0,
      indicator: 'pe_percentile',
      totalInvestment: 100000.0,
      initialInvestment: 0.0,
      totalMonths: 24,
      rules: [InvestmentRule(min: 0, max: 100, multiplier: 1.0)],
    );
    _assets.add(newAsset);
    await saveAsset(newAsset);
    notifyListeners();
  }

  Future<void> removeAsset(String id) async {
    _assets.removeWhere((a) => a.id == id);
    await _repository.deleteFixedAsset(id);
    notifyListeners();
  }

  // Tool management
  Future<void> addTool(String name, String market) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;
    final tool = InvestmentToolModel(
      id: const Uuid().v4(),
      name: trimmedName,
      market: market.trim().isEmpty ? 'custom' : market.trim(),
    );
    await _repository.saveTool(tool);
    _tools.add(tool);
    notifyListeners();
  }

  Future<void> removeTool(String id) async {
    await _repository.deleteTool(id);
    _tools.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
