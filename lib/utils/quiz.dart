import './questions.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

class Quiz {
  Question _currentQuestion;
  int _currentQuestionIndex = -1;
  int _score = 0;
  int _lifes = 3;

  Quiz(this._currentQuestion);

  Question get question => _currentQuestion;
  int get questionNumber => _currentQuestionIndex + 1;
  int get score => _score;
  int get lifes => _lifes;

  Question get nextQuestion {
    _currentQuestionIndex++;
    if (_lifes == 0) return null;
    _getRandomQuote();
    // update _currentQuestion
    return _currentQuestion;
  }

  void answer(bool isCorrect) {
    if (isCorrect) _score++;
    else _lifes--;
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