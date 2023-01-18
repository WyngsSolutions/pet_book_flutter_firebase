// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/app_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../home_screen/home_screen.dart';
//import '../home_screen/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  
  @override
  void initState() {
    super.initState();
  }

  //LOGIN METHOD
  void signUpPressed() async {
    if (name.text.isEmpty)
      Constants.showDialog("Please enter name");
    else if (email.text.isEmpty)
      Constants.showDialog("Please enter email address");
    else if (!GetUtils.isEmail(email.text))
      Constants.showDialog( "Please enter valid email address");
    else if (password.text.isEmpty)
      Constants.showDialog( "Please enter password");
    else {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().signUpUser(name.text, email.text, password.text);
      EasyLoading.dismiss();     
      if (result['Status'] == "Success") 
      {
        Get.offAll(HomeScreen(defaultPage: 0,));
      }
      else
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: kToolbarHeight+ SizeConfig.blockSizeVertical*3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 17,
                width: SizeConfig.blockSizeHorizontal * 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo2.png'),
                  )
                ),
              ),
      
              Container(
                height: (SizeConfig.blockSizeVertical * 83 - kToolbarHeight - SizeConfig.blockSizeVertical*9),
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*6),
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*8),
                decoration: BoxDecoration(
                  color: Constants.appThemeColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3),
                      child: Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.fontSize*3,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.5),
                      child: Text(
                        'Your email is not shown to others and is only used for verification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize :SizeConfig.fontSize * 2,
                        ),
                      ),
                    ),
      
                    Container(
                      height: SizeConfig.blockSizeVertical *6,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 1
                        )
                      ),
                      child: Center(
                        child: TextField(
                          style: TextStyle(color: Colors.white, fontSize: SizeConfig.fontSize * 1.8),
                          keyboardType: TextInputType.emailAddress,
                          controller: name,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter username',
                            hintStyle: TextStyle(color: Colors.grey[200], fontSize: SizeConfig.fontSize * 1.8),
                            //contentPadding: EdgeInsets.symmetric(horizontal: 20)
                          ),
                        ),
                      ),
                    ),
      
                    Container(
                      height: SizeConfig.blockSizeVertical *6,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 1
                        )
                      ),
                      child: Center(
                        child: TextField(
                          style: TextStyle(color: Colors.white, fontSize: SizeConfig.fontSize * 1.8),
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter email address',
                            hintStyle: TextStyle(color: Colors.grey[200], fontSize: SizeConfig.fontSize * 1.8),
                            //contentPadding: EdgeInsets.symmetric(horizontal: 20)
                          ),
                        ),
                      ),
                    ),
      
                    Container(
                      height: SizeConfig.blockSizeVertical *6,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 1
                        )
                      ),
                      child: Center(
                        child: TextField(
                          style: TextStyle(color: Colors.white, fontSize: SizeConfig.fontSize * 1.8),
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter password',
                            hintStyle: TextStyle(color: Colors.grey[200], fontSize: SizeConfig.fontSize * 1.8),
                            //contentPadding: EdgeInsets.symmetric(horizontal: 20)
                          ),
                        ),
                      ),
                    ),
      
                    GestureDetector(
                      onTap: signUpPressed,
                      child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5, left: SizeConfig.blockSizeHorizontal*10, right: SizeConfig.blockSizeHorizontal*10),
                        height: SizeConfig.blockSizeVertical *6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Constants.appThemeColor,
                              fontSize: SizeConfig.fontSize * 2.1,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
      
                    Spacer(),
                    Container(
                      height: SizeConfig.safeBlockVertical * 5,
                      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
                      child: Center(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Already have an account ?',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: SizeConfig.fontSize * 1.8),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Login',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.fontSize * 1.8
                                ),
                                recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                    Get.back();                 
                                  }
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}