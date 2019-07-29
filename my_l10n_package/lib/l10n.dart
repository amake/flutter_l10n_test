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
/// 3. We exhort the consuming application to load our localization delegate
///    after the application's.
/// 4. We rely on the timing of localization delegate inits to be interleaved:
///    - First the app delegate's [load] will be called, and will proceed to
///      call [initializeMessages]
///    - Then the package delegate's load be called and proceed to same
///    - The app's initializeMessages will return, having initialized
///      messageLookup
///    - The package's will return, having failed to initialize messageLookup
///      because it was already initialized
///    We then store the app's messageLookup, un-initialize messageLookup with
///    our dummy, and call our initializeMessages again. When that returns we
///    restore the original instance.
///
/// Yes, this is fragile! It has broken before!
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
      // The messageLookup is now initialized with the app's table.
      // Un-initialize it with our dummy lookup, call initializeMessages again,
      // and then swap out the original with our package's.
      final original = messageLookup;
      messageLookup = myMessageLookup;
      return initializeMessages(localeName).then((_) {
        myMessageLookup = messageLookup;
        messageLookup = original;
        real_intl.Intl.defaultLocale = localeName;
        return L10n();
      });
    });
  }

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  // This string is intentionally different from its translations for testing purposes
  String get messageFromPackage =>
      Intl.message('このストリングはパッケージ上で定義されているデフォルト🐞', name: 'messageFromPackage');
}
