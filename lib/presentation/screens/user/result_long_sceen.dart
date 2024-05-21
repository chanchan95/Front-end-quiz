import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ptit_quiz_frontend/domain/entities/result.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/long_result/long_result_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/app_loading_animation.dart';
import 'package:toastification/toastification.dart';

class LongResultScreen extends StatefulWidget {
  @override
  State<LongResultScreen> createState() => _LongResultScreenState();
}

class _LongResultScreenState extends State<LongResultScreen> {
  late List<Result> results;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LongResultBloc, LongResultState>(
      listener: (context, state) {
        if (state is LongResultError) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
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
        } else if (state is LongResultLoaded) {
          results = state.results;
        }
      },
      builder: (context, state) {
        if (state is LongResultLoading) {
          return const Center(
            child: AppLoadingAnimation(),
          );
        } else if (state is LongResultLoaded) {
          results = state.results;
          print(results.length);
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
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                return LongResultCard(result: results[index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<LongResultBloc>().add(const FetchLongResultsEvent());
  }
}

class LongResultCard extends StatelessWidget {
  final Result result;
  const LongResultCard({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Exam: ${result.title}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Finish at: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(result.timeFinish))}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Total point: ${result.result}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Result: ${result.result}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
