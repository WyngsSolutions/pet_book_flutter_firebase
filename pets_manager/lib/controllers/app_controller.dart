// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures, invalid_return_type_for_catch_error, avoid_function_literals_in_foreach_calls
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';
import '../models/app_user.dart';
import '../utils/constants.dart';
import 'notifications_controller.dart';

class AppController {

  final firestoreInstance = FirebaseFirestore.instance;

  //SIGN UP
  Future signUpUser(String userName, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user?.uid);
      AppUser newUser = AppUser(
        userId: userCredential.user!.uid,
        email: email,
        name: userName,
      );
      dynamic resultUser = await newUser.signUpUser(newUser);
      if (resultUser != null) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        Constants.appUser = resultUser;
        await Constants.appUser.saveUserDetails();
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] ="User cannot signup at this time. Try again later";
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        finalResponse['ErrorMessage'] = "No user found for that email";
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        finalResponse['ErrorMessage'] = "Wrong password provided for that user";
      }
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //SIGN IN
  Future signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print(userCredential.user!.uid);
       AppUser newUser = AppUser(
        userId: userCredential.user!.uid,
        email: email,
        name: '',
      );
      dynamic resultUser = await AppUser.getLoggedInUserDetail(newUser);
      if (resultUser != null)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['User'] = resultUser;
        Constants.appUser = resultUser;
        await Constants.appUser.saveUserDetails();
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "User cannot login at this time. Try again later";
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        finalResponse['ErrorMessage'] = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        finalResponse['ErrorMessage'] =
            "The account already exists for that email";
      } else {
        finalResponse['ErrorMessage'] = e.code;
      }
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  //FORGOT PASSWORD
  Future forgotPassword(String email) async {
    try {
      String result = "";
      await FirebaseAuth.instance
      .sendPasswordResetEmail(email: email).then((_) async {
        result = "Success";
      }).catchError((error) {
        result = error.toString();
        print("Failed emailed : $error");
      });

      if (result == "Success") {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = result;
        return finalResponse;
      }
    } on FirebaseAuthException catch (e) {
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Error";
      finalResponse['ErrorMessage'] = e.code;
      return finalResponse;
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  Future<dynamic> updateOneSignalUserID(String oneSignalUserID) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance.collection("users").doc(Constants.appUser.userId)
    .update({
      "oneSignalUserId": oneSignalUserID
     }).then((_) async {
      print("success!");
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Success";
      return finalResponse;
    }).catchError((error) {
      print("Failed to update: $error");
      return setUpFailure();
    });
  }

  Future getAllPets() async {
    try {
      List pets = [];
      List adoption = [];
      List sale = [];
      List lost = [];
      dynamic result = await firestoreInstance.collection("products")
      //.where('userId', isEqualTo: Constants.appUser.userId)
      .get().then((value) {
      value.docs.forEach((result) 
      {
          print(result.data);
          Map pet = result.data();
          pet['postId'] = result.id;
          pets.add(pet);
          if(pet['petOption'] == "Sale")
            sale.add(pet);
          if(pet['petOption'] == "Adoption")
            adoption.add(pet);
          if(pet['petOption'] == "Lost")
            lost.add(pet);
        });
        return true;
      });

      if (result)
      {
        pets.sort((b, a) => a['productAddedDate'].toDate().compareTo(b['productAddedDate'].toDate()));
        sale.sort((b, a) => a['productAddedDate'].toDate().compareTo(b['productAddedDate'].toDate()));
        adoption.sort((b, a) => a['productAddedDate'].toDate().compareTo(b['productAddedDate'].toDate()));
        lost.sort((b, a) => a['productAddedDate'].toDate().compareTo(b['productAddedDate'].toDate()));

        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['pets'] = pets;
        finalResponse['sale'] = sale;
        finalResponse['adoption'] = adoption;
        finalResponse['lost'] = lost;
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addPet(String petName, String petPrice, String petDescription, int postOption, File prodPicture, LatLng pettCoordinates) async {
    try {
      //RESIZE IMAGES IF BIGGER THEN 1MB
      File? productPicture = await Constants.resizePhotoIfBiggerThen1mb(prodPicture);
      //UPLOAD ON FIREBASE
      String userImage1FirebasePath  = await uploadFile(productPicture);
      //
      String petOption = (postOption == 1) ? "None" : (postOption == 2) ? "Adoption" : (postOption == 3) ? "Sale" : "Lost";
      dynamic result = await FirebaseFirestore.instance.collection("products").
      add({
        'petName' : petName,
        'petDescription': petDescription,
        'petPrice': petPrice,
        'petOption': petOption,
        'petPicture': userImage1FirebasePath,
        'productLatitude': pettCoordinates.latitude,
        'productLongitude': pettCoordinates.longitude,
        'petOwnerName': Constants.appUser.name,
        'petOwnerId': Constants.appUser.userId,
        'petOwnerPhoto': Constants.appUser.userProfilePicture,
        'likeCount': 0,
        'commentsCount' : 0,
        'productAddedDate' : FieldValue.serverTimestamp()
      }).then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }
  
  Future<String> uploadFile(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + basename(image.path);
    final firebaseStorage = FirebaseStorage.instance;
    //Upload to Firebase
    var snapshot = await firebaseStorage.ref().child("pet_pictures").child(fileName).putFile(File(image.path));
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getAllMyPets() async {
    try {
      List posts = [];
      dynamic result = await firestoreInstance.collection("products")
      .where('petOwnerId', isEqualTo: Constants.appUser.userId)
      .get().then((value) {
      value.docs.forEach((result) 
      {
          print(result.data);
          Map post = result.data();
          post['postId'] = result.id;
          posts.add(post);
        });
        return true;
      });

      if (result)
      {
        posts.sort((b, a) => a['productAddedDate'].toDate().compareTo(b['productAddedDate'].toDate()));
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Posts'] = posts;
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future reportPet(Map pet, String reportReaon) async {
    try {   
      dynamic result = await firestoreInstance.collection("reported_pets").add({
        'petId': pet['postId'],
        'productName':pet['petName'],
        'productOwnerId' : pet['petOwnerId'],
        'productOwnerName' : pet['petOwnerName'],
        'reportedById': Constants.appUser.userId,
        'reportedByEmail': Constants.appUser.email,
        'reportedReason': reportReaon,
        'reportedProductTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future updatePostCommentCount(Map postDetails) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      dynamic result = await firestoreInstance.collection("posts")
      .doc(postDetails['postId'])
      .update({
        'commentsCount': (postDetails['commentsCount'] + 1),
      }).then((_) async {
        print("success!");
        await Constants.appUser.saveUserDetails();
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return null;
      });

      if (result != null)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Place cannot be added at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future editPostRequest(Map postDetails, String description) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      dynamic result = await firestoreInstance.collection("posts")
      .doc(postDetails['postId'])
      .update({
        'description': description,
      }).then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return null;
      });

      if (result != null)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Place cannot be added at this time. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future deleteMyPost(Map postDetail) async {
    try {
      dynamic result = await FirebaseFirestore.instance.collection("products").
        doc(postDetail['postId']).delete().then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
      return finalResponse;
    }
  }

  Future deleteReminder(Map reminderDetail) async {
    try {
      dynamic result = await FirebaseFirestore.instance.collection("reminders").
        doc(reminderDetail['reminderId']).delete().then((_) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Error'] = "Error";
      finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
      return finalResponse;
    }
  }

 
  ///COMMENTS EVENTS
  Future getAllPetComments(List allComments, Map petDetail) async {
    try {
      dynamic result = await firestoreInstance.collection("post_comments")
      .where('postId', isEqualTo: petDetail['postId'])
      .get().then((value) {
      value.docs.forEach((result) 
        {
          print(result.data);
          Map taskData = result.data();
          taskData['commentId'] = result.id;
          allComments.add(taskData);
        });
        return true;
      });

      if (result)
      {
        allComments.sort((a, b) => a['commentAddedTime'].toDate().compareTo(b['commentAddedTime'].toDate()));
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addPetComment(Map petDetail, String postComment) async {
    try {   
      dynamic result = await firestoreInstance.collection("post_comments").add({
        'postId': petDetail['postId'],
        'postDescription': petDetail['petName'],
        'userComment' : postComment,
        'userEmail': Constants.appUser.email,
        'userId': Constants.appUser.userId,
        'userImage': Constants.appUser.userProfilePicture,
        'userName': Constants.appUser.name,
        'commentAddedTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        //updatePostCommentCount(petDetail);
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future reportComment(Map commentDetail, String reportReaon) async {
    try {   
      dynamic result = await firestoreInstance.collection("reported_posts").add({
        'postId': commentDetail['postId'],
        'postDescription': commentDetail['description'],
        'userEmail' : commentDetail['email'],
        'userId': commentDetail['userId'],
        'userName': commentDetail['name'],
        'reportedById': Constants.appUser.userId,
        'reportedByEmail': Constants.appUser.email,
        'reportedReason': reportReaon,
        'reportedCommentTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future addPostRatingForUser(Map postDetail, double rating ,String review, Map userDetail) async {
    try {   
      dynamic result = await firestoreInstance.collection("user_post_reviews").add({
        'postId': postDetail['postId'],
        'postDescription': postDetail['description'],
        'userComment' : userDetail['userComment'],
        'userEmail': userDetail['userEmail'],
        'userId': userDetail['userId'],
        'userName': userDetail['userName'],
        'reviewAddedTime' : FieldValue.serverTimestamp(),
        'rating' : rating,
        'review' : review,
        'reviewAddedByName' : Constants.appUser.name
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future getAllMyReviews(List allReviews, String userId) async {
    try {
      dynamic result = await firestoreInstance.collection("user_post_reviews")
      .where('userId', isEqualTo: userId)
      .get().then((value) {
      value.docs.forEach((result) 
        {
          print(result.data);
          Map taskData = result.data();
          taskData['commentId'] = result.id;
          allReviews.add(taskData);
        });
        return true;
      });

      if (result)
      {
        allReviews.sort((a, b) => a['reviewAddedTime'].toDate().compareTo(b['reviewAddedTime'].toDate()));
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future<dynamic> updateProfileInfo(String userName, String photoUrl) async {
    final firestoreInstance = FirebaseFirestore.instance;
    return await firestoreInstance.collection("users").doc(Constants.appUser.userId)
    .update({
      'name': userName,
      'userProfilePicture': photoUrl,
     }).then((_) async {
      print("success!");
      Constants.appUser.name = userName;
      Constants.appUser.userProfilePicture = photoUrl;
      await Constants.appUser.saveUserDetails();
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Success";
      return finalResponse;
    }).catchError((error) {
      print("Failed to update: $error");
      return setUpFailure();
    });
  }
  
  //
  Future reportUser(AppUser reportedUser, String reportReason) async {
    try {   
      dynamic result = await firestoreInstance.collection("reported_posts").add({
        'reportedUserId': reportedUser.userId,
        'reportedUserEmail' : reportedUser.email,
        'reportedById': Constants.appUser.userId,
        'reportedByEmail': Constants.appUser.email,
        'reportedReason': reportReason,
        'reportedTime' : FieldValue.serverTimestamp()
      }).then((doc) async {
        print("success!");
        return true;
      }).catchError((error) {
        print("Failed to add user: $error");
        return false;
      });
      
      if (result)
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      }
      else
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server. Try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //
  //FAVORITES
  //
  Future addPostFavorite(Map postDetail) async {
    try {
      dynamic result = await FirebaseFirestore.instance.collection("favPosts").
      add({
        'postId' : postDetail['postId'],
        'favoriteByUserEmail': Constants.appUser.email,
        'favoriteByUserId': Constants.appUser.userId,
        'favAddedDate' : FieldValue.serverTimestamp()
      }).then((_) async {
        print("success!");
        Constants.favoritesList.add(postDetail['postId']);
        return true;
      }).catchError((error) {
        print("Failed to update: $error");
        return false;
      });

      if (result) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future getAllMyFavoriteProducts() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      dynamic result = await firestoreInstance.collection("favPosts")
      .where('favoriteByUserId', isEqualTo: Constants.appUser.userId)
      .get()
      .then((value) {
        for (var result in value.docs)
        {
          Map favData = result.data();
          Constants.favoritesList.add(favData['postId']);
        }
        return true;
      });
      
      if (result) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
        return finalResponse;
      }
    }
    catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future removeProductFavorite(Map postDetail) async {
    try {
      String favDocId = "";
      dynamic result = await FirebaseFirestore.instance.collection("favPosts")
      .where('postId', isEqualTo: postDetail['postId'])
      .where('favoriteByUserId', isEqualTo: Constants.appUser.userId)
      .get().then((value) {
        for (var result in value.docs) {
          print(result.data);
          Map favData = result.data();
          favDocId = result.id;
          print(favDocId);
        }
        return true;
      });

      if(favDocId.isNotEmpty)
      {
        await FirebaseFirestore.instance.collection("favPosts").
          doc(favDocId).delete().then((_) async {
          print("success!");
          Constants.favoritesList.remove(postDetail['postId']);
          return true;
        }).catchError((error) {
          print("Failed to update: $error");
          return false;
        });
      }

      if (result) 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future getMyFavoritePosts() async {
    try {
      List allPosts= [];
      for(int i=0; i < Constants.favoritesList.length; i++)
      {
        await FirebaseFirestore.instance.collection("posts")
        .doc(Constants.favoritesList[i])
        .get().then((value) {
          Map post = value.data()!;
          post['postId'] = value.id;
          allPosts.add(post);
          return true;
        });
      }
      
      if(allPosts.length>1) //SORT BY TIME
      allPosts.sort((a,b) {
        var adate = a['postTime'];
        var bdate = b['postTime'];
        return bdate.compareTo(adate);
      });
      
      Map finalResponse = <dynamic, dynamic>{}; //empty map
      finalResponse['Status'] = "Success";
      finalResponse['AllPosts'] = allPosts;
      return finalResponse;
    }
    catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future sendChatNotificationToUser(AppUser user) async {
    try {
      Map<String, String> requestHeaders = {
        "Content-type": "application/json", 
        "Authorization" : "Basic ${Constants.oneSignalRestKey}"
      };

      //if(user.oneSignalUserId.isEmpty)
      user = await AppUser.getUserDetailByUserId(user.userId);
      var url = 'https://onesignal.com/api/v1/notifications';
      final Uri _uri = Uri.parse(url);
      //String json = '{ "include_player_ids" : ["${user.oneSignalUserID}"], "app_id" : "${Constants.oneSignalId}", "small_icon" : "app_icon", "headings" : {"en" : "New Message"}, "contents" : {"en" : "You have a message from ${Constants.appUser.fullName}"}, "data" : { "userID" : "${Constants.appUser.userID}" } }';
      String json = '{ "include_player_ids" : ["${user.oneSignalUserId}"] ,"app_id" : "${Constants.oneSignalId}", "small_icon" : "app_icon", "headings" : {"en" : "New Message"},"contents" : {"en" : "You have received a message from ${Constants.appUser.name}"}}';
      Response response = await post(_uri, headers: requestHeaders, body: json);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    
      if (response.statusCode == 200) {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = "Cannot connect to server at this time. Please try again later";
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

 
  Map setUpFailure() {
    Map finalResponse = <dynamic, dynamic>{}; //empty map
    finalResponse['Status'] = "Error";
    finalResponse['ErrorMessage'] = "Please try again later. Server is busy.";
    return finalResponse;
  }
}
