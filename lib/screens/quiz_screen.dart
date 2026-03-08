import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizz/model/category.dart';
import 'package:quizz/model/question.dart';
import 'package:quizz/widgets/answer_card.dart';
import 'package:quizz/data/quiz_data.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currenQuestionIndex = 0;
  int score = 0;
  int? selectedAnswer;
  bool isAnswered = false;

  List<Question> shuffledQuestions = [];
  Timer? _timer;
  int _timeLeft = 60;

  late AnimationController _progressController;
  late AnimationController _questionController;

  @override
  void initState() {
    super.initState();
    // Mezclamos preguntas
    shuffledQuestions = [...quizQuestions];
    shuffledQuestions.shuffle();

    //mezclamos las respuestas
    _shuffleOptions();

    _progressController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500)
    );
    _questionController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)
    );

    startTimer();
    _questionController.forward();
  }

  void _shuffleOptions() {
    for (int i = 0; i < shuffledQuestions.length; i++) {
      final question = shuffledQuestions[i];

      // 1. Guardamos el texto de la respuesta CORRECTA original
      // Esto es vital porque el índice va a cambiar
      final String correctText = question.options[question.correctAnswer];

      // 2. CREAMOS UNA COPIA de la lista de opciones
      // No uses .shuffle() directamente en question.options si es const
      List<String> newOptions = List.from(question.options);
      newOptions.shuffle();

      // 3. Buscamos en qué posición quedó el texto correcto en la nueva lista
      final int newCorrectIndex = newOptions.indexOf(correctText);

      // 4. Reemplazamos la pregunta en nuestra lista local con los nuevos datos
      shuffledQuestions[i] = Question(
        text: question.text,
        options: newOptions,
        correctAnswer: newCorrectIndex,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            goToResults();
          }
        });
      }
    });
  }

  void goToResults() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: score,
          totalQuestions: shuffledQuestions.length,
          category: widget.category,
        ),
      ),
    );
  }

  void selectAnswer(int answerIndex) {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = answerIndex;
      isAnswered = true;
    });

    HapticFeedback.lightImpact();

    if (answerIndex == shuffledQuestions[currenQuestionIndex].correctAnswer) {
      score++;
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currenQuestionIndex < shuffledQuestions.length - 1) {
      _questionController.reset();
      setState(() {
        currenQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
      });

      _progressController.animateTo(
        (currenQuestionIndex + 1) / shuffledQuestions.length,
      );

      _questionController.forward();
    } else {
      goToResults();
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = shuffledQuestions[currenQuestionIndex];
    double progressFactor = (currenQuestionIndex + 1) / shuffledQuestions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.category.color.withOpacity(0.1),
              widget.category.color.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila superior: Botón atrás y Temporizador
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: _timeLeft < 10 ? Colors.red : widget.category.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$_timeLeft s",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _timeLeft < 10 ? Colors.red : const Color(0xFF2D3748),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Barra de progreso y contador de preguntas
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progressFactor,
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.category.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${currenQuestionIndex + 1}/${shuffledQuestions.length}",
                      style: const TextStyle(
                        color: Color(0xFF2D3748),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 32),

                // Pregunta
                FadeTransition(
                  opacity: _questionController,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      question.text,
                      style: const TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Opciones
                Expanded(
                  child: ListView.builder(
                    itemCount: question.options.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedAnswer == index;
                      final isCorrect = isAnswered && index == question.correctAnswer;
                      final isWrong = isAnswered && isSelected && index != question.correctAnswer;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FadeTransition(
                          opacity: _questionController,
                          child: AnswerCard(
                            key: ValueKey('q_${currenQuestionIndex}_a_$index'),
                            text: question.options[index],
                            isSelected: isSelected,
                            isCorrect: isCorrect,
                            isWrong: isWrong,
                            onTap: () => selectAnswer(index),
                            color: widget.category.color,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}