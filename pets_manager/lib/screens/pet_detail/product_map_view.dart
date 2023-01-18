// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, use_key_in_widget_constructors, must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class PetMapView extends StatelessWidget {
  
  final Map pet;
  PetMapView({required this.pet});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 0),
      height: SizeConfig.blockSizeVertical*20,
      decoration: BoxDecoration(  
        border: Border(
          top: BorderSide(
            width: 0.5,
            color: Colors.grey[300]!,
          ),
          bottom: BorderSide(
            width: 0.5,
            color: Colors.grey[300]!,
          )
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(
            width: 1,
            color: Colors.grey[300]!,
          )
        ),
        child: GoogleMap(
            mapType: MapType.normal,
            //enable zoom gestures
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            initialCameraPosition: CameraPosition(
            target: LatLng(pet['productLatitude'], pet['productLongitude']),
            zoom: 14.0,           
          ),
          circles: {Circle(
            circleId: CircleId('1'),
            center: LatLng(pet['productLatitude'], pet['productLongitude']),
            radius: 500,
            fillColor: Constants.appThemeColor.withOpacity(0.3),
            strokeColor: Constants.appThemeColor.withOpacity(0.05),
          )},
        ),
      ),
    );
  }
}