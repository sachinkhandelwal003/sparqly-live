import 'package:flutter/material.dart';

 class AppControllers
 {
     // On Board
     static final onboardpageController = PageController();

     // Login Page
      late final AnimationController  animationController;
     AppControllers({required TickerProvider vync})
     {
       animationController = AnimationController(vsync: vync ,duration: Duration(seconds: 7));
     }

     static final loginemailcontroller = TextEditingController();
     static final loginpasswordcontroller = TextEditingController();


     // Sign up
     static final signupemailcontroller = TextEditingController();
     static final signupfirstnamecontroller = TextEditingController();
     static final signuplastnamecontroller = TextEditingController();
     static final signuppasswordcontroller = TextEditingController();
     static final signupinstitutioncontroller = TextEditingController();

 }