// -*- flycheck-checker: intl_translation; -*-
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

  String get appTitle => Intl.message('Styled Text Test', name: 'appTitle');

  String get countLabel =>
      Intl.message('You have pushed the button this many times:',
          name: 'countLabel');

  String get incrementButtonTooltip =>
      Intl.message('Increment', name: 'incrementButtonTooltip');

  String get separateTextsTitle =>
      Intl.message('Separate Text Widgets', name: 'separateTextsTitle');

  String get flutterHtmlTitle =>
      Intl.message('flutter_html', name: 'flutterHtmlTitle');

  String countLabelHtml(num count) => Intl.message(
      'You have <em>pushed</em> the button <strong>$count</strong> times.',
      name: 'countLabelHtml',
      args: [count]);

  String get defaultTabTitle =>
      Intl.message('Default', name: 'defaultTabTitle');

  String get htmlTabTitle => Intl.message('HTML', name: 'htmlTabTitle');

  String fpsLabel(num fps) =>
      Intl.message('$fps fps', name: 'fpsLabel', args: [fps]);

  String get fpsUnknownLabel => Intl.message('?', name: 'fpsUnknownLabel');

  String get richTabTitle => Intl.message('Rich', name: 'richTabTitle');

  String get dependenciesTabTitle =>
      Intl.message('Dependencies', name: 'dependenciesTabTitle');

  String countLabelMarkdown(num count) =>
      Intl.message('You have *pushed* the button **$count** times.',
          name: 'countLabelMarkdown', args: [count]);

  String get markdownTabTitle =>
      Intl.message('Markdown', name: 'markdownTabTitle');

  // This string is intentionally different from its translations for testing purposes
  String get messageFromApp =>
      Intl.message('This string is the default defined in the app 🐞',
          name: 'messageFromApp');
}
