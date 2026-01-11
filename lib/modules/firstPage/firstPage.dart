import 'package:bmi/modules/myprofile/myprofile.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget{
  @override
  State<FirstPage> createState()=> _FirstPageState();
}
class _FirstPageState extends State<FirstPage>{
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.water_drop),
        title:Text('HydroHero'),

      ),
      body:Center(
        child:MyProfileScreen(first:true),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, 'home');
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
