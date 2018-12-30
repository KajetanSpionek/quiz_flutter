import 'package:flutter/material.dart';
import '../UI/answer_button.dart';
import '../utils/questions.dart';
import '../utils/quiz.dart';
import '../UI/question_text.dart';
import '../UI/correct_wrong_overlay.dart';
import '../pages/score_page.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  Quiz quiz = new Quiz(new Question("Press True!", true));

  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;
  bool waitForServer = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect); // Plus one to score
    this.setState(() {
      overlayShouldBeVisible = true;
      waitForServer = true;
    });
    _getRandomQuote();
  }

  void handleServerMsg(String json) {
    var data = jsonDecode(json);
    bool ans = data['answer'].toLowerCase() == 'true';
    quiz.currentQuestion = new Question(data['statement'], data['answer'].toLowerCase() == 'true');
    this.setState((){
      waitForServer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column( // main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false)),
          ],
        ),
        overlayShouldBeVisible == true ? new CorrectWrongOverlay(
          isCorrect, waitForServer,
          () {
            if (quiz.lifes == 0) {
                Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score)), (Route route) => route == null);
                return;
            }
            if (waitForServer == false) {
              currentQuestion = quiz.nextQuestion;
              this.setState(() {
                overlayShouldBeVisible = false;
                questionText = currentQuestion.question;
                questionNumber = quiz.questionNumber;
              });
            }
          }
          ) : new Container()
      ],
    );
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
        handleServerMsg(json);
      } else {
        result =
        'Error getting a random quote: Http status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getRandomQuote function.';
    }
    print(result);
  }

}