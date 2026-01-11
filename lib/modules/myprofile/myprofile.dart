import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  bool first;
  MyProfileScreen({this.first=false});
  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>{
  final user=FirebaseAuth.instance.currentUser;
  bool isMale=false;
   double height=159;
   int weight=67;
   int age=21;
   String selectedClimate='Cool';
   String selectedActivity='Low';
   double result=0,current=0;
  bool isSaved=false;
  String btntxt='Save';
  String lastDate='';
  
  

 void initState(){
    super.initState();
  }
  
  
  @override
  void calculateWater(){
    result=weight*30;
                if(selectedActivity=='Medium') result+=400;
                else if(selectedActivity=='High') result+=850;
                if(selectedClimate=='High') result+=500;
    
  }
  
  Widget build(BuildContext context){
    
    return Container(
      
      child:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(//gender div
              child: 
              Padding(
                padding:  EdgeInsets.all(20.0),
                child:Row(
                children: [
                  Expanded(
                    child:GestureDetector(
                      onTap:(){
                        setState(() {
                          isMale=true;
                        });
                      } ,
                      child:Container(
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isMale?Colors.blue:const Color.fromARGB(126, 57, 158, 240),
                    ),
                    child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image:AssetImage('assets/images/male.webp'),height:90,width:90),
                      SizedBox(height: 15,),
                      Text('MALE',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                    ],
                  ),
                    
                  ),
                    ),),
                    SizedBox(width: 20,),
                  Expanded(
                    child:
                    GestureDetector(
                      onTap: (){
                        setState((){
                          isMale=false;
                        });
                      },
                      child:Container(
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isMale? Color.fromARGB(126, 57, 158, 240):Colors.blue,
                    ),
                    child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image:AssetImage('assets/images/female.png'),height:90,width:90),
                      SizedBox(height: 15,),
                      Text('FEMALE',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                    ],
                  ),
                    
                  ),
                    ),),
         
                ],
              ),
              ),
            ),
            SizedBox(//height div
              child:Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(126, 57, 158, 240),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('HEIGHT',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${height.round()}',style:TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
                      SizedBox(width: 5,),
                      Text('CM',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: height,
                    onChanged: (value){
                      setState(() {
                        height=value;
                      });
                    },
                    min: 80,
                    max: 220,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.blue.withOpacity(0.3),
                  ),
                ],
               ),
              ),),
               ),
            SizedBox(//weight and age div
              child:
              Padding(
                padding: EdgeInsets.all(20),
                child:Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(126, 57, 158, 240),
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('WEIGHT',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                            Text('$weight',style:TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton(heroTag: 'weight_minus_fab', onPressed: (){
                                  setState(
                                    (){
                                      weight--;
                                    }
                                  );
                                },mini: true,child:Icon(Icons.remove),),
                                FloatingActionButton(heroTag: 'weight_plus_fab', onPressed: (){
                                  setState(
                                    (){
                                      weight++;
                                    }
                                  );
                                },mini: true,child:Icon(Icons.add),),
                              ],
        
                            ),
        
                          ],
                        ),
                      )),
                  SizedBox(width:20),
                  Expanded(
                      child: Container(
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(126, 57, 158, 240),
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('AGE',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                            Text('$age',style:TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton(heroTag: 'age_minus_fab', onPressed: (){
                                  setState(
                                    (){
                                      age--;
                                    }
                                  );
                                },mini: true,child:Icon(Icons.remove),),
                                FloatingActionButton(heroTag: 'age_plus_fab', onPressed: (){
                                  setState(
                                    (){
                                      age++;
                                    }
                                  );
                                },mini: true,child:Icon(Icons.add),),
                              ],
        
                            ),
        
                          ],
                        ),
                      )),
        
                  ],
                ),
                ),
              ),
            SizedBox(//activity div
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(126, 57, 158, 240),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ACTIVITY LEVEL',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            
                            onTap: (){
                              setState(() {
                                selectedActivity='Low';
                              });
                            },
                            child: Container(
                              color: selectedActivity=='Low'?Colors.blue:Colors.transparent,
                              child: Column(
                                children: [
                                  Icon(Icons.directions_walk,size: 40,),
                                  SizedBox(height: 10,),
                                  Text('Low',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedActivity='Medium';
                              });
                            },
                            child: Container(
                              color: selectedActivity=='Medium'?Colors.blue:Colors.transparent,
                              child: Column(
                                children: [
                                  Icon(Icons.directions_run,size: 40,),
                                  SizedBox(height: 10,),
                                  Text('Medium',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                               selectedActivity='High';
                              });
                            },
                            child: Container(
                              color: selectedActivity=='High'?Colors.blue:Colors.transparent,
                              child: Column(
                                children: [
                                  Icon(Icons.fitness_center,size: 40,),
                                  SizedBox(height: 10,),
                                  Text('High',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        
            ),
            SizedBox(//climate div
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(126, 57, 158, 240),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tempreture LEVEL',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            
                            onTap: (){
                              setState(() {
                                selectedClimate='Cool';
                              });
                            },
                            child: Container(
                              color: selectedClimate=='Cool'?Colors.blue:Colors.transparent,
                              child: Column(
                                children: [
                                  Icon(Icons.ac_unit,size: 40,),
                                  SizedBox(height: 10,),
                                  Text('Cool',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedClimate='Normal';
                              });
                            },
                            child: Container(
                              color: selectedClimate=='Normal'?Colors.blue:Colors.transparent,
                              child: Column(
                                children: [
                                  Icon(Icons.thermostat,size: 40,),
                                  SizedBox(height: 10,),
                                  Text('Normal',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedClimate='Hot';
                              });
                            },
                            child: Container(
                              color: selectedClimate=='Hot'?Colors.blue:Colors.transparent,
                              child: Column(
                                children: [
                                  Icon(Icons.wb_sunny,size: 40,),
                                  SizedBox(height: 10,),
                                  Text('Hot',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        
            ),
         
            Container(//button
              color: Colors.blue,
              width:double.infinity,
              height: 70,
              child:MaterialButton(onPressed: (){
                if(isSaved){
                  isSaved=false;
                  setState(() {
                  btntxt='Save';
                    
                  });

                }else{
                  isSaved=true;
                  setState(() {
                 calculateWater();
                 insertData();
                 btntxt='Saved';
                });

                }
                
                 
                
              },
              child:Text(btntxt,style: TextStyle(color: Colors.white,fontSize: 40),),),)
          ,SizedBox(height: 30,),
          ],
        ),
      ),
 
    );
    
  }
 void insertData() async {
  final docRef = FirebaseFirestore.instance.collection('profiles').doc(user!.uid);
  final doc = await docRef.get();

  calculateWater(); // make sure waterNeeded is updated

  if (!doc.exists) {
    // create new profile
    await docRef.set({
      'uid': user!.uid,
      'name': user!.displayName,
      'gender': isMale ? 'M' : 'F',
      'height': height.round(),
      'weight': weight.round(),
      'age': age,
      'activity': selectedActivity,
      'climate': selectedClimate,
      'waterNeeded': result,
      'lastUpdated': DateTime.now(),
      'waterConsumed': 0,
      'progress': 0,
      'streak': 0,
      'lastDate': DateTime.now(),
      'treasureOpened':false,
    });
  } else {
    // update existing profile
    await docRef.update({
      'name': user!.displayName,
      'gender': isMale ? 'M' : 'F',
      'height': height.round(),
      'weight': weight.round(),
      'age': age,
      'activity': selectedActivity,
      'climate': selectedClimate,
      'waterNeeded': result,
      'lastUpdated': DateTime.now(),
    });
  }
}


  



}