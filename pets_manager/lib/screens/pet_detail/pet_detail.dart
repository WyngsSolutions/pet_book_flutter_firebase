import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_manager/screens/pet_detail/post_comments.dart';
import 'package:pets_manager/screens/pet_detail/product_map_view.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../chat_screen/chat_screen.dart';
import '../photolist_screen/photo_list_screen.dart';

class PetDetailScreen extends StatefulWidget {
  
  final Map petDetail;
  const PetDetailScreen({super.key, required this.petDetail});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          '${widget.petDetail['petName']}',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Get.to(PetComments(petDetails: widget.petDetail));
            },
            icon: Icon(Icons.comment, size: SizeConfig.blockSizeVertical*3,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: (){
                  Get.to(PhotoListScreen(galleryItems: [widget.petDetail['petPicture']]));
                },
                child: Container(
                  height: SizeConfig.blockSizeVertical*30,
                  width: SizeConfig.blockSizeHorizontal*100,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 0.7
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.petDetail['petPicture']),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
      
              Container(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal *5, right: SizeConfig.blockSizeHorizontal *5, top: SizeConfig.blockSizeHorizontal*4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.petDetail['petName'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.fontSize *2.2,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    if(widget.petDetail['petPrice'].isNotEmpty)
                    Container(
                      child: Text(
                        '\$${widget.petDetail['petPrice']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.fontSize*2.2,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                )
              ),
      
              Container(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal *5, right: SizeConfig.blockSizeHorizontal *5, top: SizeConfig.blockSizeHorizontal *1),
                child: Text(
                  widget.petDetail['petDescription'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.fontSize *1.8,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
      
              Container(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal *5, right: SizeConfig.blockSizeHorizontal *5, top: SizeConfig.blockSizeHorizontal*4),
                child: Text(
                  'Owner Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.fontSize *1.9,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              
              Container(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal *5, right: SizeConfig.blockSizeHorizontal *5, top: SizeConfig.blockSizeHorizontal*2),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal *5, right: SizeConfig.blockSizeHorizontal *5, top: SizeConfig.blockSizeHorizontal*1),
                      height: SizeConfig.blockSizeVertical*7,
                      width: SizeConfig.blockSizeVertical*7,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        border: Border.all(
                          color: Colors.grey[400]!,
                          width: 0.7
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(widget.petDetail['petPicture']),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
      
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*3),
                        child: Text(
                          '${widget.petDetail['petOwnerName']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.fontSize *2,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),

              Container(
                margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*2, SizeConfig.blockSizeVertical*0, SizeConfig.blockSizeHorizontal*2, SizeConfig.blockSizeVertical*0,),
                child: PetMapView(pet: widget.petDetail,)
              ),

            GestureDetector(
              onTap: showReportView,
              child: Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical *4),
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2, vertical: SizeConfig.blockSizeVertical * 3),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 0.5
                    )
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Report this Pet',
                      style: TextStyle(color: Colors.black, fontSize: SizeConfig.fontSize * 1.8),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black, size: SizeConfig.blockSizeVertical * 2,)
                  ],
                ),
              ),
            ),
      
      
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          AppUser user = await AppUser.getUserDetailByUserId(widget.petDetail['petOwnerId']);
          Get.to(ChatScreen(chatUser: user,));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*6, vertical: SizeConfig.blockSizeVertical * 4),
          height: SizeConfig.blockSizeVertical *6,
          decoration: BoxDecoration(
            color:  Constants.appThemeColor,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Center(
            child: Text(
              'Contact Owner',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.fontSize * 2.1,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///******* UTIL METHOD ****************///
  void showReportView()async
  {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7, vertical: SizeConfig.blockSizeVertical*3),
          height: SizeConfig.blockSizeVertical*52,
          decoration: BoxDecoration(
            color: Constants.appThemeColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40)
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Comment To Admin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 2.3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                child: Text(
                  'Let the admin know what\'s wrong with this pet. Your details will be kept anonymous for this report',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: SizeConfig.fontSize * 1.8,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportPet(widget.petDetail, 'Spam');
                  Constants.showDialog('You have reported the pet to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Spam',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportPet(widget.petDetail, 'Harassment');
                  Constants.showDialog('You have reported the pet to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Harassment',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportPet(widget.petDetail, 'Hate');
                  Constants.showDialog('You have reported the pet to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Hate Speech',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportPet(widget.petDetail, 'Other');
                  Constants.showDialog('You have reported the pet to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Other',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}