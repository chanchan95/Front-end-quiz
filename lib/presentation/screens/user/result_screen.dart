import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../blocs/result_bloc/result_bloc.dart';
import '../widgets/app_loading_animation.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResultBloc, ResultState> (
      listener: (context, state) {
        if (state is ResultError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: const Text('Error'),
              description: Text(state.message),
              alignment: Alignment.topRight,
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
            );
          });
        }
      },
      builder: (context, state) {
        if (state is ResultLoading) {
          return const Center(
            child: AppLoadingAnimation(),
          );
        } else if (state is ResultLoaded) {
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
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Results',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...state.results.map((result) {
                              return Placeholder();
                              // return ResultCard(
                              //   result: result,
                              //   onViewDetail: () {
                              //     context.go('/result/${result['id']}');
                              //   },
                              // );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Expanded(
          child: Center(
            child: FilledButton(
              onPressed: () {
                context.read<ResultBloc>().add(GetResultsEvent());
              },
              child: const Text('Reload'),
            ),
          )
        );
      },
    );
  }
}

class ResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  final VoidCallback onViewDetail;

  const ResultCard({super.key, required this.result, required this.onViewDetail});

  @override
  Widget build(BuildContext context) {
    bool isMedium = MediaQuery.of(context).size.width > 800;
    var formatter =  DateFormat('yyyy-MM-dd HH:mm:ss');
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
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

          child: Flex(
            direction: isMedium ? Axis.horizontal : Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.network(
                  'https://scontent.fhan4-6.fna.fbcdn.net/v/t1.15752-9/440284058_473132688478898_7858552623376490913_n.png?_nc_cat=109&ccb=1-7&_nc_sid=5f2048&_nc_ohc=Mie7cibBa7QQ7kNvgFxqK4_&_nc_ht=scontent.fhan4-6.fna&oh=03_Q7cD1QFDwvpifFMpBlLYi0a685cFrvS09nhNvqA3e1zUMfkuPw&oe=66596B41',
                  width: 120,
                  height: 120,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result['exam']['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                  ],
                ),
              ),
              isMedium ? const Spacer() : const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(32),
                child: FilledButton(
                  onPressed: onViewDetail,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        'View Detail',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}