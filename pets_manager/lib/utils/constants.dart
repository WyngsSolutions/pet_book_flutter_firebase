// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../models/app_user.dart';

class Constants {
  
  static final Constants _singleton = Constants._internal();
  static String appName = "PetsBook";
  static bool isUserSignedIn = false;
  static bool isFirstTimeAppLaunched = true;
  static AppUser appUser = AppUser();
  static Color appThemeColor = const Color(0xffd88d62);
  static String oneSignalId = "2307f22c-c7b4-4559-81ad-14ab0498c449";
  static String oneSignalRestKey = "ZTFlOGRlOWEtNzMwMC00ODIzLWJlMTQtYzMxOTU0ZmM1M2U3";
  static String iosAppLink = "https://apps.apple.com/us/app/kv-pet-manager/id1659821414";
  static String androidAppLink = "https://play.google.com/store/apps/details?id=com.kv.petsbook.app";
  //FOR NAVGATON
  static Function? callBackFunction;
  static String topViewName = "";
  static List favoritesList = [];
  //
  static double latitude = 31.44;
  static double longitude = 71.5433;

  factory Constants() {
    return _singleton;
  }

  Constants._internal();

  static void showDialog(String message) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(appName),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK')
          )
        ],
      )
    );
  }  

  static void showDialogWithTitle(String title ,String message) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK')
          )
        ],
      )
    );
  }   

  static void showTitleAndMessageDialog(String title, String message) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text('$title', style: TextStyle(fontWeight: FontWeight.w700),),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK')
          )
        ],
      )
    );
  }

  static Future<File> resizePhotoIfBiggerThen1mb(File image) async{
    try{
      List<int> imageBytes = image.readAsBytesSync();
      double kbSize = imageBytes.length/1024;
      if(kbSize >300)
      {
        double quantity = (100 * 300000)/imageBytes.length;
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String savedPath = appDocDir.path + "/" + DateTime.now().microsecondsSinceEpoch.toString() + ".jpg";
        var result = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path, savedPath,
          quality: quantity.toInt(),
        );
        return result!;
      }
      else
      {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String savedPath = appDocDir.path + "" + DateTime.now().microsecondsSinceEpoch.toString() + ".jpg";
        var result = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path, savedPath,
          quality: 100,
        );
        return result!;
      }
    }
    catch(e){
      return File('');
    }
  }
}