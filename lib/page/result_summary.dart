import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:gauges/gauges.dart';
import 'package:speech_to_text_example/controllers/preference.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:charts_flutter/flutter.dart' as charts;

final List<String> imagesList = [
  'https://cdn.pixabay.com/photo/2020/11/01/23/22/breakfast-5705180_1280.jpg',
  'https://cdn.pixabay.com/photo/2016/11/18/19/00/breads-1836411_1280.jpg',
  'https://cdn.pixabay.com/photo/2019/01/14/17/25/gelato-3932596_1280.jpg',
  'https://cdn.pixabay.com/photo/2017/04/04/18/07/ice-cream-2202561_1280.jpg',
];
final List<String> titles = [
  ' Coffee ',
  ' Bread ',
  ' Gelato ',
  ' Ice Cream ',
];

class ResultSummary extends StatefulWidget {
  const ResultSummary({Key key}) : super(key: key);

  @override
  _SegmentsPageState createState() => _SegmentsPageState();
}

class _SegmentsPageState extends State<ResultSummary> {
  int _currentIndex = 0;
  var request = "${url}api/result/";

  final sliderLabels = [
    "위험해요",
    "위험해요",
    "너무 아파요",
    "아파요",
    "치료가 필요해요",
    "건강한 편이예요",
    "너무 건강해요"
  ];
  bool _showCharts = false;
  double _pointerValue = 0;
  double _aft = 0;
  double _cgt = 0;
  double _smt = 0;
  bool isLoading = false;
  Map<String, dynamic> resultList;

  @override
  void initState() {
    super.initState();
    this.fetchResult();
    this._showCharts = false;
  }

  void dispose() {
    super.dispose();
    this.fetchResult();
  }

  fetchResult() async {
    Dio dio = Dio();
    Response response;

    setState(() {
      isLoading = true;
    });

    response = await dio.get("$request$email");
    if (response.statusCode == 200) {
      var items = response.data;

      setState(() {
        resultList = items;
        _pointerValue = resultList["bdisum"].toDouble();
        _aft = resultList["aft"].toDouble();
        _smt = resultList["smt"].toDouble();
        _cgt = resultList["cgt"].toDouble();
        isLoading = false;
      });

      setState(() {
        Map<String, dynamic> resultList;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) -
        50;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              color: Colors.black,
              icon: Icon(Icons.code_outlined),
              onPressed: () {
                Navigator.pushNamed(context, '/test');
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            !isLoading
                // Healthy mind meter
                ? Padding(
                    padding: EdgeInsets.only(left: size / 18, right: size / 18),
                    child: Card(
                      elevation: 6,
                      shadowColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          )),
                      child: Column(children: [
                        SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: Text(resultList["description"],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        SizedBox(height: 15),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 10,
                            thumbColor: Colors.white,
                            activeTickMarkColor: Colors.white,
                            activeTrackColor: Color(0xFFE88C4F),
                            inactiveTrackColor: Colors.grey,
                            inactiveTickMarkColor: Colors.white,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 10),
                          ),
                          child: AbsorbPointer(
                            child: Slider(
                                label: _pointerValue.toString(),
                                divisions: 6,
                                value: 63 - _pointerValue,
                                min: 0,
                                max: 63,
                                onChanged: (value) {
                                  setState(() {
                                    _pointerValue = value;
                                  });
                                }),
                          ),
                        ),
                        Text(resultList["solution"],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        SizedBox(height: 24)
                      ]),
                    ),
                  )
                // SpeedoMeter(
                //     size: size,
                //     pointerValue: _pointerValue,
                //     resultList: resultList)
                : Container(child: Card()),
            SizedBox(height: 24),
            Container(
              width: 700,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    // 인지영역 요소
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("원인을 파악했어요 🕵🏻‍♂️",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("우울증을 느낄 요소가 많았어요",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Brian님과 대화 중에 수집한 정보에 의하면 \n자기비판, 죄책감과 같은 우울증의 원인 요소들을 \n많이 느끼고 계신거 같아 보여요.\n주변 환경, 과거의 일이 관련이 있는 경우가 많아요",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: 24),
                    Divider(),
                    SizedBox(height: 24),
                    // 감정영역 요소
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("혹시 요즘..",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("슬픈 감정을 자주 느끼시나요?",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "대화 중에 제가 느낀 Brian님의 감정상태는\n슬픈 감정을 자주 느끼시는 걸로 보여요\n떨쳐내려고 하기보다 조용한 노래를 들으며 슬픈 감정의 원인이 무엇인지 생각해봐요",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: 24),
                    Divider(),
                    SizedBox(height: 24),
                    // 감정영역 요소
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("자주 깜빡깜빡 하신다면🤦🏻",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("내 기억력 누가 훔쳐갔지?",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "집중력과 기억력에 문제가 생기신거 같네요\n심한 스트레스나 우울증에도 이런 증상이 나타나요\n몇가지 방법으로 다시 되찾을 수 있어요",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: 24),
                    Divider(),
                    SizedBox(height: 24),
                    !_showCharts
                        ? TextButton(
                            style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                alignment: Alignment.center),
                            onPressed: () {
                              setState(() => {_showCharts = true});
                            },
                            child: Column(children: [
                              Text("내 통계 보기",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              Icon(Icons.bar_chart, size: 25),
                            ]),
                          )
                        : Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("내 통계",
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("지금까지 수집된 통계",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),

                              // place for chart1
                              SizedBox(height: 100),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("일주일 간 사용 통계",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),

                              // place for chart2
                              SizedBox(height: 100),
                              TextButton(
                                style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory,
                                    alignment: Alignment.center),
                                onPressed: () {
                                  setState(() => {_showCharts = false});
                                },
                                child: Column(children: [
                                  Text("내 통계 접기",
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  Icon(Icons.bar_chart,
                                      size: 25, color: Colors.grey)
                                ]),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                //scrollDirection: Axis.vertical,
                onPageChanged: (index, reason) {
                  setState(
                    () {
                      _currentIndex = index;
                    },
                  );
                },
              ),
              items: imagesList
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        margin: EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        elevation: 6.0,
                        shadowColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Image.network(
                                item,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Center(
                                child: Text(
                                  '${titles[_currentIndex]}',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: Colors.black45,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
