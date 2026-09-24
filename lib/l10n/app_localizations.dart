import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter Neo'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsContent.
  ///
  /// In en, this message translates to:
  /// **'Settings Page Content'**
  String get settingsContent;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @langEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEn;

  /// No description provided for @langZh.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get langZh;

  /// No description provided for @welcomeHome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Home Page'**
  String get welcomeHome;

  /// No description provided for @diversifiedInvestment.
  ///
  /// In en, this message translates to:
  /// **'Diversified Investment'**
  String get diversifiedInvestment;

  /// No description provided for @fixedInvestment.
  ///
  /// In en, this message translates to:
  /// **'Fixed Investment'**
  String get fixedInvestment;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Investment Amount'**
  String get totalAmount;

  /// No description provided for @toolList.
  ///
  /// In en, this message translates to:
  /// **'Investment Tool List'**
  String get toolList;

  /// No description provided for @totalRatio.
  ///
  /// In en, this message translates to:
  /// **'Total Ratio: {ratio}%'**
  String totalRatio(Object ratio);

  /// No description provided for @toolName.
  ///
  /// In en, this message translates to:
  /// **'Tool Name'**
  String get toolName;

  /// No description provided for @ratio.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get ratio;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Estimated Investment: ￥{amount}'**
  String amount(Object amount);

  /// No description provided for @addSubTool.
  ///
  /// In en, this message translates to:
  /// **'Add Sub-category'**
  String get addSubTool;

  /// No description provided for @subTotalRatio.
  ///
  /// In en, this message translates to:
  /// **'Sub-category Total Ratio: {ratio}%'**
  String subTotalRatio(Object ratio);

  /// No description provided for @subRatioOverflow.
  ///
  /// In en, this message translates to:
  /// **'Sub-category Total Ratio: {ratio}% (Exceeds 100%)'**
  String subRatioOverflow(Object ratio);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved Successfully'**
  String get saveSuccess;

  /// No description provided for @addRow.
  ///
  /// In en, this message translates to:
  /// **'Add New Row'**
  String get addRow;

  /// No description provided for @fixedAssetName.
  ///
  /// In en, this message translates to:
  /// **'Asset Name'**
  String get fixedAssetName;

  /// No description provided for @fixedMetricValue.
  ///
  /// In en, this message translates to:
  /// **'Metric Value'**
  String get fixedMetricValue;

  /// No description provided for @fixedIndicator.
  ///
  /// In en, this message translates to:
  /// **'Indicator'**
  String get fixedIndicator;

  /// No description provided for @fixedTotalInvestment.
  ///
  /// In en, this message translates to:
  /// **'Total Investment'**
  String get fixedTotalInvestment;

  /// No description provided for @fixedInitialInvestment.
  ///
  /// In en, this message translates to:
  /// **'Initial Investment'**
  String get fixedInitialInvestment;

  /// No description provided for @fixedStrategyAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Strategy Analysis'**
  String get fixedStrategyAnalysis;

  /// No description provided for @fixedInvestmentRules.
  ///
  /// In en, this message translates to:
  /// **'Investment Rules'**
  String get fixedInvestmentRules;

  /// No description provided for @fixedMultiplier.
  ///
  /// In en, this message translates to:
  /// **'Multiplier: {value}x'**
  String fixedMultiplier(Object value);

  /// No description provided for @fixedTerm.
  ///
  /// In en, this message translates to:
  /// **'Investment Term (Months)'**
  String get fixedTerm;

  /// No description provided for @fixedMonthlyInvestment.
  ///
  /// In en, this message translates to:
  /// **'Monthly Investment'**
  String get fixedMonthlyInvestment;

  /// No description provided for @fixedSave.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get fixedSave;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileContent.
  ///
  /// In en, this message translates to:
  /// **'Profile Page Content'**
  String get profileContent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
