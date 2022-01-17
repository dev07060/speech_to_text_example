import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultSummary extends StatefulWidget {
  const ResultSummary({Key key}) : super(key: key);

  @override
  _SegmentsPageState createState() => _SegmentsPageState();
}

class _SegmentsPageState extends State<ResultSummary> {
  String email = "1111@test.net";
  // var url = "http://192.168.0.37:5001/api/result/";
  var url = "http://192.168.0.37:5001/api/result/";

  double _pointerValue = 0;
  double _aft = 0;
  double _cgt = 0;
  double _smt = 0;
  bool isLoading = false;
  Map<String, dynamic> resultList;

  @override
  void initState(){
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

    response = await dio.get("$url$email");
    if(response.statusCode == 200){
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
            MediaQuery.of(context).size.height) - 50;
    return Scaffold(
      appBar: AppBar(
        title: Text('Segments'),
        actions: [
          IconButton(icon: Icon(Icons.code_outlined), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: size/18, right: size/18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              !isLoading?
              SpeedoMeter(size: size, pointerValue: _pointerValue, resultList: resultList):
              Container(
                child: Card()
              ),
              // SizedBox(height: 24),
              // Slider(
              //     value: _pointerValue,
              //     min: 0,
              //     max: 63,
              //     onChanged: (value) {
              //       setState(() {
              //         _pointerValue = value;
              //       });
              //     }),
              // SizedBox(height: 15),
              // Text(_pointerValue.round().toString()),
              Row(
                children: [
                  Stack(
                    children:[
                      Card(
                            child: SizedBox(
                              height:size/3.2,
                              width: size/3.2,
                                child: RadialGauge(
                                  axes: [
                                    RadialGaugeAxis(
                                      minValue: 0,
                                      maxValue: 130,
                                      minAngle: -130,
                                      maxAngle: 100,
                                      radius: 0.7,
                                      width: 0.1,
                                      segments: [
                                        RadialGaugeSegment(
                                          minValue: 0,
                                          maxValue: 80,
                                          minAngle: -130,
                                          maxAngle: 40 + 60.0 - _aft,
                                          color: Colors.green,
                                        )
                                      ]
                                    )
                                  ]
                                )
                            )
                          ),
                      Positioned(
                        top: size/8,
                          left: size/10,
                          child: Text("$_aft%", style:TextStyle(fontSize:20))
                      )
                    ]
                  ),Stack(
                    children:[
                      Card(
                            child: SizedBox(
                              height:size/3.2,
                              width: size/3.2,
                                child: RadialGauge(
                                  axes: [
                                    RadialGaugeAxis(
                                      minValue: 0,
                                      maxValue: 130,
                                      minAngle: -130,
                                      maxAngle: 100,
                                      radius: 0.7,
                                      width: 0.1,
                                      segments: [
                                        RadialGaugeSegment(
                                          minValue: 0,
                                          maxValue: 80,
                                          minAngle: -130,
                                          maxAngle: 40 + 60.0 - _smt,
                                          color: Colors.green,
                                        )
                                      ]
                                    )
                                  ]
                                )
                            )
                          ),
                      Positioned(
                        top: size/8,
                        left: size/10,
                          child: Text("$_smt%", style:(TextStyle(fontSize:20)))
                      )
                    ]
                  ),
                  Stack(
                    children:[
                      Card(
                            child: SizedBox(
                              height:size/3.2,
                              width: size/3.2,
                                child: RadialGauge(
                                  axes: [
                                    RadialGaugeAxis(
                                      minValue: 0,
                                      maxValue: 130,
                                      minAngle: -130,
                                      maxAngle: 100,
                                      radius: 0.7,
                                      width: 0.1,
                                      segments: [
                                        RadialGaugeSegment(
                                          minValue: 0,
                                          maxValue: 80,
                                          minAngle: -130,
                                          maxAngle: 40 + 60.0 - _cgt,
                                          color: Colors.green,
                                        )
                                      ]
                                    )
                                  ]
                                )
                            )
                          ),
                      Positioned(
                        top: size/8,
                        left: size/10,
                          child: Text("$_cgt%", style:(TextStyle(fontSize:20)))
                      )
                    ]
                  ),
                ]
              )
            ],
          ),
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
  }) : _pointerValue = pointerValue, super(key: key);

  final double size;
  final double _pointerValue;
  final Map<String, dynamic> resultList;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
          children: [
        Positioned(top: size-150, left: size-200,
            child:Container(
              color:Colors.yellow,
              child: Text(
                  _pointerValue == "undefined"
              ? "데이터 없음"
                  : _pointerValue < 10
              ? "정상"
                  : _pointerValue >= 10 && _pointerValue < 19
              ? "경증"
                  : _pointerValue >= 19 && _pointerValue < 30
              ? "중증"
                  : _pointerValue >= 30 && _pointerValue <= 63
              ? "심각"
                  : "없음"
              , style: TextStyle(fontSize: 30)),
            ),
        ),
        Positioned(top: size-100, left: size-320,
          child:Container(
            color:Colors.yellow,
            child: Text(
                resultList["description"]
                , style: TextStyle(fontSize: 17)),
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
      ]
      ),
    );
  }
}
