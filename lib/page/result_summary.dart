import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:gauges/gauges.dart';
import 'package:speech_to_text_example/controllers/preference.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ResultSummary extends StatefulWidget {
  const ResultSummary({Key key}) : super(key: key);

  @override
  _SegmentsPageState createState() => _SegmentsPageState();
}

class _SegmentsPageState extends State<ResultSummary> {
  // var url = "http://192.168.0.37:5001/api/result/";
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
              onPressed: () {}),
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
                      elevation: 4,
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
                      child: Text("우울증을 느낄원인 요소가 많아요",
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
                        "Brian님과 대화 중에 수집한 정보에 의하면 \n자기비판, 죄책감과 같은 우울증의 원인 요소들을 \n많이 느끼고 계신거 같아요",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: 24),
                    Divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeedoMeter extends StatelessWidget {
  const SpeedoMeter({
    Key key,
    @required this.size,
    @required double pointerValue,
    @required this.resultList,
  })  : _pointerValue = pointerValue,
        super(key: key);

  final double size;
  final double _pointerValue;
  final Map<String, dynamic> resultList;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(children: [
        Positioned(
          top: size - 150,
          left: size - 200,
          child: Container(
            color: Colors.yellow,
            child: Text(
                _pointerValue == null
                    ? "데이터 없음"
                    : _pointerValue < 10
                        ? "정상"
                        : _pointerValue >= 10 && _pointerValue < 19
                            ? "경증"
                            : _pointerValue >= 19 && _pointerValue < 30
                                ? "중증"
                                : _pointerValue >= 30 && _pointerValue <= 63
                                    ? "심각"
                                    : "없음",
                style: TextStyle(fontSize: 30)),
          ),
        ),
        Positioned(
          top: size - 100,
          left: size - 320,
          child: Container(
            color: Colors.yellow,
            child:
                Text(resultList["description"], style: TextStyle(fontSize: 17)),
          ),
        ),
        SizedBox(
          width: size,
          height: size,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: RadialGauge(
              axes: [
                RadialGaugeAxis(
                  minValue: 0,
                  maxValue: 93,
                  minAngle: -90,
                  maxAngle: 180,
                  radius: 0.7,
                  width: 0.2,
                  segments: [
                    RadialGaugeSegment(
                      minValue: 0,
                      maxValue: 20,
                      minAngle: -90,
                      maxAngle: -153 + 100.0 - 6,
                      color: Colors.blue,
                    ),
                    RadialGaugeSegment(
                      minValue: 20,
                      maxValue: 40,
                      minAngle: -118.0 + 60,
                      maxAngle: -140.0 + 120 - 16,
                      color: Colors.green,
                    ),
                    RadialGaugeSegment(
                      minValue: 40,
                      maxValue: 60,
                      minAngle: -155.0 + 120,
                      maxAngle: -150.0 + 180 - 36,
                      color: Colors.orange,
                    ),
                    RadialGaugeSegment(
                      minValue: 60,
                      maxValue: 80,
                      minAngle: -185.0 + 180,
                      maxAngle: -150.0 + 240,
                      color: Colors.red,
                    ),
                  ],
                  pointers: [
                    RadialNeedlePointer(
                      value: _pointerValue,
                      thicknessStart: 15,
                      thicknessEnd: 0,
                      length: 0.7,
                      knobRadiusAbsolute: 10,
                      gradient: LinearGradient(
                        colors: [
                          Color(Colors.grey[400].value),
                          Color(Colors.grey[400].value),
                          Color(Colors.grey[600].value),
                          Color(Colors.grey[600].value)
                        ],
                        stops: [0, 0.5, 0.5, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
