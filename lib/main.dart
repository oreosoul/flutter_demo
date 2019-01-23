import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_layout/CityWidget.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '天气',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: CityWidget(),
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  String cityName;
  WeatherWidget(this.cityName);
  @override
  WeatherState createState() => new WeatherState(this.cityName);
}
class WeatherState  extends State<WeatherWidget> {
  String cityName;
  WeatherData weather = WeatherData.empty();

  WeatherState(String cityName) {
    this.cityName = cityName;
    _getWeather();
  }

  void _getWeather() async{
    WeatherData data = await _fetchWeather();
    setState((){
      weather = data;
    });
  }

  Future<WeatherData> _fetchWeather() async{
    final response = await http.get('https://free-api.heweather.net/s6/weather/now?location='+this.cityName+'&key=dcaa473694ff42d488bccc3c9bf85a9f');
    if(response.statusCode == 200){
      return WeatherData.fromJson(json.decode(response.body));
    }else{
      return WeatherData.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image.asset("images/weather_bg.jpg", fit:BoxFit.fitHeight),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 40.0),
                child: new Text(
                  this.cityName,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              new Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 60.0),
                child: new Column(
                  children: <Widget>[
                    new Text(
                      weather?.tmp+"°",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 64.0,
                      ),
                    ),
                    new Text(
                      weather?.cond,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    new Text(
                      "湿度："+weather?.hum+"%",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherData{
  String cond; //天气
  String tmp;
  String hum;

  WeatherData({this.cond, this.tmp, this.hum});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return new WeatherData(
      cond: json["HeWeather6"][0]["now"]["cond_txt"],
      tmp: json["HeWeather6"][0]["now"]["tmp"],
      hum: json["HeWeather6"][0]["now"]["hum"],
    );
  }
  factory WeatherData.empty() {
    return new WeatherData(
      cond: "-",
      tmp: "-",
      hum: "-",
    );
  }
}