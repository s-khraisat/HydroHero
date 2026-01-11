import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bmi/shared/components/components.dart';

class resetPasswordScreen extends StatefulWidget{
  @override
  State<resetPasswordScreen> createState()=> _resetPasswordScreenState();
}
class _resetPasswordScreenState extends State<resetPasswordScreen>{
  var emailController=TextEditingController();
  var formKey=GlobalKey<FormState>();

  

  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        leading: Icon(Icons.water_drop),
        title:Text('Reset Password'),

      ),
      body:
      
           Center(child: SingleChildScrollView(
        child:Padding(
        padding:EdgeInsets.all(20),
        child:Form(
          key:formKey,
          child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text('Reset Password',style:TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
          SizedBox(
            height: 40,
          ),
          defaultFormField(
            controller: emailController, 
            type: TextInputType.emailAddress, 
            validator: (val){
            if(val!.isEmpty){
              return 'Email Address couldn\'t be empty';
            }
            return null;
          }, 
            label: 'Email Address', 
            prefix: Icons.email,
            )
          
          ,       SizedBox(
          height:15,
        ),
        defaultButton(
          function: (){
            if(formKey.currentState!.validate()){
              //send reset password email
              FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text).then((value){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset email sent')));
              }).catchError((error){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error occurred')));
              });
            }
          }, 
          text: 'Send Reset Email',
          ),
        ],
      ),
        ),
      ),
      )),
    );
  }
  
  }