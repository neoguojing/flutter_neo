// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Neo';

  @override
  String get home => 'Home';

  @override
  String get investment => 'Investment';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsContent => 'Settings Page Content';

  @override
  String get language => 'Language';

  @override
  String get langEn => 'English';

  @override
  String get langZh => '中文';

  @override
  String get welcomeHome => 'Welcome to the Home Page';

  @override
  String get diversifiedInvestment => 'Diversified Investment';

  @override
  String get fixedInvestment => 'Fixed Investment';

  @override
  String get totalAmount => 'Total Investment Amount';

  @override
  String get toolList => 'Investment Tool List';

  @override
  String totalRatio(Object ratio) {
    return 'Total Ratio: $ratio%';
  }

  @override
  String get toolName => 'Tool Name';

  @override
  String get ratio => 'Ratio';

  @override
  String amount(Object amount) {
    return 'Estimated Investment: ￥$amount';
  }

  @override
  String get addSubTool => 'Add Sub-category';

  @override
  String subTotalRatio(Object ratio) {
    return 'Sub-category Total Ratio: $ratio%';
  }

  @override
  String subRatioOverflow(Object ratio) {
    return 'Sub-category Total Ratio: $ratio% (Exceeds 100%)';
  }

  @override
  String get save => 'Save';

  @override
  String get saveSuccess => 'Saved Successfully';

  @override
  String get addRow => 'Add New Row';

  @override
  String get fixedAssetName => 'Asset Name';

  @override
  String get fixedMetricValue => 'Metric Value';

  @override
  String get fixedIndicator => 'Indicator';

  @override
  String get fixedTotalInvestment => 'Total Investment';

  @override
  String get fixedInitialInvestment => 'Initial Investment';

  @override
  String get fixedStrategyAnalysis => 'Strategy Analysis';

  @override
  String get fixedInvestmentRules => 'Investment Rules';

  @override
  String fixedMultiplier(Object value) {
    return 'Multiplier: ${value}x';
  }

  @override
  String get fixedTerm => 'Investment Term (Months)';

  @override
  String get fixedMonthlyInvestment => 'Monthly Investment';

  @override
  String get fixedSave => 'Save Changes';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileContent => 'Profile Page Content';
}
