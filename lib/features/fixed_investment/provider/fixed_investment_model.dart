import 'package:flutter/material.dart';

class FixedInvestmentAsset {
  final String name;
  final String market;
  final double currentMetric;
  final String indicator;
  final double totalInvestment;
  final double initialInvestment;
  final int totalMonths;
  final List<InvestmentRule> rules;

  FixedInvestmentAsset({
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
    // Find the multiplier based on the current metric
    double multiplier = 1.0;
    for (var rule in rules) {
      if (currentMetric >= rule.min && currentMetric < rule.max) {
        multiplier = rule.multiplier;
        break;
      }
    }

    // Formula: (Total Investment - Initial Investment) / Total Months * Multiplier
    // If multiplier is 1.0, it's standard average.
    // If metric is very low (multiplier high), we invest more now.
    double baseMonthly = (totalInvestment - initialInvestment) / totalMonths;
    return baseMonthly * multiplier;
  }
}

class InvestmentRule {
  final double min;
  final double max;
  final double multiplier;

  InvestmentRule({
    required this.min,
    required this.max,
    required this.multiplier,
  });
}
