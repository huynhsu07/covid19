import 'package:after_layout/after_layout.dart';
import 'package:covid19app/api/api.dart';
import 'package:covid19app/barchart.dart';
import 'package:covid19app/helper/helper.dart';
import 'package:covid19app/model/chart_model.dart';
import 'package:covid19app/model/linechart_model.dart';
import 'package:covid19app/model/model.dart';
import 'package:covid19app/widget/couter.dart';
import 'package:covid19app/widget/indicator.dart' as _;
import 'package:covid19app/widget/item.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  ApiModel model;
  RefreshController _refreshController;
  bool _isLoading;
  var listDay;
  var listValue;
  List<ChartModel> list = List();
  List<LineChartModel> listLineChart = List();
  List<LineChartModel> listLineChartDeath = List();
  List<LineChartModel> listLineChartRecovered = List();

  var valueAtPoint;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model = null;
    _isLoading = true;
    _refreshController = RefreshController();
    initializeDateFormatting();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getData();
    getDaily();
  }

  void getDaily() async {
    var data = await Api().getDaily();
    if (data != null) {
      setState(() {
        for (var item in data['cases'].entries) {
          list.add(ChartModel(
              year: Helper.convertStringToDate(item.key), sales: item.value));
        }
      });
    } else {
      print('Error Internet');
    }
  }

  void getData() async {
    ApiModel apiModel = await Api().getTotal();
    if (apiModel != null) {
      setState(() {
        _isLoading = false;
        _refreshController.refreshCompleted();
        model = apiModel;
      });
    } else {
      _refreshController.refreshFailed();
      setState(() {
        _isLoading = false;
      });
      print('Error Internet');
    }
  }

  Widget _body() {
    Widget body;
    if (model != null && list != null) {
      body = SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Cập nhật lúc ${Helper.timestampFormat(model.timeUpdate)}',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Item(
                    value: model.totalCase,
                    colorBackground: Color(0xFFffb259),
                    title: 'Số ca dương tính',
                  ),
                ),
                Expanded(
                  child: Item(
                    value: model.death,
                    colorBackground: Color(0xFFff5959),
                    title: 'Số ca tử vong',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Item(
                    value: model.recovered,
                    colorBackground: Color(0xFF4cd97b),
                    title: 'Số ca hồi phục',
                  ),
                ),
                Expanded(
                  child: Item(
                    value: model.active,
                    colorBackground: Color(0xFF4cb5ff),
                    title: 'Đang điều trị',
                  ),
                ),
                Expanded(
                  child: Item(
                    value: model.critical,
                    colorBackground: Color(0xFF9059ff),
                    title: 'Số ca nguy kịch',
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'Hôm nay',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    )),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Counter(
                      color: Color(0xFFFF4848),
                      number: model.todayDeath,
                      title: "Tử vong",
                    ),
                    Counter(
                      color: Color(0xFFFF8748),
                      number: model.todayCase,
                      title: "Phát hiện",
                    ),
                    Counter(
                      color: Colors.green,
                      number: model.todayRecovered,
                      title: "Hồi phục",
                    ),
                  ],
                ),
              ),
            ),
            if (list != null) ...[
              Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 400,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Text('Diễn biến Covid-19 trong 7 ngày qua'),
                      Text(
                        'Cập nhật lúc ${Helper.timestampFormatLong(model.timeUpdate)}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: BarChar(
                            chartData: list,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(
              height: 50,
            )
          ],
        ),
      );
    } else {
      body = Center(
        child: Text('Có lỗi xảy ra vui lòng thử lại'),
      );
    }
    return body;
  }

  /// Sample ordinal data type.

  void _onRefresh() {
    setState(() {
      _isLoading = true;
      _refreshController.resetNoData();
    });
    getData();
    getDaily();
  }

  void onLoading() {
    getData();
    getDaily();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF473f97),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF473f97),
        title: Text('Thống kê Covid-19'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: onLoading,
        header: WaterDropMaterialHeader(
          backgroundColor: Color(0xFF2b2944),
        ),
        child: _isLoading ? _.Indicator() : _body(),
      ),
    );
  }
}
