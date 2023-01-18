import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pets_manager/utils/constants.dart';
import 'package:pets_manager/utils/size_config.dart';
import '../../controllers/app_controller.dart';
import '../list_detail_screen/list_detail_screen.dart';
import '../pet_detail/pet_detail.dart';
import '../post_screen/post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List pets = [];
  List adoption = [];
  List sale = [];
  List lost = [];

  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  void getAllProducts() async {
    pets.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    //await AppController().getAllMyFavoriteProducts();
    dynamic result = await AppController().getAllPets();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      setState(() {
        pets = result['pets'];        
        sale = result['sale'];        
        adoption = result['adoption'];        
        lost = result['lost'];        
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
          'PetsBook',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              dynamic result = await Get.to(PostScreen());
              if(result != null)
                print('get pets');
            },
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child : Center(
                child: Text(
                  'POST',
                  style: TextStyle(
                    color: Constants.appThemeColor,
                    fontSize: SizeConfig.fontSize*1.8,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5, vertical: SizeConfig.blockSizeVertical*0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              latestView('Recently Added', pets),
              latestView('For Adoption', adoption),
              latestView('For Sale', sale),
              //latestView('Most Loved'),
              latestView('Recently Lost', lost),
            ],
          ),
        ),
      ),
    );
  }

  Widget latestView (String title, List petsList){
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$title',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.fontSize*2.1,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Get.to(ListDetailScreen(petList: petsList, title: title,));
                },
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: Constants.appThemeColor,
                    fontSize: SizeConfig.fontSize*1.7,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),

          Container(
            height: SizeConfig.blockSizeVertical*20,
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: petsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return dogCell(petsList[index], index);
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dogCell(Map pet, int index){
    return GestureDetector(
      onTap: (){
        Get.to(PetDetailScreen(petDetail: pet,));
      },
      child: Container(
        margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3),
        height: SizeConfig.blockSizeVertical*15,
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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