// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, avoid_print
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/notification_service.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await NotificationService().init();
  //NotificationService().requestIOSPermissions();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Constants.appThemeColor
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PetsBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),    
        ),
        //color for scrollbar
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}


class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    double opacity = controller.value;
    return Opacity(
      opacity: opacity,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}


class MyApp2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late ScrollController scrollController;
  bool showSearch = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(
        () => _isAppBarExpanded ? setState((){showSearch = true;}) : setState((){showSearch = false;}));
  }

  bool get _isAppBarExpanded {
    return scrollController.hasClients && scrollController.offset > (200 - kToolbarHeight);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: scrollController,
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.blue,
          expandedHeight: 30,
          collapsedHeight: 180,
          onStretchTrigger: () async {
            setState(() {
              print("*************");
            });
          },
        ),
        SliverAppBar(
          backgroundColor: Colors.white,
          //title: Text('Fixed View'),
          pinned: true,
          expandedHeight: 0,
          elevation: 0,
          toolbarHeight: 80,
          flexibleSpace: Container(
            margin: EdgeInsets.only(top: 40, left: 10, bottom: 5),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 110,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.black,
                      width: 1
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 10,),
                      Text(
                        "Map",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 5,),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10),
                  width: 110,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.black,
                      width: 1
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_alt_rounded),
                      SizedBox(width: 10,),
                      Text(
                        "Filters",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 5,),
                    ],
                  ),
                ),

                Spacer(),
                Opacity(
                  opacity: showSearch ? 1 : 0,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.search)
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                margin : EdgeInsets.only(top:(index == 0) ? 0 : 20),
                child: Card(
                  margin: EdgeInsets.all(15),
                  child: Container(
                    color: Colors.blue[100 * (index % 9 + 1)],
                    height: 300,
                    alignment: Alignment.center,
                    child: Text(
                      "Item $index",
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              );
            },
            childCount: 1000, // 1000 list items
          ),
        ),
      ],
    ));
  }
}