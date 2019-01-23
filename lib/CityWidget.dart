import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_layout/CityData.dart';
import 'package:flutter_layout/main.dart';

class CityWidget extends StatefulWidget{
  @override
  CityWidgetState createState() => new CityWidgetState();
}
class CityWidgetState extends State<CityWidget> {
  List<CityData> cityList = new List<CityData>();

  CityWidgetState() {
    _getCityList();
  }

  void _getCityList() async {
    List<CityData> citys = await _fetchCityList();
    setState((){
      cityList = citys;
    });
  }
  Future<List<CityData>> _fetchCityList() async{
    final response = await http.get('https://search.heweather.net/top?group=cn&key=dcaa473694ff42d488bccc3c9bf85a9f');
    List<CityData> cityList = new List<CityData>();

    if(response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      for(dynamic data in result['HeWeather6'][0]['basic']){
        CityData cityData = new CityData(data['location']);
        cityList.add(cityData);
      }
      return cityList;
    }else{
      return cityList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: cityList.length,
      itemBuilder: (context,index) {
        return new ListTile(
          title: new GestureDetector(
            child: new Text(cityList[index].cityName),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherWidget(cityList[index].cityName))
              );
            },
          ),
        );
      },
    );
  }
}