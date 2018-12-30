import 'package:flutter/material.dart';
import 'dart:math';

class CorrectWrongOverlay extends StatefulWidget {

  bool _isCorrect;
  final VoidCallback _onTap;
  bool waitForSever;
  int lifes;

  CorrectWrongOverlay(this._isCorrect, this.waitForSever, this.lifes, this._onTap);

  @override
  State createState() => new CorrectWrongOverlayState();
}

class CorrectWrongOverlayState extends State<CorrectWrongOverlay> with SingleTickerProviderStateMixin {

  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(duration: new Duration(seconds: 2), vsync: this);
    _iconAnimation = new CurvedAnimation(parent: _iconAnimationController, curve: Curves.elasticOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Material(
      color: (widget.waitForSever == true) ? Colors.black87 : Colors.black54,
      child: new InkWell(
        onTap: () => widget._onTap(),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 60.0),
            ),
            new Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(widget.lifes >= 3 ? Icons.favorite : Icons.favorite_border, size: 50.0, color: Colors.redAccent),
                new Padding(padding: new EdgeInsets.only(right: 10.0)),
                new Icon(widget.lifes >= 2 ? Icons.favorite : Icons.favorite_border, size: 50.0, color: Colors.redAccent),
                new Padding(padding: new EdgeInsets.only(right: 10.0)),
                new Icon(widget.lifes >= 1 ? Icons.favorite : Icons.favorite_border, size: 50.0, color: Colors.redAccent),
              ],
            ),
            new Padding(
              padding: new EdgeInsets.only(bottom: 160.0),
            ),
            new Container(
              decoration: new BoxDecoration(
                color: (widget._isCorrect == true) ? Colors.greenAccent : Colors.redAccent,
                shape: BoxShape.circle
              ),
              child: new Transform.rotate(
                angle: _iconAnimation.value * 2 * pi,
                child: new Icon(widget._isCorrect == true ? Icons.done : Icons.clear, size: _iconAnimation.value * 80.0, color: Colors.white),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(bottom: 20.0),
            ),
            new Text(widget._isCorrect == true ? "Correct!" : "Wrong!", style: new TextStyle(color: Colors.white, fontSize: 30.0)),
            //new Padding(
              //padding: new EdgeInsets.only(bottom:150.0)
             // ),
            new Text(widget.waitForSever == true ? "Wait for server..." : "Tap to continue", style: new TextStyle(color: Colors.white, fontSize: 10.0))
          ],
        )
      )
    );
  }
}