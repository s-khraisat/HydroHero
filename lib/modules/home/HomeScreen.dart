import 'dart:math';
import 'package:bmi/modules/login/login_animation_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bmi/modules/animatedWater/waves.dart';
import 'package:bmi/modules/myprofile/myprofile.dart';
import 'package:bmi/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



class Homescreen extends StatefulWidget{
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  //profile data
  bool isMale=false;
  double result=0,current=0;
  double height=159;
  int weight=67;
  int age=21;
  String selectedClimate='Cool';
  String selectedActivity='Low';
  var addingColor=Colors.grey[500];
  //other variables
  String lastDate='';
  bool todayCompleted=false;
  int completedDays=0;
  double waterNeeded=0,waterConsumed=0,glassHeight=400;
  var valuecontroller=TextEditingController();
  bool isBottomSheetShown = false;
  
  IconData fabIcon = Icons.edit;
  var scaffoldKey=GlobalKey<ScaffoldState>();
  late Stream<QuerySnapshot> userstream;
  late AnimationController _shakeController;
  late AnimationController _treasureController;
  int get characterIndex => completedDays-1;
  


  final user=FirebaseAuth.instance.currentUser;
  String msg(){
    if(waterConsumed==waterNeeded&&waterNeeded!=0){
      if(hasShownCompletionDialog){
        return 'Congratulations, ${user?.displayName?.toUpperCase() ?? 'Guest'}! You have unlocked the treasure! 🎉';
      }
      return '🏴‍☠️ Open the treasure! Tap it to reveal your reward!';
    }
    return'Welcome, ${user?.displayName?.toUpperCase() ?? 'Guest'}! 😁';}
  
  
  
  double currentGlassHeight(){
    if(waterNeeded == 0) return 0;
    return(glassHeight*(waterConsumed/waterNeeded));
  }
  @override
 void initState(){
    super.initState();
    _shakeController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _treasureController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();
    userstream=FirebaseFirestore.instance.collection('profiles').where('uid', isEqualTo: user!.uid).snapshots();
    loadUserData();
  }
  
  @override
  void dispose() {
    _shakeController.dispose();
    _treasureController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

   return Scaffold(
    key: scaffoldKey,
    
    appBar:AppBar(
      leading:Icon(Icons.water_drop),
      title: Text('HydroHero',style:TextStyle(color: Colors.white)),
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.card_giftcard),
          onSelected: (val){
            if(val==1) Navigator.pushNamed(context, 'progress');
          },
          itemBuilder: (context)=>[
            PopupMenuItem(child: Text('Your characters'),value: 1,),

            
          ]),
          IconButton(icon: Icon(Icons.logout), onPressed: () async {
            signOut(context);
            
            
          }),
      ],
    ) ,
    body:SingleChildScrollView(
      child: Column(
        children:[
          Container(//first div for msg
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.cyan[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.emoji_emotions,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    msg(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          StreamBuilder(
            stream: userstream,
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                final docData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
                waterNeeded = (docData['waterNeeded'] ?? 0).toDouble();
                waterConsumed = (docData['waterConsumed'] ?? 0).toDouble();
                treasureOpened = docData['treasureOpened'] ?? false;
                // Update local state with Firebase value
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (hasShownCompletionDialog != treasureOpened) {
                    setState(() {
                      hasShownCompletionDialog = treasureOpened;
                    });
                  }
                });
                return waterinfo(waterNeeded, waterConsumed);
              }else if(snapshot.hasError){
                return Center(child: Text('Error: ${snapshot.error}'),);
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            },
            
          ),
          
          Padding(//third div adding water
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Column(
                  children: [
                    AnimatedBuilder(
                      animation: _shakeController,
                      builder: (context, child) {
                        final shakeValue = 10.0 * (0.5 - (_shakeController.value - 0.5).abs());
                        return Transform.translate(
                          offset: Offset(shakeValue, 0),
                          child: child,
                        );
                      },
                      child: IconButton(
                        onPressed: ()async{
                          if(valuecontroller.text.isEmpty) {
                            _shakeController.forward(from: 0.0);
                            return;
                          }
                          //adding sound pouring water
                          final player=AudioPlayer();
                          await player.play(
                            AssetSource('sounds/water-pouring-405458.mp3')
                          );
                          
                          setState(() {
                            addingColor=Colors.grey[500];
                            
                            double addedValue=double.tryParse(valuecontroller.text)??0;
                            waterConsumed+=addedValue;
                            if(waterConsumed>waterNeeded){
                              waterConsumed=waterNeeded;
                            }
                            // Check if goal is completed
                            if(!todayCompleted && waterConsumed >= waterNeeded && waterNeeded > 0){
                              todayCompleted = true;
                              completedDays += 1;
                            }
                            valuecontroller.text='';
                            insertWaterData();
                            
                            
                          });
                          
                        }, icon: Icon(Icons.local_drink,size: 50,color: Colors.blue,)),
                    ),
                    Text('Add ',style:TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: addingColor)),
                  ],
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: defaultFormField(
                    onChange:(value) => {
                      setState(() {
                        addingColor=Colors.blue;
                      }),
                    }, 
                    controller: valuecontroller, 
                    type: TextInputType.number, 
                    validator: (val){
                      if(val!.isEmpty) return "Value must't be empty";
                      return null;
                    }, 
                    label: 'Add Water (ml)', 
                     prefix: Icons.water_drop),
                ),
                
              ],
            ),
          )
      
           ,StreamBuilder(
            stream: userstream, 
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
                final docData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
                double waveFill =(docData['progress'] ?? 0)/100;
                bool treasureOpened = docData['treasureOpened'] ?? false;
                return waterProgress(waveFill, treasureOpened);
              }else if(snapshot.hasError){
                return Center(child: Text('Error: ${snapshot.error}'),);
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            },),
            
           
           ],
        
      ),
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(fabIcon),
      onPressed: () { 
        if(isBottomSheetShown){
          Navigator.pop(context);
          isBottomSheetShown=false;
          
          setState(() {
            fabIcon=Icons.edit;
          });
        }else{
          isBottomSheetShown=true;
          setState(() {
            fabIcon=Icons.close;
          });
          scaffoldKey.currentState!.showBottomSheet(
            (context)=>MyProfileScreen(first:false),
          );

        }
       },),
    );
          
  



  }
  void insertWaterData()async{
    await FirebaseFirestore.instance.collection('profiles').doc(user!.uid).update(
      {
        'waterConsumed':waterConsumed,
        'lastUpdated':DateTime.now(),
        'progress': waterNeeded==0?0:(waterConsumed/waterNeeded)*100,
        'streak': completedDays,
        'lastDate': lastDate,
        'todayCompleted': todayCompleted,
        'treasureOpened': hasShownCompletionDialog,
      }
    );
   
  }

  Future<void> signOut(BuildContext context)async{
    try{
       await FirebaseAuth.instance.signOut();
       Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
           
    }catch(e){
      print('error: ${e.toString()}');
    }
  }


Widget waterinfo(double need,double consume){
    waterNeeded=need;
    waterConsumed=consume>need?need:consume;
    return
     SingleChildScrollView(
      scrollDirection: Axis.horizontal,
       child: Row(//second div water needed and consumed 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text('Water Needed',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                          SizedBox(height: 10,),
                          Text('${waterNeeded.toInt()} ml',style:TextStyle(fontSize: 16)),
                        ],
                      ),
                      
                    ),
                  ),//SizedBox(width: 20,),
                  GestureDetector(
                    onTap: () => _showEditWaterDialog(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Water Consumed',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                              SizedBox(width: 5,),
                              Icon(Icons.edit, size: 18, color: Colors.blue),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text('${waterConsumed.toInt()} ml',style:TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
     );
  }
String todayDate() {
  final now = DateTime.now();
  return '${now.year}-${now.month}-${now.day}';
}
void checkNewDay() async {
  final today = todayDate();
  
  // If it's a new day, reset for the new day
  if (lastDate != today) {
    setState(() {
      waterConsumed = 0;
      todayCompleted = false;
      hasShownCompletionDialog = false;
      lastDate = today;
    });
    await FirebaseFirestore.instance.collection('profiles').doc(user!.uid).update({
      'waterConsumed': 0,
      'lastDate': today,
      'todayCompleted': false,
      'treasureOpened': false,
    });insertWaterData();
    
  }
}
void loadUserData() async {
  final doc = await FirebaseFirestore.instance.collection('profiles').doc(user!.uid).get();
  if (doc.exists) {
    final data = doc.data() as Map<String, dynamic>;
    setState(() {
      lastDate = data['lastDate'] ?? '';
      completedDays = data['streak'] ?? 0;
      todayCompleted = data['todayCompleted'] ?? false;
      waterConsumed = (data['waterConsumed'] ?? 0).toDouble();
      waterNeeded = (data['waterNeeded'] ?? 0).toDouble();
      hasShownCompletionDialog = data['treasureOpened'] ?? false;
    });
    checkNewDay();
  }
}

void _showEditWaterDialog() {
  TextEditingController editController = TextEditingController(text: waterConsumed.toInt().toString());
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Water Consumed'),
      content: TextField(
        controller: editController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter amount in ml',
          border: OutlineInputBorder(),
          suffixText: 'ml',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            double newValue = double.tryParse(editController.text) ?? waterConsumed;
            // Cap at waterNeeded
            if(newValue > waterNeeded) newValue = waterNeeded;
            
            setState(() {
              waterConsumed = newValue;
              // Check if goal is completed
              if(!todayCompleted && waterConsumed >= waterNeeded && waterNeeded > 0){
                todayCompleted = true;
                completedDays += 1;
              }
            });
            insertWaterData();
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
}

Widget waterProgress(double waveFill, bool treasureOpened){
  return Padding(//fourth container the water bowl
             padding: const EdgeInsets.all(20.0),
          child: AnimatedBuilder(
            animation: _treasureController,
            builder: (context, child) {
              // Calculate swimming/shaking motion
              double animationRange = glassHeight * 0.05;
              double totalWaveHeight = glassHeight * waveFill;
              double dynamicHeight = totalWaveHeight + 
                sin(_treasureController.value * 2 * pi) * animationRange;
              
              // Get container width (accounting for padding)
              double containerWidth = MediaQuery.of(context).size.width - 40;
              
              // Center treasure horizontally
              double treasureX = (containerWidth / 2) - 75;
              
              // Place treasure inside the water with swimming shaking motion
              double waterDepth = glassHeight - dynamicHeight;
              // Place treasure on the surface of the water
              double treasureY = glassHeight - (waterDepth * 0.9) + 
                (sin(_treasureController.value * 4 * pi) * animationRange * 2);
              
              // Slight side-to-side shimmer (clamped to stay in bounds)
              double horizontalShake = sin(_treasureController.value * 3 * pi) * 20;
              
              // Clamp values to keep treasure inside container
              double clampedX = treasureX.clamp(0, containerWidth - 150);
              double clampedY = treasureY.clamp(10, glassHeight - 160);
              
              // Only show treasure if water level is at least 25% full
              bool showTreasure = waveFill >= 0.25;
              
              // Determine if hint should be shown based on progress
              bool shouldShowHint = waveFill >= 1.0 && !treasureOpened;
              
              return Stack(
                children: [
                  Container(
                    
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                        color: Colors.blue[300]!,
                        width: 3),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: WaveAnimation(
                      height: glassHeight,
                      width: double.infinity,
                      percentage: waveFill,
                    ),
                  ),
                  Positioned(
                    left: clampedX + horizontalShake,
                    top: clampedY,
                    child: Visibility(
                      visible: showTreasure,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Hint bubble above treasure
                          if (shouldShowHint)
                            Positioned(
                              top: -60,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.amber[600],
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.touch_app, color: Colors.white, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'Open the treasure!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // Treasure image
                          GestureDetector(
                            onTap: () async {
                              if (waveFill >= 1.0 && waterNeeded > 0) {
                                // Play chest opening sound
                                final player = AudioPlayer();
                                await player.play(
                                  AssetSource('sounds/chest.mp3')
                                );
                                
                                // Play joy sound after a short delay
                                Future.delayed(Duration(milliseconds: 500), () async {
                                  final joyPlayer = AudioPlayer();
                                  await joyPlayer.play(
                                    AssetSource('sounds/joy.mp3')
                                  );
                                });
                                
                                setState(() {
                                  hasShownCompletionDialog = true;
                                  treasureOpened = true;
                                });
                                insertWaterData();
                                
                                Future.delayed(const Duration(milliseconds: 600), () {
                                showCharacterUnlockedDialog();
                                });
                              }
                            },
                            child: Image(
                              image: AssetImage('assets/images/treasure.png'),
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
           );

  
}

String getName(int i){
  return characterNames[i-1];
}
void showCharacterUnlockedDialog() {
  final int characterIndex = completedDays; // 1-based
  final String lottiePath = 'assets/lottie/char_$characterIndex.json';

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🎁 New Character Unlocked!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
          SizedBox(height: 20),

          // 🔥 LOTTIE CHARACTER
          SizedBox(
            height: 180,
            child: Lottie.asset(
              lottiePath,
              repeat: true,
            ),
          ),

          SizedBox(height: 20),
          Text(
            'You unlocked ${getName(characterIndex)}!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 25),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: Text(
              'Nice! 🌱',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}

