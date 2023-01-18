import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_manager/utils/constants.dart';
import 'package:pets_manager/utils/size_config.dart';
import '../pet_detail/pet_detail.dart';

class ListDetailScreen extends StatefulWidget {
  
  final List petList;
  final String title;
  const ListDetailScreen({super.key, required this.petList, required this.title});

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {

  @override
  void initState() {
    super.initState();
    widget.petList.add(widget.petList[0]);
    widget.petList.add(widget.petList[0]);
    widget.petList.add(widget.petList[0]);
    widget.petList.add(widget.petList[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          '${widget.title}',
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
          itemCount: widget.petList.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return dogCell(widget.petList[index], index);
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