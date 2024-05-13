import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/app_chart.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/widgets.dart';

class AdminStatisticsScreen extends StatefulWidget {
  const AdminStatisticsScreen({super.key});

  @override
  State<AdminStatisticsScreen> createState() => _AdminStatisticsScreenState();
}

class _AdminStatisticsScreenState extends State<AdminStatisticsScreen> {
  late List<dynamic> examStatistics;

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
        } else if (state is StatisticsLoaded) {
          examStatistics = state.statistics['examsArray'];
        }
      },
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return const Center(
            child: AppLoadingAnimation(),
          );
        } else if (state is StatisticsLoaded) {
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
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.cached,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      context.read<StatisticsBloc>().add(GetAdminStatisticsEvent());
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    width: min(MediaQuery.of(context).size.width * 0.4, 240),
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          examStatistics = examStatistics.where((element) {
                                            return element['exam_title'].toString().toLowerCase().contains(value.toLowerCase());
                                          }).toList();
                                        } else {
                                          examStatistics = state.statistics['examsArray'];
                                        }
                                        setState(() {});
                                      },
                                      decoration: const InputDecoration(
                                        icon: Padding(
                                          padding: EdgeInsets.only(left: 16),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        hintText: 'Search exams',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: examStatistics.length,
                              itemBuilder: (context, index) {
                                return ExamStatisticsCard(
                                  examStatistics: examStatistics[index],
                                );
                              },
                            ),
                          ],
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

  @override
  void initState() {
    super.initState();
    context.read<StatisticsBloc>().add(GetAdminStatisticsEvent());
    examStatistics = [];
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
      padding: const EdgeInsets.symmetric(vertical: 10),
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