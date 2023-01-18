// ignore_for_file: avoid_print
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class AppUser{

  String userId = "";
  String email = "";
  String name = "";
  String userProfilePicture = "";
  String oneSignalUserId = "";

  AppUser({this.userId = "", this.name = "", this.email = "", this.userProfilePicture = "", this.oneSignalUserId = ""});

  factory AppUser.fromJson(dynamic json) {
    AppUser user = AppUser(
      userId: json['userId'],
      name : json['name'],
      email : json['email'],
      userProfilePicture : json['userProfilePicture'],
      oneSignalUserId : json['oneSignalUserId'],
    );
    return user;
  }

  Future saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", this.userId);
    prefs.setString("name", this.name);
    prefs.setString("email", this.email);
    prefs.setString("oneSignalUserId", this.oneSignalUserId);
    prefs.setString("userProfilePicture", this.userProfilePicture);
  }

  static Future<AppUser> getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppUser user = AppUser();
    user.userId = prefs.getString("userId") ?? "";
    user.name = prefs.getString("name") ?? "";
    user.oneSignalUserId =  prefs.getString("oneSignalUserId") ?? "";
    user.email =  prefs.getString("email") ?? "";
    user.userProfilePicture =  prefs.getString("userProfilePicture") ?? "";
    return user;
  }

  static Future deleteUserAndOtherPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future saveOneSignalUserID(String oneSignalId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("OneSignalUserId", oneSignalId);
  }

  static Future getOneSignalUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("OneSignalUserId") ?? "";
  }

  ///*********FIRESTORE METHODS***********\\\\
  Future<dynamic> signUpUser(AppUser user) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance.collection("users").doc(user.userId).set({
      'userId': user.userId,
      'name': user.name,
      'userProfilePicture' : user.userProfilePicture,
      'email' : user.email,
      'oneSignalUserId' : '',  
    }).then((_) async {
      print("success!");
      return user;
    }).catchError((error) {
      print("Failed to add user: $error");
      return AppUser();
    });
  }

  static Future<dynamic> getLoggedInUserDetail(AppUser user) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance
    .collection("users")
    .doc(user.userId)
    .get()
    .then((value) async {
      if(value.exists)
      {
        print(value.data()!);
        AppUser userTemp = AppUser.fromJson(value.data());
        userTemp.userId = user.userId;
        //await userTemp.saveUserDetails();
        return userTemp;
      }
      else
      {
        //Signup google/facebook user as first time login
        AppUser userTemp = await AppUser().signUpUser(user);
        return userTemp;
      }
    }).catchError((error) {
      print("Failed to add user: $error");
      return AppUser();
    });
  }

  static Future<dynamic> getUserDetailByUserId(String userId) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance
    .collection("users")
    .where('userId', isEqualTo: userId)
    .get()
    .then((value) async {
      AppUser userTemp = AppUser.fromJson(value.docs[0].data());
      userTemp.userId = userId;
      return userTemp;
    }).catchError((error) {
      print("Failed to add user: $error");
      return AppUser();
    });
  }

  static Future<dynamic> getUserDetailByEmail(String email) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance
    .collection("users")
    .where('email', isEqualTo: email)
    .get()
    .then((value) async {
      AppUser userTemp = AppUser.fromJson(value.docs[0].data());
      return userTemp;
    }).catchError((error) {
      print("Failed to add user: $error");
      return AppUser();
    });
  }

  static Future<dynamic> updateUserProfile(String userName, String profilePictureUrl, List categories) async {
    try{
      final firestoreInstance = FirebaseFirestore.instance;
      return await firestoreInstance.collection("users").doc(Constants.appUser.userId).update({
        'userName': userName,
        'userProfilePicture' : profilePictureUrl,
      }).then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
    }
    catch(e){
      return false;
    }
  }
}
