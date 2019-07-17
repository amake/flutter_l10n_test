import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_l10n_test/l10n/messages_all.dart';
import 'package:intl/intl.dart';

class L10nDelegate extends LocalizationsDelegate<L10n> {
  const L10nDelegate();

  @override
  bool isSupported(Locale locale) => L10n.supportedLocales.contains(locale);

  @override
  Future<L10n> load(Locale locale) => L10n.load(locale);

  @override
  bool shouldReload(L10nDelegate old) => false;
}

class L10n {
  static const supportedLocales = [
    Locale('en'),
    Locale('ja'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  static Future<L10n> load(Locale locale) {
    final name = locale.countryCode?.isEmpty ?? true
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return L10n();
    });
  }

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  String get appTitle =>
      Intl.message('Flutter Demo Home Page', name: 'appTitle');

  String get countLabel =>
      Intl.message('You have pushed the button this many times:',
          name: 'countLabel');

  String get incrementButtonTooltip =>
      Intl.message('Increment', name: 'incrementButtonTooltip');

  String get separateTextsTitle =>
      Intl.message('Separate Text Widgets', name: 'separateTextsTitle');
}
