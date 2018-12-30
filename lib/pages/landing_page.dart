import 'package:flutter/material.dart';
import 'quiz_page.dart';
import 'dart:convert';
import 'dart:io';
import '../utils/questions.dart';

class LandingPage extends StatefulWidget {

  
  bool connection = true;
  @override
  State createState() => new LandingPageState();
}

class LandingPageState extends State<LandingPage> {

  Question firstQuestion;
  bool firstTap = false;

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.blueAccent, 
      child: new InkWell(
        onTap: () {
          if (firstTap == false) {
            firstTap = true;
            _getRandomQuote();
          }
        },
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Start quiz!", style: new TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold)),
            new Text((widget.connection == true) ? "Tap to start" : "No internet connection", style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
            
          ],
        )
      ) 
    );
  }

  void handleFirstQuestion(String json) {
    var data = jsonDecode(json);
    firstQuestion = new Question(data['statement'], data['answer'].toLowerCase() == 'true');
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new QuizPage(firstQuestion)));
  }

  _getRandomQuote() async{
    var url = 'https://us-central1-quiz-app-1-8f34b.cloudfunctions.net/getQuestion';
    String result;
    HttpClient httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        result = data['statement'] + " " + data['answer'];
        handleFirstQuestion(json);
      } else {
        result =
        'Error getting a random quote: Http status ${response.statusCode}';
        
        this.setState((){
          widget.connection = false;
        });
      }
    } catch (exception) {
      result = 'Failed invoking the getRandomQuote function.';
      this.setState((){
        widget.connection = false;
      });
    }
    print(result);
  }

}