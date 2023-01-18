// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_manager/screens/post_screen/set_product_location.dart';
import '../../controllers/app_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../home_screen/home_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({ Key? key }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  TextEditingController petName = TextEditingController();
  TextEditingController petDescription = TextEditingController();
  TextEditingController petPrice = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? image;
  final ImagePicker picker = ImagePicker();
  LatLng? productCoordinates;
  int postOption = 1;

  @override
  void initState() {
    super.initState();
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,);
    if(pickedFile != null)
    {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void postPet() async {
    if(petName.text.isEmpty)
      Constants.showDialog('Please enter pet name');
    else if(petDescription.text.isEmpty)
      Constants.showDialog('Please enter pet description');
    else if(postOption ==3 && petPrice.text.isEmpty)
      Constants.showDialog('Please enter pet sale price');
    else if(image==null)
      Constants.showDialog('Please select product image');
    else if(productCoordinates == null)
    {
      dynamic resultCoordinates = await Get.to(SetProductLocation());
      if(resultCoordinates == null)
        return;
      else
      {
        productCoordinates = resultCoordinates;
        EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
        dynamic result = await AppController().addPet(petName.text, petPrice.text, petDescription.text, postOption, image!, productCoordinates!);
        EasyLoading.dismiss();
        if (result['Status'] == "Success") 
        {
          Get.offAll(HomeScreen(defaultPage: 0,));
          Constants.showDialog('Your pet has been posted successfully');
        }
        else
        {
          Constants.showDialog(result['ErrorMessage']);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Row(
          children: [
            Text(
              'Post Pet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.fontSize * 2.1,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 8, vertical: SizeConfig.blockSizeVertical * 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              GestureDetector(
                onTap: getImageFromGallery,
                child: Center(
                  child: Container(
                    height: SizeConfig.blockSizeVertical *16,
                    width: SizeConfig.blockSizeVertical *16,
                    margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical *1, top : SizeConfig.blockSizeVertical *1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: (image != null) ? FileImage(image!) : const AssetImage('assets/placeholder.png') as ImageProvider,
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                ),
              ),

              Container(
                height: SizeConfig.blockSizeVertical *6,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                decoration: BoxDecoration(
                  color: Colors.grey[200]!,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white,
                    width: 1
                  )
                ),
                child: Center(
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.fontSize * 1.8),
                    controller: petName,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter pet name',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: SizeConfig.fontSize * 1.8),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 20)
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200]!,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white,
                    width: 1
                  )
                ),
                child: Center(
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.fontSize * 1.8),
                    controller: petDescription,
                    maxLines: 6,
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter pet description',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: SizeConfig.fontSize * 1.8),
                      //contentPadding: EdgeInsets.symmetric(horizontal: 20)
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                child: Text(
                  'Pet Posted Reason?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.fontSize * 1.8,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                child: Row(
                  children: [
                    //SizedBox(width: SizeConfig.blockSizeHorizontal*3,),
                    Container(
                      margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1,),
                      height: SizeConfig.blockSizeVertical*3,
                      width: SizeConfig.blockSizeVertical*3,
                      child: Checkbox(
                        value: (postOption == 2), 
                        onChanged: (val){
                          setState(() {
                            postOption = 2;                          
                          });
                        },
                        activeColor: Constants.appThemeColor,
                      ),
                    ),
                    Text(
                      'Adoption',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.fontSize * 1.8,
                        fontWeight: FontWeight.w500
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1, left:  SizeConfig.blockSizeHorizontal*2),
                      height: SizeConfig.blockSizeVertical*3,
                      width: SizeConfig.blockSizeVertical*3,
                      child: Checkbox(
                        value: (postOption == 3), 
                        onChanged: (val){
                          setState(() {
                            postOption = 3;                          
                          });
                        },
                        activeColor: Constants.appThemeColor,
                      ),
                    ),
                    Text(
                      'Sale',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.fontSize * 1.8,
                        fontWeight: FontWeight.w500
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1, left:  SizeConfig.blockSizeHorizontal*2),
                      height: SizeConfig.blockSizeVertical*3,
                      width: SizeConfig.blockSizeVertical*3,
                      child: Checkbox(
                        value: (postOption == 4), 
                        onChanged: (val){
                          setState(() {
                            postOption = 4;                          
                          });
                        },
                        activeColor: Constants.appThemeColor,
                      ),
                    ),
                    Text(
                      'Lost',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.fontSize * 1.8,
                        fontWeight: FontWeight.w500
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*1, left:  SizeConfig.blockSizeHorizontal*2),
                      height: SizeConfig.blockSizeVertical*3,
                      width: SizeConfig.blockSizeVertical*3,
                      child: Checkbox(
                        value: (postOption == 1), 
                        onChanged: (val){
                          setState(() {
                            postOption = 1;                          
                          });
                        },
                        activeColor: Constants.appThemeColor,
                      ),
                    ),
                    Text(
                      'None',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.fontSize * 1.8,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),

              if(postOption == 3)
              Container(
                height: SizeConfig.blockSizeVertical *6,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200]!,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white,
                    width: 1
                  )
                ),
                child: Center(
                  child: TextField(
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.fontSize * 1.8),
                    controller: petPrice,
                    keyboardType: TextInputType.number,
                    //textali
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter pet price',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: SizeConfig.fontSize * 1.8),
                      suffixIcon: Column(
                        children : [
                          Text(
                            '\$',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.fontSize * 1.7,
                            ),
                          ),
                        ]
                      )
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: postPet,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: SizeConfig.blockSizeVertical * 3),
                  height: SizeConfig.blockSizeVertical *6,
                  decoration: BoxDecoration(
                    color:  Constants.appThemeColor,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                    child: Text(
                      'Post',
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

            ],
          ),
        ),
      ),
    );
  }

  Widget productImageView(File? productImage, int index){
    return GestureDetector(
      onTap: (){
        getImageFromGallery();
      },
      child: Container(
        margin: EdgeInsets.only(left: (index==1) ? 0 : SizeConfig.blockSizeHorizontal * 4),
        height: SizeConfig.blockSizeVertical * 10,
        width: SizeConfig.blockSizeVertical * 10,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1
          )
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            (productImage == null) ? imageNotSetView(index) : Image.file(productImage, fit: BoxFit.cover,),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    image = null;
                  });
                },
                child: (productImage == null) ? Container() : Container(
                  color: Constants.appThemeColor,
                  height: SizeConfig.blockSizeVertical*2.5,
                  child: Center(child: Icon(Icons.close, color: Colors.white, size: SizeConfig.blockSizeVertical *2.5,))
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget imageNotSetView(int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt, color: Colors.grey[300], size:  SizeConfig.blockSizeVertical * 3.5,),
      ],
    );
  }

}