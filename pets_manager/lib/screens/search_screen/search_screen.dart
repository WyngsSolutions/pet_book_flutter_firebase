// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/app_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../pet_detail/pet_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  
  List petsList = [];
  List filterPetsList = [];
  int bloodGroup = 0;
  List all = [];
  List adoption = [];
  List sale = [];
  List lost = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllPets();
  }

  void getAllPets() async {
    petsList.clear();
    filterPetsList.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    //await AppController().getAllMyFavoriteProducts();
    dynamic result = await AppController().getAllPets();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      setState(() {
        all = result['pets'];        
        sale = result['sale'];        
        adoption = result['adoption'];        
        lost = result['lost'];  
        searchPet();      
      });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }


  void searchPet() async {
    if(bloodGroup == 0)
    {
      petsList = List.from(all);
    }
    if(bloodGroup == 1)
    {
      petsList = List.from(adoption);
    }
    if(bloodGroup == 2)
    {
      petsList = List.from(sale);
    }
    if(bloodGroup == 3)
    {
      petsList = List.from(lost);
    }

    setState(() {
      filterPetsList = petsList.where((element) => element['name'].toString().toLowerCase().contains(searchController.text.toLowerCase())).toList();
    });
  }

  void showFilterDialog() {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              width: SizeConfig.blockSizeHorizontal*80,
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
              child: MediaQuery.removePadding(
                removeTop: true,
                removeBottom: true,
                context: context,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Icon(Icons.close)
                      )
                    ),
              
                    Container(
                      child: Center(
                        child: Text(
                          'Filters',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: SizeConfig.fontSize* 2.2,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
              
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, bottom: SizeConfig.blockSizeVertical*2),
                      child: Text(
                        'Pet Type',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          color: Color(0XFFA5A5A5),
                          fontSize: SizeConfig.fontSize* 2,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Radio(value: 0, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 0;
                          });
                        }),
                        Container(
                          child: Text(
                            'All',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(value: 1, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 1;
                          });
                        }),
                        Container(
                          child: Text(
                            'For Adoption',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(value: 2, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 2;
                          });
                        }),
                        Container(
                          child: Text(
                            'For Sale',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio(value: 3, groupValue: bloodGroup, onChanged: (val){
                          setState((){
                            bloodGroup = 3;
                          });
                        }),
                        Container(
                          child: Text(
                            'Lost',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    GestureDetector(
                      onTap: (){
                        Get.back();
                        searchPet();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical* 0, left: SizeConfig.blockSizeHorizontal * 2, right: SizeConfig.blockSizeHorizontal * 2, top:  SizeConfig.blockSizeVertical* 5),
                        height: SizeConfig.blockSizeVertical * 6,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Apply Filter',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: SizeConfig.fontSize* 1.8,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
            
                  ],
                ),
              ),
            )
          );
        }
      )
    );
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*4, SizeConfig.blockSizeVertical*2, SizeConfig.blockSizeHorizontal*4,0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 6,
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
                            textAlignVertical: TextAlignVertical.center,
                            controller: searchController,
                            onChanged: (val){
                              setState(() {
                                filterPetsList = petsList.where((element) => element['petName'].toString().toLowerCase().contains(val)).toList();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search....',
                              prefixIcon: Icon(Icons.search, color: Colors.grey,),
                              border: InputBorder.none
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: showFilterDialog,
                      child: Container(
                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2),
                        width: SizeConfig.blockSizeVertical*6,
                        height: SizeConfig.blockSizeVertical*6,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Icon(Icons.filter_list_outlined, color: Colors.white, size: SizeConfig.blockSizeVertical*3.5,),
                      ),
                    )
                  ],
                ),
              ),
              
              (filterPetsList.isEmpty) ? Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                  child: Center(
                    child: Text(
                      'No Pets Found',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 1.8,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ) : 
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1, bottom: SizeConfig.blockSizeVertical*1),
                  child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filterPetsList.length,
                  itemBuilder: (context, index){
                    return dogCell(filterPetsList[index], index);
                  }
                ),
              ),
            ),
          ],
        )
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