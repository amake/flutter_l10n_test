import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as real_intl; // HORRIBLE HACK! (see below)
import 'package:intl/src/intl_helpers.dart'; // ignore: implementation_imports
import 'package:my_l10n_package/l10n/messages_all.dart';

class L10nDelegate extends LocalizationsDelegate<L10n> {
  const L10nDelegate();

  @override
  bool isSupported(Locale locale) => L10n.supportedLocales.contains(locale);

  @override
  Future<L10n> load(Locale locale) => L10n.load(locale);

  @override
  bool shouldReload(L10nDelegate old) => false;
}

/// HORRIBLE HACK!
///
/// The intl package only supports loading one global message table, which is
/// held at [messageLookup] in intl_helpers.dart. This prevents us from
/// providing localized strings in this plugin for consumption in a parent
/// application, as only one message table will be used.
///
/// The travesty below works around this. It is so horrible because we are
/// trying to have our cake and eat it too:
///
/// - We want to manage strings in this package with the intl_translation
///   extraction and merging tools, so message lookup calls must (appear) to be
///   made to [Intl]
/// - We don't want to edit generated files (messages_all.dart, etc.) by hand
///
/// How it works:
///
/// 1. We define our own [Intl] class that calls into our own lookup,
///    [myMessageLookup]. The lookup is initially "empty".
/// 2. We import the real intl class under an alias and delegate to it where
///    appropriate.
/// 3. We call the default generated [initializeMessages], then immediately swap
///    out the real [messageLookup] and [myMessageLookup] objects. This
///    returns the real lookup to an uninitialized state for the application's
///    localizations to load. (Yes, all this relies on localization delegate
///    init happening sequentially.)
/// 4. We exhort the consuming application to load our localization delegate
///    before the application's.
class Intl {
  // copied from the real intl package
  static String message(String message_str,
          {String desc: '',
          Map<String, Object> examples: const {},
          String locale,
          String name,
          List<Object> args,
          String meaning,
          bool skip}) =>
      _message(message_str, locale, name, args, meaning);

  // copied from the real intl package
  static String _message(String message_str, String locale, String name,
      List<Object> args, String meaning) {
    return myMessageLookup.lookupMessage(
        message_str, locale, name, args, meaning);
  }
}

MessageLookup myMessageLookup =
    UninitializedLocaleData('initializeMessages(<locale>)', null);

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
    final localeName = real_intl.Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      // HORRIBLE HACK! (see above)
      // Steal the just-initialized lookup and keep it for ourselves.
      // Then un-initialize the real lookup so the next localizations can load.
      final uninitialized = myMessageLookup;
      myMessageLookup = messageLookup;
      messageLookup = uninitialized;
      real_intl.Intl.defaultLocale = localeName;
      return L10n();
    });
  }

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  // This string is intentionally different from its translations for testing purposes
  String get messageFromPackage =>
      Intl.message('このストリングはパッケージ上で定義されているデフォルト🐞', name: 'messageFromPackage');
}
