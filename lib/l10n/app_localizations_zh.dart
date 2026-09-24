// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Flutter Neo';

  @override
  String get home => '首页';

  @override
  String get investment => '投资';

  @override
  String get profile => '个人中心';

  @override
  String get settings => '设置';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsContent => '设置页面内容';

  @override
  String get language => '语言';

  @override
  String get langEn => 'English';

  @override
  String get langZh => '中文';

  @override
  String get welcomeHome => '欢迎来到首页';

  @override
  String get diversifiedInvestment => '分散投资';

  @override
  String get fixedInvestment => '定投计划';

  @override
  String get totalAmount => '总投资金额';

  @override
  String get toolList => '投资工具清单';

  @override
  String totalRatio(Object ratio) {
    return '总比例: $ratio%';
  }

  @override
  String get toolName => '工具名称';

  @override
  String get ratio => '比例';

  @override
  String amount(Object amount) {
    return '预计投入: $amount';
  }

  @override
  String get addSubTool => '添加子类细分';

  @override
  String subTotalRatio(Object ratio) {
    return '子类总比例: $ratio%';
  }

  @override
  String subRatioOverflow(Object ratio) {
    return '子类总比例: $ratio% (超出 100%)';
  }

  @override
  String get save => '保存';

  @override
  String get saveSuccess => '保存成功';

  @override
  String get addRow => '添加新行';

  @override
  String get fixedAssetName => '资产名称';

  @override
  String get fixedMetricValue => '参考指标值';

  @override
  String get fixedIndicator => '指标名称';

  @override
  String get fixedTotalInvestment => '目标总金额';

  @override
  String get fixedInitialInvestment => '初始金额';

  @override
  String get fixedStrategyAnalysis => '策略分析';

  @override
  String get fixedInvestmentRules => '投资规则';

  @override
  String fixedMultiplier(Object value) {
    return '倍数: ${value}x';
  }

  @override
  String get fixedTerm => '投资期限 (月)';

  @override
  String get fixedMonthlyInvestment => '每月投资额';

  @override
  String get fixedSave => '保存修改';

  @override
  String get profileTitle => '个人中心';

  @override
  String get profileContent => '个人中心页面内容';
}
