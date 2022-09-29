import 'package:flutter/material.dart';

class WeatherDetails extends StatelessWidget {
  final int data;
  final String unit;
  final IconData icon;
  final String title;
  const WeatherDetails({Key key, this.data,this.unit='',this.icon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        title: Text(title,style: TextStyle(fontSize: 22),),
        subtitle: Text('$data$unit',style: TextStyle(fontSize: 18),),
        leading: Icon(icon,size: 35,),
      ),
    );
  }
}
