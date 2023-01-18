// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class SetProductLocation extends StatefulWidget {
  const SetProductLocation({ Key? key }) : super(key: key);

  @override
  State<SetProductLocation> createState() => _SetProductLocationState();
}

class _SetProductLocationState extends State<SetProductLocation> {

  late LatLng center;
  late GoogleMapController controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  late LatLng prodLatLon; 

  @override
  void initState() {
    super.initState();
    prodLatLon = LatLng(Constants.latitude, Constants.longitude);
    center = LatLng(Constants.latitude, Constants.longitude);
    // Future.delayed(const Duration(seconds: 1), () {
    //   showInSnackBar('Long Press and hold the marker to set it to your location');
    // });
  }
  
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Constants.appThemeColor,
        content: new Text(value, style: TextStyle(color : Colors.white, fontSize: 1.8 * SizeConfig.fontSize),)
      )
    );
  }

  void _onMapCreated(GoogleMapController cntlr)
  {
    controller = cntlr;
    MarkerId markerId = MarkerId('1');
    Marker marker = Marker(
      markerId: MarkerId("1"),
      position: LatLng(Constants.latitude, Constants.longitude),
      infoWindow: InfoWindow(
        title: "My Location",
        snippet: ''
      ),
      draggable: false,
    );
    _markers[markerId] = marker;
    
    setState(() {
      CameraPosition cPosition = CameraPosition(zoom: 12, target: LatLng(Constants.latitude, Constants.longitude),);
      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    });
  }

  
  void setLocationPressed() async {
    Get.back(result : prodLatLon);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Constants.appThemeColor
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [    
            
            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1, left: SizeConfig.blockSizeHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
              child: Text(
                'Set pet location',
                style: TextStyle(
                  color: Colors.black,
                  fontSize :SizeConfig.fontSize * 2.5,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.5, left: SizeConfig.blockSizeHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
              child: Text(
                'Exact pet location is not shown to others but nearby area is highlight for user to get idea where pet is',
                style: TextStyle(
                  color: Colors.black,
                  fontSize : SizeConfig.fontSize * 1.6,
                ),
              ),
            ),  

            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    color: Colors.grey[300],
                    child: GoogleMap(
                        mapType: MapType.normal,
                        //enable zoom gestures
                        zoomGesturesEnabled: true,
                        onMapCreated: _onMapCreated,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 14.0,           
                      ),
                      onCameraMove: (val){
                        //selectedOffer = null;
                        if(_markers.length >0)
                        {
                          MarkerId markerId = MarkerId('1');
                          Marker marker = _markers[markerId]!;
                          Marker updatedMarker = marker.copyWith(
                            positionParam: val.target
                          );
                          setState(() {
                            _markers[markerId] = updatedMarker;
                            Constants.latitude = updatedMarker.position.latitude;
                            Constants.longitude = updatedMarker.position.longitude;
                          });
                        }
                      },
                      markers: Set<Marker>.of(_markers.values),
                    ),
                  ),


                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: setLocationPressed,
                      child: Container(
                        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 5, left: SizeConfig.blockSizeHorizontal * 7, right: SizeConfig.blockSizeHorizontal * 7),
                        height: SizeConfig.blockSizeVertical *6,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Center(
                          child: Text(
                            'Set location here',
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
                  )
                ],
              ),
            )
            
          ]
        )
      )
    );
  }
}