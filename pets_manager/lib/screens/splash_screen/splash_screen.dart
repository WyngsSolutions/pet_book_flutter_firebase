// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
//import '../home_screen/home_screen.dart';
import '../home_screen/home_screen.dart';
import '../login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkIfUserLoggedIn();
    });
  }

  void checkIfUserLoggedIn() async {
    //Check User Login
    Constants.appUser = await AppUser.getUserDetail();
    if(Constants.appUser.email.isEmpty)   
      Get.offAll(const LoginScreen(),);
    else
    {
      Constants.appUser = await AppUser.getUserDetailByUserId(Constants.appUser.userId);
      //await AppController().getAllMyFavoriteProducts();
      Get.offAll(const HomeScreen(defaultPage: 0,),);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.blockSizeHorizontal * 30,
              width: SizeConfig.blockSizeHorizontal * 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo2.png'),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}