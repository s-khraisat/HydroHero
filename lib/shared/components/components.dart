import 'package:flutter/material.dart';



Widget defaultButton({
double width=double.infinity,
Color color=Colors.blue,
double radius=12,
bool isUpperCase=true,
required VoidCallback function,
required String text,

})=>
Container(
        width:width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: MaterialButton(
          onPressed: function,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
       );

Widget defaultFormField({
required TextEditingController controller,
required TextInputType type,
bool isPassword=false,
ValueChanged<String>?onChange,
ValueChanged<String>?onSubmit,
VoidCallback? onTap,
VoidCallback? suffixPressed,
required FormFieldValidator<String>? validator,
required String label,
required IconData prefix,
IconData? suffix,

})
=>
TextFormField(
          
            controller:controller,
            keyboardType: type,
            obscureText:isPassword,
            onFieldSubmitted:onSubmit,
            onChanged:onChange,
            onTap:onTap,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              prefixIcon: Icon(prefix),
              suffixIcon: suffix != null ? IconButton(onPressed:suffixPressed, icon: Icon(suffix)) : null,
              
                            
            ),
            validator: validator,
            
          );
 

       