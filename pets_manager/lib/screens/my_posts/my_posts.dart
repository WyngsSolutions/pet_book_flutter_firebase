import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pets_manager/utils/constants.dart';
import 'package:pets_manager/utils/size_config.dart';
import '../../controllers/app_controller.dart';
import '../pet_detail/pet_detail.dart';

class MyPosts extends StatefulWidget {
  
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
 
  List pets = [];

  @override
  void initState() {
    super.initState();
    getAllMyPets();
  }

  void getAllMyPets() async {
    pets.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getAllMyPets();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      setState(() {
        pets = result['Posts'];       
      });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  void deletePet(Map pet, int index) async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().deleteMyPost(pet);
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      setState(() {
        pets.removeAt(index);
      });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'My Posts',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5, vertical: SizeConfig.blockSizeVertical*0),
        child: latestView(),
      ),
    );
  }

  Widget latestView (){
    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          itemCount: pets.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return dogCell(pets[index], index);
          }
        ),
      ),
    );
  }

  Widget dogCell(Map pet, int index){
    return GestureDetector(
      onTap: (){
        Get.to(PetDetailScreen(petDetail: pet,));
      },
      child: Container(
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
        height: SizeConfig.blockSizeVertical*30,
        width: SizeConfig.blockSizeHorizontal*60,
        decoration: BoxDecoration(
          //color: Colors.red,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey[400]!,
            width: 0.7
          ),
          image: DecorationImage(
            image: CachedNetworkImageProvider(pet['petPicture']),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.all(SizeConfig.blockSizeVertical*1),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle
                ),
                child: IconButton(
                  onPressed: (){
                    deletePet(pet, index);
                  },
                  icon: Icon(Icons.delete, size: SizeConfig.blockSizeVertical*3, color: Colors.white,)
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2, vertical: SizeConfig.blockSizeHorizontal*2),
                    child: Text(
                      pet['petName'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.fontSize*1.8,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  
                  if(pet['petPrice'].isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2, vertical: SizeConfig.blockSizeHorizontal*2),
                    child: Text(
                      '\$${pet['petPrice']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.fontSize*1.8,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}