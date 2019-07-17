import 'package:flutter/material.dart';
import 'package:flutter_l10n_test/html_text.dart';
import 'package:flutter_l10n_test/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        const L10nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).appTitle), // Flutter Demo Home Page
      ),
      body: Center(
        child: ListView(
          children: [
            _separateTextWidgets,
            _htmlWidget,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: L10n.of(context).incrementButtonTooltip, // Increment
        child: Icon(Icons.add),
      ),
    );
  }

  Widget get _separateTextWidgets => Card(
        child: Column(
          children: [
            Text(L10n.of(context).separateTextsTitle), // Separate Text Widgets
            const SizedBox(height: 10),
            Text(L10n.of(context).countLabel),
            Text(
              _counter.toString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      );

  Widget get _htmlWidget => Card(
        child: Column(
          children: [
            Text(L10n.of(context).flutterHtmlTitle), // flutter_html
            const SizedBox(height: 10),
            HtmlText(
              // You have pushed the button $_counter times.
              text: L10n.of(context).countLabelHtml(_counter),
              textAlign: TextAlign.center,
              elementStyles: const {
                'strong': TextStyle(fontSize: 30),
                'em': TextStyle(color: Colors.blue),
              },
            ),
          ],
        ),
      );
}
