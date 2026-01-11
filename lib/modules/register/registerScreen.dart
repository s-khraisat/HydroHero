import 'package:bmi/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatefulWidget{
  @override
  State<RegisterScreen> createState()=> _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  var formkey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var nameController=TextEditingController();
  var passwordController2=TextEditingController();
  bool ispass=true;
  bool ispassconf=true;

 




  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.water_drop),
        title:Text('Register'),

      ),
      body:Center(
        child: SingleChildScrollView(
          child:Padding(padding: EdgeInsets.all(20.0),
        child:Form(
          key:formkey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Register',style:TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            defaultFormField(
              controller: nameController, 
              type: TextInputType.text, 
              validator: (val){
                if(val!.isEmpty) return "Name must't be empty";
                return null;
              }, 
              label: 'Name',
               prefix: Icons.person),
            SizedBox(height: 15),
            defaultFormField(
              controller: emailController, 
              type: TextInputType.emailAddress, 
              validator: (val){
                if(val!.isEmpty) return"Email mustn't be empty";
                return null;
              }, 
              label: 'Email Address', 
              prefix: Icons.email),
            SizedBox(height: 15),
            defaultFormField(
              controller: passwordController, 
              type: TextInputType.visiblePassword, 
              validator: (val){
                if(val!.isEmpty) return"Password mustn't be empty";
                return null;
              }, 
              label: 'Password', 
              prefix: Icons.lock,
              isPassword: ispass,
              suffix: ispass?Icons.visibility:Icons.visibility_off,
              suffixPressed: () => setState(() {
                ispass = !ispass;
              }),
              ),
            SizedBox(height: 15),
            defaultFormField(
              controller: passwordController2, 
              type: TextInputType.visiblePassword, 
              validator: (val){
                if(val!.isEmpty) return"Confirm Password mustn't be empty";
                if(val!=passwordController.text) return"Passwords do not match";
                return null;
              }, 
              label: 'Confirm Password', 
              prefix: Icons.lock,
              suffix: ispassconf?Icons.visibility:Icons.visibility_off,
              isPassword: ispassconf,
              suffixPressed: ()=>setState(
                (){
                  ispassconf=!ispassconf;
                }
              ),),
            SizedBox(height: 30),
            defaultButton(
              function: (){
                
                if(formkey.currentState?.validate()??false){
                signUp(context);
                
                  
                }
                
              }, 
              text: 'Register',
              isUpperCase: true,),
            Row(
              children: [
                Text("Already have an account?"),
                TextButton(
                  onPressed: (){Navigator.pushNamed(context, 'login');}, 
                  child:Text('Login Now'))
              ],
            ),
            
            

          ],
        ),),
        ),
  )     ),
    );
  }

  Future<void> signUp(BuildContext context) async{
    try{
       final user=await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim());
        if(user!=null){
          await user.user!.updateDisplayName(nameController.text.trim());
          await user.user!.reload();
          await FirebaseFirestore.instance.collection('users').doc(user.user?.uid).set({
            'uid':user.user?.uid,
            'name':nameController.text,
            'email':emailController.text,
            'created at':FieldValue.serverTimestamp(),
          });
        }
      Navigator.pushNamedAndRemoveUntil(context, 'firstProfile', (route) => false);
    }on FirebaseAuthException catch (e) {
  String errorMessage;

  switch (e.code) {
    case 'email-already-in-use':
      errorMessage = 'This email is already registered.';
      break;
    case 'invalid-email':
      errorMessage = 'Please enter a valid email.';
      break;
    case 'weak-password':
      errorMessage = 'Password is too weak.';
      break;
    case 'invalid-credential':
      errorMessage = 'The email or password is incorrect.';
      break;
    case 'passwords-do-not-match':
      errorMessage = 'The passwords do not match.';
      break;
    default:
      errorMessage = 'Registration failed. Try again.';
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(errorMessage)),
  );
}
  }
  
  }