import 'package:bmi/modules/login/loginchar.dart';
import 'package:bmi/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bmi/modules/login/login_animation_controller.dart';
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen>{
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var formKey=GlobalKey<FormState>();
  bool show=true;

  

  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        leading: Icon(Icons.water_drop),
        title:Text('HydroHero'),

      ),
      body:
      
           Center(
            child: SingleChildScrollView(
        child:Padding(
        padding:EdgeInsets.all(20),
        child:Form(
          key:formKey,
          child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Center(
            child: CircleAvatar(
              radius: 150,
              backgroundColor: const Color(0xffd6e2ea),
              child:ClipOval(
                child: LoginAnimation(),
                
              ),
            ),
          ), 
          const SizedBox(height: 20),
          
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
            onTap: () => {
              setState(() {
                isHandsUp?.value = false;
                isTyping?.value = true;
              }),
            },
            onChange: (value) {
              setState(() {
                isTyping?.value = true;
                isHandsUp?.value = false;
              });
            
  },
            )
          
          ,       SizedBox(
          height:15,
        ),
        defaultFormField(
          controller: passwordController, 
          type: TextInputType.visiblePassword,
           validator: (val){
            if(val!.isEmpty){
              return 'Password couldn\'t be empty';
            }
            return null;
          }, 
           label: 'Password', 
           prefix: Icons.lock,
           isPassword: show,
           suffix: !show?Icons.visibility_off:Icons.remove_red_eye,
           suffixPressed: (){
            setState(() {
              show=!show;
            
            });
           },
            onTap: () {
              setState(() {
                isHandsUp?.value = true;
                isTyping?.value = false;
              });
            
            },
            onChange: (value) {
              setState(() {
                isTyping?.value = false;
              });
             
           },
           ),
         SizedBox(
          height:15,
        ),
       defaultButton(
        function: (){
          setState(() {
            isTyping?.value = false;
            isHandsUp?.value = false;
          });
          
          if(formKey.currentState?.validate()??false){
          signIn(context);
          
          
          }
          
          
        },
         text: 'login',
         isUpperCase: true,),
        SizedBox(
          height:5,
        ),
        Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text('Don\'t have an account?'),
            TextButton(
              onPressed: (){Navigator.pushNamed(context, 'register');}, 
              child:Text('Register Now')),
          ],
        ),
        TextButton(
              onPressed: ()=>{Navigator.pushNamed(context, 'resetPassword')},
              child: Text('Forget Password? Reset Now'))

          ],
        ),
        ],
        
      ),
 ),
      ),
      ),
 ),

    );
  }
Future signIn(BuildContext context)async{
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailController.text.trim(), 
    password:passwordController.text.trim(),);
    
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);

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
    default:
      errorMessage = 'Registration failed. Try again.';
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(errorMessage)),
  );
}

}




}