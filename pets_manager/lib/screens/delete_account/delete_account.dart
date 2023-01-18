// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sized_box_for_whitespace, avoid_print
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../login_screen/login_screen.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({ Key? key }) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  
  TextEditingController currentPassword = TextEditingController();   
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteAccount() async {
    if(currentPassword.text.isEmpty)
      Constants.showDialog('Enter your current password');
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      await deleteUser();
      EasyLoading.dismiss();
    }
  }

  Future deleteUser() async {
    try {
      User user = _auth.currentUser!;
      AuthCredential credentials = EmailAuthProvider.credential(email: Constants.appUser.email, password: currentPassword.text);
      print(user);
      UserCredential result = await user.reauthenticateWithCredential(credentials);
      await deleteuser(result.user!.uid);
      await result.user!.delete();
      Get.offAll(LoginScreen());
      Constants.showDialog("Your account has been deleted");
      return true;
    } 
    on FirebaseAuthException catch (e) {
      if(e.code.toString() == "wrong-password")
        Constants.showDialog('Your entered password is wrong');
    }
    catch(e){
      print(e.toString());
    }
  }
 
  Future deleteuser(String userId) {
    return userCollection.doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text('Delete Acount', style: TextStyle(color: Colors.white, fontSize: SizeConfig.fontSize*2.2),),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + SizeConfig.blockSizeVertical* 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
            Container(
              height: SizeConfig.blockSizeVertical * 8,
              child: Center(
                child: Text(
                  'Enter your current password\nto delete account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.fontSize*2.2,
                    fontWeight: FontWeight.w500,
                    color: Colors.red
                  ),
                ),
              ),
            ),

            
            Container(
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6, right: SizeConfig.blockSizeHorizontal * 6, top: SizeConfig.blockSizeVertical * 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 1
                )
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(fontSize: SizeConfig.fontSize * 1.8, color: Colors.black),
                  controller: currentPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    hintText: 'Current Password',
                    hintStyle: TextStyle(fontSize: SizeConfig.fontSize * 1.8,),
                    fillColor: Colors.grey[100],
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: deleteAccount,
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
                  height: SizeConfig.blockSizeVertical * 6,
                  width: SizeConfig.blockSizeHorizontal* 40,
                  decoration: BoxDecoration(
                    color: Constants.appThemeColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Delete',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize*2.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}