import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/weather.dart';
import '../utilities/constants.dart';
import '../widgets/min_max_text.dart';
import '../widgets/weather_details.dart';
import 'area_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String areaName;
  String weatherMessage;
  int humidity;
  int airPreasure;
  int visibility;
  double tempMin;
  double tempMax;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: const Text('Check Spelling! Returning Current Weather'),

        ));

        update();
        temperature = 0;
        weatherIcon = weather.getWeatherIcon(temperature);
        weatherMessage = '';
        areaName = '';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      areaName = weatherData['name'];
       humidity = weatherData['main']['humidity'];

      airPreasure = weatherData['main']['pressure'];
      visibility = weatherData['visibility'];

       tempMin = weatherData['main']['temp_min'];
      tempMax = weatherData['main']['temp_max'];
      print(weatherData);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/location_background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: ()  {
                       update();
                      },
                      child: Icon(
                        Icons.near_me,
                        size: 35.0,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AreaScreen();
                            },
                          ),
                        );
                        if (typedName != null) {
                          var weatherData =
                              await weather.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                      },
                      child: Icon(
                        Icons.location_city,
                        size: 35.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 45,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Text(
                            '$temperature°',
                            style: TextStyle(
                              fontFamily: CupertinoIcons.iconFont,
                              fontSize: 50.0,
                              color:
                              temperature < 10 ? Colors.blue : (temperature>=10 && temperature<=20) ? Colors.black : Colors.red
                            ),
                          ),
                          Text(
                            weatherIcon,
                            style: kConditionTextStyle,
                          ),
                          Text(
                            '(In $areaName)',
                            style: kMessageTextStyle,
                          ),

                        ],
                      ),
                      SizedBox(height: 30,),

                      Text(weatherMessage,style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,

                      ),),
                    ],
                  ),
                ),
               SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  MinMaxText(text: 'Min',),
                  MinMaxText(text: '|',),
                  MinMaxText(text: 'Max',),

                ],),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MinMaxText(text: '$tempMin',),
                    MinMaxText(text: '|',),
                    MinMaxText(text: '$tempMax',),

                  ],),
                SizedBox(
                  height: 75,
                ),
                
                Text('Weather Details',style: TextStyle(
                  fontFamily: CupertinoIcons.iconFont,
                  fontSize: 20,
                ),),

                WeatherDetails(title: 'Humidity',data: humidity,unit: '%',icon: Icons.water_drop,),
                WeatherDetails(title: 'Air pressure',data: airPreasure,unit: 'hPa',icon: Icons.wind_power,),
                WeatherDetails(title: 'Visibility',data: visibility,icon: Icons.wind_power,),
               
                      ],
                    ),
                  ),
                ),
      ),

    );
  }

  Future<void> update()
  async {
    var weatherData = await weather.getLocationWeather();
    updateUI(weatherData);
  }
}
