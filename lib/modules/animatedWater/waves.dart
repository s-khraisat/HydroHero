import 'dart:math';

import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double time;
  final double percentage;
  WavePainter({required this.time, required this.percentage});

  @override
  void paint(Canvas canvas,Size size){
    double totalWaveHeight=size.height*percentage;//لوين موصلة؟
    double fullCycle=size.width;//لوين عرضها يعني الطول الموجي
    double waveSpeed=1.5;
    double animationRange = size.height *0.05;//الموجة بتتحرك ب 0.05 من الشاشة لفوق و تحت
    double dynamicHeight = totalWaveHeight + sin(time * 2 * pi) * animationRange;//base height+sin term*range of waving

    final pathMain=Path();
    pathMain.moveTo(0, size.height);//bottom left is start point
    //getting y 
    for(double x=0;x<=size.width;x++){
      double yMain=
      size.height-//start from bottom
      dynamicHeight-//start waves above the target height
      (sin((x / fullCycle * 2 * pi) + (time * waveSpeed * 2 * pi)) //waves
        * animationRange);
       pathMain.lineTo(x, yMain);
    }

    //finishing the path
    pathMain.lineTo(size.width, size.height);//bottom right is end point
    pathMain.close();
    //painting the waves
    final paintMain=Paint()
    ..color=Colors.blue.withValues(alpha: 0.6)
    ..style=PaintingStyle.fill;

    //draw the path
    canvas.drawPath(pathMain, paintMain);
    

  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>true;//so the waves will move

 }
class WaveAnimation extends StatefulWidget{
final double height;
final double width;
final double percentage;
WaveAnimation({this.height=200,this.width=200,this.percentage=0});

  @override
  State<WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState(){
    super.initState();
    _controller=AnimationController(
      vsync:this,//dont use any not needed cpu ,singletricker is needed
      duration: Duration(seconds: 8),)//one cycle duration
      ..repeat();//repeat
  }

  @override
  void dispose(){
    _controller.dispose();//when the widget is removed the animation is removed
    super.dispose();
  }

  @override
  Widget build(context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: WavePainter(
              time: _controller.value,
              percentage: widget.percentage,
            ),
            child: child,
          );
        },
        child: Container(), // ensures the painter has layout constraints
      ),
    );
  }
}