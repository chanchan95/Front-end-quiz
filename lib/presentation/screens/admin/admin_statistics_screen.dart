import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/app_chart.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/widgets.dart';

class AdminStatisticsScreen extends StatelessWidget {
  const AdminStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatisticsBloc, StatisticsState>(
      listener: (context, state) {
        if (state is StatisticsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return const Center(
            child: AppLoadingAnimation(),
          );
        } else if (state is StatisticsLoaded) {
          final List<dynamic> examStatistics = state.statistics['examsArray'];
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
                        padding: EdgeInsets.all(40),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: examStatistics.length,
                          itemBuilder: (context, index) {
                            return ExamStatisticsCard(
                              examStatistics: examStatistics[index],
                            );
                          },
                        ),
                      )
                    ),
                  )
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
      },
    );
  }
}

class ExamStatisticsCard extends StatelessWidget {
  final Map<String, dynamic> examStatistics;

  const ExamStatisticsCard({super.key, required this.examStatistics});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double totalPoint = examStatistics['totalPoint'] ?? 0;
    final double avgPoint = examStatistics['avgPoint'] ?? 0;
    final double completePercent = examStatistics['completePercent'] * 100 ?? 0;
    final double countUser = examStatistics['countUser'] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Card(
        child: ExpansionTile(
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.assignment),
          ),
          title: Text(examStatistics['exam_title']),
          subtitle: Text('Số lượng sinh viên tham gia: $countUser'),
          children: [
            Flex(
              direction: width < 1100 ? Axis.vertical : Axis.horizontal,
              children: [
                SizedBox(
                  width: 360,
                  height: 240,
                  child: AppPieChart(
                    values: [totalPoint - avgPoint, avgPoint],
                    titles: ['', 'Điểm trung bình'],
                    colors: [Colors.grey, Colors.blue],
                    showFirstTitle: false,
                  ),
                ),
                SizedBox(
                  width: 360,
                  height: 240,
                  child: AppPieChart(
                    values: [100 - completePercent, completePercent],
                    titles: ['', 'Số lượng hoàn thành'],
                    colors: [Colors.grey, Colors.green],
                    isPercent: true,
                    showFirstTitle: false,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}