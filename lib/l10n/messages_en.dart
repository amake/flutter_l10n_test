// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'en';

  static m0(count) => "You have <em>pushed</em> the button <strong>${count}</strong> times.";

  static m1(count) => "You have *pushed* the button **${count}** times.";

  static m2(fps) => "${fps} fps";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appTitle" : MessageLookupByLibrary.simpleMessage("Styled Text Test"),
    "countLabel" : MessageLookupByLibrary.simpleMessage("You have pushed the button this many times:"),
    "countLabelHtml" : m0,
    "countLabelMarkdown" : m1,
    "defaultTabTitle" : MessageLookupByLibrary.simpleMessage("Default"),
    "dependenciesTabTitle" : MessageLookupByLibrary.simpleMessage("Dependencies"),
    "flutterHtmlTitle" : MessageLookupByLibrary.simpleMessage("flutter_html"),
    "fpsLabel" : m2,
    "fpsUnknownLabel" : MessageLookupByLibrary.simpleMessage("?"),
    "htmlTabTitle" : MessageLookupByLibrary.simpleMessage("HTML"),
    "incrementButtonTooltip" : MessageLookupByLibrary.simpleMessage("Increment"),
    "markdownTabTitle" : MessageLookupByLibrary.simpleMessage("Markdown"),
    "messageFromApp" : MessageLookupByLibrary.simpleMessage("This string is defined in the app."),
    "richTabTitle" : MessageLookupByLibrary.simpleMessage("Rich"),
    "separateTextsTitle" : MessageLookupByLibrary.simpleMessage("Separate Text Widgets")
  };
}
