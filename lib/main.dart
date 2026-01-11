import 'package:bmi/modules/firstPage/firstPage.dart';
import 'package:bmi/modules/home/HomeScreen.dart';
import 'package:bmi/modules/login/login_screen.dart';
import 'package:bmi/modules/register/registerScreen.dart';
import 'package:bmi/modules/Progress/progress.dart';
import 'package:bmi/modules/reset%20password/password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   
  runApp(MyApp());
}
class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  bool isLoggedIn = false;
  bool isLoading = true;
  void initState(){
    super.initState();
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    bool userExists = false;
    try{
      final user=FirebaseAuth.instance.currentUser;

      if(user!=null){
        final doc=await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if(doc.exists){
          userExists = true;
        }else{
          userExists = false;
        }}
        else{
          userExists = false;
        }
        setState(() {
      isLoggedIn = userExists;
      isLoading = false;
        });

    }catch(e){
      print('Error checking auth state: $e');
      setState(() {
      isLoggedIn =false;
      isLoading = false;
      });
    }
    
    
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[500],
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.blue.withOpacity(0.5),
        ),
        useMaterial3: true,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,   // FAB color
      foregroundColor: Colors.white,  // icon color
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
      ),
      routes: {
        'login':(context)=>LoginScreen(),
        'register':(context)=>RegisterScreen(),
        'home':(context)=>Homescreen(),
        'progress':(context)=>ProgressScreen(),
        'resetPassword':(context)=>resetPasswordScreen(),
        'firstProfile':(context)=>FirstPage(),
      },
      
      home:isLoggedIn? Homescreen() : LoginScreen(),
      
    );
  }

}