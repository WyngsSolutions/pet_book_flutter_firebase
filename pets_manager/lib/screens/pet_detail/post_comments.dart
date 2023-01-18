// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../chat_screen/chat_screen.dart';

class PetComments extends StatefulWidget {

  final Map petDetails;
  const PetComments({ Key? key, required this.petDetails }) : super(key: key);

  @override
  State<PetComments> createState() => _PetCommentsState();
}

class _PetCommentsState extends State<PetComments> {
 
  List allPostComments = [];
  TextEditingController commentField = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllPetComments();
  }

  void getAllPetComments()async{
    allPostComments.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppController().getAllPetComments(allPostComments, widget.petDetails);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
     setState(() {
       print(allPostComments.length);
     });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  Future<void> enterCommentOnPet() async {
    if(commentField.text.isEmpty)
      Constants.showDialog('Please enter comment');
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
      dynamic result = await AppController().addPetComment(widget.petDetails, commentField.text);
      EasyLoading.dismiss();
      if(result['Status'] == 'Success')
      {
      setState(() {
        commentField.text = "";
        getAllPetComments();
      });
      }
      else
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }

  ///******* UTIL METHOD ****************///
  void userProfileView(Map personDetail)async
  {
    dynamic result = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc){
        return Container();//UserDetailView(personDetail : personDetail);
      }
    );
  }

  // void showReportView(Map commentDetail)async
  // {
  //   await showModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (BuildContext bc){
  //       return Container(
  //         padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7, vertical: SizeConfig.blockSizeVertical*3),
  //         height: SizeConfig.blockSizeVertical*52,
  //         decoration: BoxDecoration(
  //           color: Constants.appThemeColor,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(40),
  //             topRight: Radius.circular(40)
  //           )
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Text(
  //               'Report Comment To Admin',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: SizeConfig.fontSize * 2.3,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold
  //               ),
  //             ),

  //             Container(
  //               margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
  //               child: Text(
  //                 'Let the admin know what\'s wrong with this comment. Your details will be kept anonymous for this report',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                   fontSize: SizeConfig.fontSize * 1.8,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w500
  //                 ),
  //               ),
  //             ),

  //             GestureDetector(
  //               onTap: (){
  //                 Get.back();
  //                 //AppController().reportComment(commentDetail, 'Other');
  //                 Constants.showDialog('You have reported the comment to admin');
  //               },
  //               child: Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
  //                 height: SizeConfig.blockSizeVertical*5.5,
  //                 width: SizeConfig.blockSizeHorizontal*80,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'Spam',
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.fontSize * 2,
  //                       color: Constants.appThemeColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: (){
  //                 Get.back();
  //                 AppController().reportComment(commentDetail, 'Harassment');
  //                 Constants.showDialog('You have reported the comment to admin');
  //               },
  //               child: Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
  //                 height: SizeConfig.blockSizeVertical*5.5,
  //                 width: SizeConfig.blockSizeHorizontal*80,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'Harassment',
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.fontSize * 2,
  //                       color: Constants.appThemeColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: (){
  //                 Get.back();
  //                 AppController().reportComment(commentDetail, 'Hate Speech');
  //                 Constants.showDialog('You have reported the comment to admin');
  //               },
  //               child: Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
  //                 height: SizeConfig.blockSizeVertical*5.5,
  //                 width: SizeConfig.blockSizeHorizontal*80,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'Hate Speech',
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.fontSize * 2,
  //                       color: Constants.appThemeColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: (){
  //                 Get.back();
  //                 AppController().reportComment(commentDetail, 'Other');
  //                 Constants.showDialog('You have reported the comment to admin');
  //               },
  //               child: Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
  //                 height: SizeConfig.blockSizeVertical*5.5,
  //                 width: SizeConfig.blockSizeHorizontal*80,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'Other',
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.fontSize * 2,
  //                       color: Constants.appThemeColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Pet Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                        
            Expanded(
              child: (allPostComments.isEmpty) ? Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*5, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
                child: Center(
                  child: Text(
                    'No Comments',
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize*2.2,
                      color: Colors.grey[400]!
                    ),
                  ),
                ),
              ): Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1.5, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: allPostComments.length,
                    itemBuilder: (_, i) {
                      return commentCell(allPostComments[i], i);
                    },
                    shrinkWrap: true,
                  ),
                ),
              ),
            ),

            
            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*4, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
              child: Center(
                child: TextField(
                  controller: commentField,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    fillColor:  Colors.grey[100],
                    filled: true,
                    hintText: 'Add comment...',
                    contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(width: 1,color: Color(0XFFD4D4D4)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFFD4D4D4)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        IconButton(
                          icon: Icon(Icons.send, color: Constants.appThemeColor), 
                          onPressed: (){
                            enterCommentOnPet();
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ) : GestureDetector(
            //   onTap: (){
            //     Get.to(AddDonor());
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 10),
            //     margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*4, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
            //     decoration: BoxDecoration(
            //       color: Constants.appThemeColor,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Center(
            //       child: Text(
            //         'Want to comment?\nBecome Donor',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: SizeConfig.fontSize*2
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

          ],
        ),
      ),
    );
  }

  Widget commentCell(dynamic commentDetail, int index){
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*4, vertical: SizeConfig.blockSizeVertical*1.5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 0.5
            )
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
              height: SizeConfig.blockSizeVertical*6,
              width: SizeConfig.blockSizeVertical*6,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/user_bg.png'),
                  fit: BoxFit.cover
                )
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2, top: SizeConfig.blockSizeVertical*0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          commentDetail['userName'],
                          style: TextStyle(
                            fontSize: SizeConfig.fontSize*1.8,
                            color: Colors.black
                          ),
                        ),
                        if(Constants.appUser.userId == widget.petDetails['ownerUserId'])
                        GestureDetector(
                          onTap: () async {
                            EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
                            dynamic userData = await AppUser.getUserDetailByUserId(commentDetail['userId']);
                            EasyLoading.dismiss();
                            userProfileView(userData);
                          },
                          child: Icon(Icons.info_outline, size: SizeConfig.blockSizeVertical*3, color: Constants.appThemeColor,)
                        )
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Text(
                        commentDetail['userComment'],
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize*1.7,
                          color: Colors.grey[500]!
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
            if(widget.petDetails['petOwnerId'] == Constants.appUser.userId)
            GestureDetector(
              onTap: () async {
                EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);    
                AppUser user = await AppUser.getUserDetailByUserId(widget.petDetails['petOwnerId']);
                EasyLoading.dismiss();
                Get.to(ChatScreen(chatUser: user,));
              },
              child: Container(
                height: SizeConfig.blockSizeVertical*7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(
                        Icons.chat,
                        color: Colors.green,
                        size: SizeConfig.blockSizeVertical*3,
                      ),
                    )
                  ],
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}