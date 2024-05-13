import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/result_detail_bloc/result_detail_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/widgets.dart';
import 'package:toastification/toastification.dart';

class ResultDetailScreen extends StatefulWidget {
  const ResultDetailScreen({super.key, required this.resultId});

  final String resultId;

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResultDetailBloc, ResultDetailState> (
      listener: (context, state) {
        if (state is ResultDetailError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: Text(state.message),
              description: Text(state.message),
              alignment: Alignment.topRight,
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
            );
          });
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (ResultDetailLoading):
            return const Center(child: AppLoadingAnimation());
          case const (ResultDetailInitial):
            context.read<ResultDetailBloc>().add(GetResultDetailEvent(resultId: widget.resultId));
            return const Center(child: AppLoadingAnimation());
          case const (ResultDetailLoaded):
            final result = (state as ResultDetailLoaded).result;
            var formatter =  DateFormat('yyyy-MM-dd HH:mm:ss');
            return SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 1000,
                          minHeight: MediaQuery.of(context).size.height,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.network(
                                  'https://scontent.fhan4-6.fna.fbcdn.net/v/t1.15752-9/440284058_473132688478898_7858552623376490913_n.png?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_ohc=Mie7cibBa7QQ7kNvgFxqK4_&_nc_ht=scontent.fhan4-6.fna&oh=03_Q7cD1QFDwvpifFMpBlLYi0a685cFrvS09nhNvqA3e1zUMfkuPw&oe=66596B41',
                                  width: 180,
                                  height: 180,
                                ),
                              ),
                              const SizedBox(height:10),
                              Text(
                                result['exam']['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Duration: ${result['exam']['duration']} minutes',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Score: ${result['result']['correctCount']}/${result['result']['totalQuestions']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Submitted at: ${formatter.format(DateTime.parse(result['result']['submittedAt'].toString()))}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 20),
                              for (int i = 0; i < result['exam']['questions'].length; i++)
                                QuestionDetailCard(
                                  index: i,
                                  question: result['exam']['questions'][i],
                                  detail: result['result']['details'][i],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          default:
            return Expanded(
              child: Center(
                child: FilledButton(
                  onPressed: () {
                    context.read<ResultDetailBloc>().add(GetResultDetailEvent(resultId: widget.resultId));
                  },
                  child: const Text('Reload'),
                ),
              )
            );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ResultDetailBloc>().add(ResultDetailInitialEvent());
  }
}

class QuestionDetailCard extends StatelessWidget {
  const QuestionDetailCard({super.key, required this.index, required this.question, required this.detail});

  final int index;
  final Map<String, dynamic> question;
  final Map<String, dynamic> detail;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: detail['isCorrect'] ? const Color.fromARGB(255, 248, 255, 248) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: min(
                          780,
                          width > 800 ? width * 0.6 - 100 : width * 0.7,
                        ),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Câu ${index + 1}: ${question['content']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: detail['isCorrect'] ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    BuildAnswersDetail(
                      question: question,
                      detail: detail,
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class BuildAnswersDetail extends StatelessWidget {
  const BuildAnswersDetail({super.key, required this.question, required this.detail});

  final Map<String, dynamic> question;
  final Map<String, dynamic> detail;


  @override
  Widget build(BuildContext context) {
    final List<Widget> answers = [];

    for (int i = 0; i < question['answers'].length; i++) {
      answers.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Radio(
                value: i,
                groupValue: detail['yourAnswer'],
                onChanged: null,
              ),
              Text(question['answers'][i]),
              if (i == detail['correctAnswer'])
                const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              if (i == detail['yourAnswer'] && i != detail['correctAnswer'])
                const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: answers
    );
  }
}