import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;
import 'package:covid19app/helper/helper.dart';
import 'package:covid19app/model/chart_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChar extends StatelessWidget {
  final List<ChartModel> chartData;
  static String pointerValue;
  BarChar({this.chartData});

  final simpleCurrencyFormatter =
      new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
    new NumberFormat.compactCurrency(symbol: ''),
  );
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return charts.BarChart(
      createSampleData(),
      barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      animate: true,
      defaultRenderer: charts.BarRendererConfig(
        cornerStrategy: charts.ConstCornerStrategy(10),
      ),
      domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
            fontSize: 10, // size in Pts.
            color: charts.MaterialPalette.black),
      )),
      primaryMeasureAxis:
          charts.NumericAxisSpec(tickFormatterSpec: simpleCurrencyFormatter),
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) {
            var value =
                model.selectedSeries[0].measureFn(model.selectedDatum[0].index);
            pointerValue = Helper.numberFormat(value);
          }
        })
      ],
      behaviors: [
        charts.LinePointHighlighter(
          symbolRenderer: CustomCircleSymbolRendererBar(size: size),
        ),
      ],
    );
  }

  List<charts.Series<ChartModel, String>> createSampleData() {
    final data = chartData;
    return [
      charts.Series<ChartModel, String>(
        id: 'Sales',
        data: data,
        domainFn: (ChartModel model, _) => model.year,
        measureFn: (ChartModel model, _) => model.sales,
        areaColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault.lighter,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (ChartModel model, _) =>
            charts.ColorUtil.fromDartColor(Color(0xFFff5959)),
      ),
    ];
  }
}

class CustomCircleSymbolRendererBar extends charts.CircleSymbolRenderer {
  final size;
  CustomCircleSymbolRendererBar({this.size});
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: charts.Color.white,
        strokeColor: charts.Color.black,
        strokeWidthPx: 1);

    // Draw a bubble
    num rectWidth = 100;
    num rectHeight = 30;
    num left = bounds.left > (size?.width ?? 300) / 2
        ? (bounds.left > size?.width / 4
            ? bounds.left - rectWidth
            : bounds.left - rectWidth / 2)
        : bounds.left - 40;
    final num bubbleHight = 30;

    final num bubbleRadius = bubbleHight / 2.0;

    canvas.drawRRect(
      Rectangle(left, -5, rectWidth, rectHeight),
      fill: charts.Color.black,
      stroke: charts.Color.black,
      radius: bubbleRadius,
      roundTopLeft: true,
      roundBottomLeft: true,
      roundBottomRight: true,
      roundTopRight: true,
    );

    // Add text inside the bubble

    final textStyle = chartsTextStyle.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 12;

    final chartsTextElement.TextElement textElement =
        chartsTextElement.TextElement(BarChar.pointerValue, style: textStyle);

    final num textElementBoundsLeft = left.round() + 18;
    final num textElementBoundsTop = 5;

    canvas.drawText(textElement, textElementBoundsLeft, textElementBoundsTop);
  }
}
