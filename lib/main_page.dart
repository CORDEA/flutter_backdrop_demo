import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  static const _PANEL_HEIGHT = 32.0;

  AnimationController _controller;

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), value: 1.0, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Size panelSize = constraints.biggest;
    final double top = panelSize.height - _PANEL_HEIGHT;
    var animation = RelativeRectTween(
            begin: new RelativeRect.fromLTRB(
                0.0,
                top - MediaQuery.of(context).padding.bottom,
                0.0,
                top - panelSize.height),
            end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    final ThemeData theme = Theme.of(context);
    return Container(
        color: theme.primaryColor,
        child: Stack(children: <Widget>[
          Center(
            child: Text("base", style: theme.primaryTextTheme.display2),
          ),
          PositionedTransition(
              rect: animation,
              child: Material(
                shape: BeveledRectangleBorder(
                    borderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(_PANEL_HEIGHT))),
                elevation: 12.0,
                child: Column(children: <Widget>[
                  Container(
                    height: _PANEL_HEIGHT,
                    child: Center(child: Text("panel")),
                  ),
                  Divider(height: 1.0),
                  Expanded(
                      child: Center(
                          child:
                              Text("content", style: theme.textTheme.display2)))
                ]),
              ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          elevation: 0.0,
          title: new Text(widget.title),
          leading: IconButton(
            onPressed: () {
              _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: _controller.view,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: _buildStack,
        ));
  }
}
