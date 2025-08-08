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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// Label for about section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Label for add action
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Main description of the application
  ///
  /// In en, this message translates to:
  /// **'Listenor is a powerful tool for managing and interacting with your audio content.'**
  String get appDescription;

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Listenor'**
  String get appTitle;

  /// Label for cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for clear action
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Confirmation message before deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get confirmDelete;

  /// Label for password confirmation field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Label for copy to clipboard action
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// Label for dark mode theme option
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Label for disabling notifications
  ///
  /// In en, this message translates to:
  /// **'Disable Notifications'**
  String get disableNotifications;

  /// Label for edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Label for email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for enabling notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Prompt for login action
  ///
  /// In en, this message translates to:
  /// **'Have an account? Login'**
  String get haveAccount;

  /// Label for help section
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Label for home section
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for language settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for light mode theme option
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Loading state message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Label for login action
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Label for login or sign up action
  ///
  /// In en, this message translates to:
  /// **'Login / Sign up'**
  String get loginOrSignUp;

  /// Label for logout action
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Label for more actions menu
  ///
  /// In en, this message translates to:
  /// **'More Actions'**
  String get moreAction;

  /// Label for my subscription menu item
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get mySubscription;

  /// Negative response
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Prompt for sign up action
  ///
  /// In en, this message translates to:
  /// **'No account? Sign up'**
  String get noAccount;

  /// Message shown when no data is available
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// Label for notifications section
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Prompt for login with other accounts
  ///
  /// In en, this message translates to:
  /// **'Or login with those accounts'**
  String get orLoginWithThose;

  /// Label for password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for register action
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Label for retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Label for save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Label for search action
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Placeholder text for search input
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchPlaceholder;

  /// Label for settings section
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Label for system default theme option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Label for theme settings
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Prompt for email address input
  ///
  /// In en, this message translates to:
  /// **'Please input email address'**
  String get pleaseInputEmailAddress;

  /// Prompt for valid email address input
  ///
  /// In en, this message translates to:
  /// **'Please input valid email address'**
  String get pleaseInputValidEmailAddress;

  /// Prompt for password input
  ///
  /// In en, this message translates to:
  /// **'Please input password'**
  String get pleaseInputPassword;

  /// Prompt for valid password input
  ///
  /// In en, this message translates to:
  /// **'Please input valid password'**
  String get pleaseInputValidPassword;

  /// Label for update action
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Label for version information
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Positive response
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
