import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_l10n_test/html_text.dart';
import 'package:flutter_l10n_test/l10n.dart';
import 'package:flutter_l10n_test/markdown_text.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fps/fps.dart';
import 'package:my_l10n_package/l10n.dart' as dep;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        const dep.L10nDelegate(),
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
    final tabs = [
      Tab(text: L10n.of(context).defaultTabTitle), // Default
      Tab(text: L10n.of(context).richTabTitle), // Rich
      Tab(text: L10n.of(context).htmlTabTitle), // HTML
      Tab(text: L10n.of(context).markdownTabTitle), // Markdown
      Tab(text: L10n.of(context).dependenciesTabTitle), // Dependencies
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).appTitle), // Flutter Demo Home Page
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            Infinite(() => SeparateTextsCard(_counter)),
            Infinite(() => RichTextCard(_counter)),
            Infinite(() => HtmlTextCard(_counter)),
            Infinite(() => MarkdownTextCard(_counter)),
            const DependenciesTest(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: L10n.of(context).incrementButtonTooltip, // Increment
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class SeparateTextsCard extends StatelessWidget {
  const SeparateTextsCard(this.count);
  final num count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // You have pushed the button this many times:
          Text(L10n.of(context).countLabel),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.display1.copyWith(
                  color: _randomColor(),
                  fontFamily: _numberFont,
                ),
          ),
        ],
      ),
    );
  }
}

class RichTextCard extends StatelessWidget {
  const RichTextCard(this.count);
  final num count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: RichText(
        text: TextSpan(
          // Can't specify an outer text: or the children will lose their fontFamily
          // https://github.com/flutter/flutter/issues/35992
          children: [
            TextSpan(
              text: L10n.of(context).countLabel,
              style: DefaultTextStyle.of(context).style,
            ),
            TextSpan(
              text: count.toString(),
              style: Theme.of(context).textTheme.display1.copyWith(
                    color: _randomColor(),
                    fontFamily: _numberFont,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class HtmlTextCard extends StatelessWidget {
  const HtmlTextCard(this.count);

  final num count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: HtmlText(
        // You have pushed the button $_counter times.
        text: L10n.of(context).countLabelHtml(count),
        textAlign: TextAlign.center,
        elementStyles: {
          'strong': const TextStyle(
            fontSize: 30,
            fontFamily: _numberFont,
          ),
          'em': TextStyle(color: _randomColor()),
        },
      ),
    );
  }
}

class MarkdownTextCard extends StatelessWidget {
  const MarkdownTextCard(this.count);

  final num count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MarkdownText(
        // You have pushed the button $_counter times.
        text: L10n.of(context).countLabelMarkdown(count),
        elementStyles: {
          'strong': const TextStyle(
            fontSize: 30,
            fontFamily: _numberFont,
          ),
          'em': TextStyle(color: _randomColor()),
        },
      ),
    );
  }
}

const _numberFont = 'DM_Serif_Display';
final _random = Random();
Color _randomColor() => Color(_random.nextInt(0xFFFFFFFF));

typedef WidgetGen = Widget Function();

class Infinite extends StatelessWidget {
  final WidgetGen gen;

  const Infinite(this.gen);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          ListView.builder(itemBuilder: (context, i) => gen()),
          const Positioned(
            right: 0,
            top: 0,
            child: FpsCounter(),
          ),
        ],
      ),
    );
  }
}

class FpsCounter extends StatelessWidget {
  const FpsCounter();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        color: Colors.black.withOpacity(0.6),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: StreamBuilder<num>(
        stream: eachFrame().transform(const ComputeFps()),
        builder: (context, snapshot) {
          return Text(
            snapshot.hasData
                ? L10n.of(context).fpsLabel(snapshot.data.round()) // $fps fps
                : L10n.of(context).fpsUnknownLabel, // ?
            style: const TextStyle(
              color: Colors.white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          );
        },
      ),
    );
  }
}

class DependenciesTest extends StatelessWidget {
  const DependenciesTest();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(L10n.of(context).messageFromApp),
          Text(dep.L10n.of(context).messageFromPackage),
        ],
      ),
    );
  }
}
