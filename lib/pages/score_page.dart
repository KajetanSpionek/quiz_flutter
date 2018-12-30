import 'package:flutter/material.dart';
import './landing_page.dart';

class ScorePage extends StatelessWidget {

  final int score;

  ScorePage(this.score);

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: score > 5 ? Colors.greenAccent : Colors.redAccent,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Your Score:", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50.0)),
          new Text(score.toString(), style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50.0)),
          new IconButton(
            icon: new Icon(Icons.rotate_left),
            color: Colors.white,
            iconSize: 50.0,
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => LandingPage()), (Route route) => route == null)
          ),
        ],
      ),
    );
  }
}
