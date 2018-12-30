import './questions.dart';


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
  set currentQuestion(Question currentQuestoin) {
    _currentQuestion = currentQuestoin;
  }

  Question get nextQuestion {
    _currentQuestionIndex++;
    if (_lifes == 0) return null;
    return _currentQuestion;
  }

  void answer(bool isCorrect) {
    if (isCorrect) _score++;
    else _lifes--;
  }
  
  
}