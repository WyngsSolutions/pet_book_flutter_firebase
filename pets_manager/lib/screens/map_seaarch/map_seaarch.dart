import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/app_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import 'dart:async';
import 'package:location/location.dart';

class MapSearch extends StatefulWidget {
  const MapSearch({super.key});

  @override
  State<MapSearch> createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  
  bool showLoading = true;
  //******* LOCATION *******\\
  Location location =  Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool isPermissionGiven = false;
  bool isGPSOpen = false;
  Timer? _timer;
  //
  List pets = [];
  double userLatitude =0;
  double userLongitude = 0;
  late LatLng center;
  late GoogleMapController controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  //late BitmapDescriptor hospitalIcon;


  @override
  void initState() {
    super.initState();
    center = LatLng(userLatitude, userLongitude);
    switchOnLocationPressed();
  }

  Future<void> _onMapCreated(GoogleMapController cntlr) async {
    controller = cntlr;
    MarkerId markerId = MarkerId('user1');
    Marker marker = Marker(
      markerId: MarkerId("user1"),
      position: LatLng(userLatitude, userLongitude),
      infoWindow: InfoWindow(
        title: "My Location",
        snippet: 'Here is my location'
      ),
      draggable: false,
    );
    _markers[markerId] = marker;

    final Uint8List hospitalIcon = await getBytesFromAsset('assets/logo2.png', 100);

    for(int i=0; i < pets.length; i++)
    {
      MarkerId markerId = MarkerId('$i');
      Marker marker = Marker(
        markerId: MarkerId("pet$i"),
        position: LatLng(pets[i]['productLatitude'], pets[i]['productLongitude']),
        infoWindow: InfoWindow(
          title: "${pets[i]['petName']}",
          snippet: 'Pet Location Area'
        ),
        draggable: false,
        //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        icon: BitmapDescriptor.fromBytes(hospitalIcon),
      );
      _markers[markerId] = marker;
    }
    
    setState(() {
      CameraPosition cPosition = CameraPosition(zoom: 12, target: LatLng(userLatitude, userLongitude),);
      controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
      center = LatLng(userLatitude, userLongitude);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }


  @override
  void dispose() {
    if(_timer != null)
      _timer!.cancel();
    super.dispose();
  }

  //****************************** LOCATION RELATED ********************************/
  void switchOnLocationPressed()async{
    //Permission Check
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) 
    {
      _permissionGranted = await location.requestPermission();
      
      if (_permissionGranted == PermissionStatus.deniedForever) {
        Constants.showTitleAndMessageDialog('Location Disabled', 'You have disabled location use for the app so please go to application settings and allow location use to continue');
        setState(() {
          showLoading = false;
        });
        return;
      }
      if (_permissionGranted == PermissionStatus.denied) {
        setState(() {
          showLoading = false;
        });
        return;
      }
      if (_permissionGranted != PermissionStatus.granted) {
         setState(() {
          showLoading = true;
        });
        return;
      }
    }

    if (_permissionGranted == PermissionStatus.granted)
      isPermissionGiven = true;
    

    //Service Check
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled)
    {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        startTimer();
        setState(() {
          showLoading = false;
        });
        return;
      }
      else
      {
        isGPSOpen = true;
        setState(() {
          showLoading = true;
        });
      }
    }
    else
    {
      isGPSOpen = true;
    }


    if(isGPSOpen && isPermissionGiven)
    {
      if(_timer != null)
        _timer!.cancel();
  
      _locationData = await location.getLocation();
      print(_locationData.latitude);
      print(_locationData.longitude);
      setUpUserLocation(_locationData.latitude!, _locationData.longitude!);
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer =  Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          checkForGPS();
        },
      ),
    );  
  }

  void checkForGPS()async{
     _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled)
    {
      isGPSOpen = true;
      switchOnLocationPressed();
    }
  }

  Future<void> setUpUserLocation(double latitude , double longitude) async {
    userLatitude = latitude;
    userLongitude = longitude;
    getAllPets();
    setState(() { 
      showLoading = false;
    });
  }
  
  void getAllPets() async {
    pets.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getAllPets();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      setState(() {
        pets = result['pets'];   
        _onMapCreated(controller);   
      });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  WillPopScope(
      onWillPop: () async {
        return false;
      },
      child : Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Constants.appThemeColor,
          title: Text(
            'Nearby Pets',
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.fontSize*2.2
            ),
          ),
        ),
        body: (showLoading) ? Container(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Constants.appThemeColor),
            ),
          ),
        ) : (userLatitude != 0) ? mapView() : Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*8),
                height: SizeConfig.blockSizeVertical *60,
                width: SizeConfig.blockSizeHorizontal *100,
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Location Disabled", style: TextStyle(fontSize: 3 * SizeConfig.fontSize, color: Colors.black, fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical *5,
                    ),
                    Text(
                      "Health Manager will show you nearby hospitals when can detect your location", 
                      style: TextStyle(fontSize: 1.8 * SizeConfig.fontSize, color: Colors.black54, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical *5,
                    ),
                    Icon(Icons.location_on, size: SizeConfig.blockSizeVertical *20, color: Constants.appThemeColor,)
                  ],
                ),
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal *70,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    GestureDetector(
                      onTap: switchOnLocationPressed,
                      child: Container(
                        height: SizeConfig.blockSizeVertical*7,
                        decoration: BoxDecoration(
                          color: Constants.appThemeColor,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                          child: Text(
                            "ENABLE",
                            style: TextStyle(fontSize: 1.8 * SizeConfig.fontSize, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mapView (){
    return Container(
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
        },
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }
}