import 'package:flutter/material.dart';

abstract class IFixedInvestmentRepository {
  Future<List<FixedInvestmentAssetModel>> getAllFixedAssets();
  Future<void> saveFixedAsset(FixedInvestmentAssetModel asset);
  Future<void> deleteFixedAsset(String id);

  Future<List<InvestmentToolModel>> getAllTools();
  Future<void> saveTool(InvestmentToolModel tool);
  Future<void> deleteTool(String id);
}

class InvestmentToolModel {
  final String id;
  final String name;
  final String market;

  InvestmentToolModel({required this.id, required this.name, required this.market});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'market': market};
  factory InvestmentToolModel.fromJson(Map<String, dynamic> json) =>
      InvestmentToolModel(id: json['id'], name: json['name'], market: json['market']);
}

class FixedInvestmentAssetModel {
  final String id;
  final String name;
  final String market;
  final double currentMetric;
  final String indicator;
  final double totalInvestment;
  final double initialInvestment;
  final int totalMonths;
  final List<InvestmentRuleModel> rules;

  FixedInvestmentAssetModel({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'market': market,
      'currentMetric': currentMetric,
      'indicator': indicator,
      'totalInvestment': totalInvestment,
      'initialInvestment': initialInvestment,
      'totalMonths': totalMonths,
      'rules': rules.map((r) => r.toJson()).toList(),
    };
  }

  factory FixedInvestmentAssetModel.fromJson(Map<String, dynamic> json) {
    return FixedInvestmentAssetModel(
      id: json['id'],
      name: json['name'],
      market: json['market'],
      currentMetric: (json['currentMetric'] as num).toDouble(),
      indicator: json['indicator'],
      totalInvestment: (json['totalInvestment'] as num).toDouble(),
      initialInvestment: (json['initialInvestment'] as num).toDouble(),
      totalMonths: json['totalMonths'] as int,
      rules: (json['rules'] as List).map((r) => InvestmentRuleModel.fromJson(r)).toList(),
    );
  }
}

class InvestmentRuleModel {
  final double min;
  final double max;
  final double multiplier;

  InvestmentRuleModel({required this.min, required this.max, required this.multiplier});

  Map<String, dynamic> toJson() => {'min': min, 'max': max, 'multiplier': multiplier};
  factory InvestmentRuleModel.fromJson(Map<String, dynamic> json) =>
    InvestmentRuleModel(min: json['min'], max: json['max'], multiplier: json['multiplier']);
}
