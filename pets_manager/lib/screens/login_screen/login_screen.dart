// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../forgot_password/forgot_password.dart';
//import '../home_screen/home_screen.dart';
import '../home_screen/home_screen.dart';
import '../signup_screen/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  
  @override
  void initState() {
    super.initState();
  }

  //LOGIN METHOD
  void signInPressed() async {
    if (email.text.isEmpty)
      Constants.showDialog("Please enter email address");
    else if (!GetUtils.isEmail(email.text))
      Constants.showDialog( "Please enter valid email address");
    else if (password.text.isEmpty)
      Constants.showDialog( "Please enter password");
    else {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().signInUser(email.text, password.text);
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
                          'Login',
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
                        'Please enter your account\nregistration details',
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
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                      onTap: (){
                        Get.to(ForgotPassword());
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1.5),
                        child: Text(
                          'Forgot Password?',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize :SizeConfig.fontSize * 1.8,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
      
                    GestureDetector(
                      onTap: signInPressed,
                      child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 4, left: SizeConfig.blockSizeHorizontal*10, right: SizeConfig.blockSizeHorizontal*10),
                        height: SizeConfig.blockSizeVertical *6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            'Login',
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
                            text: 'Don\'t have an account ?',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: SizeConfig.fontSize * 1.8),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Register Now',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.fontSize * 1.8
                                ),
                                recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                    Get.to(const SignUpScreen());                      
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