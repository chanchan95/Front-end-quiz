import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AppPieChart extends StatefulWidget {
  const AppPieChart({
    super.key,
    required this.titles,
    required this.values,
    required this.colors,
    this.isPercent = false,
    this.showFirstTitle = true,
  });

  final List<String> titles;
  final List<double> values;
  final List<Color> colors;
  final bool isPercent;
  final bool showFirstTitle;

  @override
  State<AppPieChart> createState() => AppPieChartState();
}

class AppPieChartState extends State<AppPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(widget.values, widget.colors, widget.isPercent, widget.showFirstTitle),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: widget.colors[0],
                text: widget.titles[0],
                isSquare: true,
              ),
              const SizedBox(
                height: 4,
              ),
              Indicator(
                color: widget.colors[1],
                text: widget.titles[1],
                isSquare: true,
              ),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<double> values, List<Color> colors, bool isPercent, bool showFirstTitle) {
    double sumOfValues = values.reduce((a, b) => a + b);
    String firstTitle = isPercent ? '${(values[0] / sumOfValues * 100).toStringAsFixed(1)}%' : values[0].toString();
    String secondTitle = isPercent ? '${(values[1] / sumOfValues * 100).toStringAsFixed(1)}%' : values[1].toString();
    if (!showFirstTitle) {
      firstTitle = '';
    }
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: colors[i],
            value: values[i],
            title: firstTitle,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: colors[i],
            value: values[i],
            title: secondTitle,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}