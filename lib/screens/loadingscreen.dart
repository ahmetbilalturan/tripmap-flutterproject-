import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripmap/screens/loginscreen.dart';
import 'package:tripmap/services/authservices.dart';
import 'package:tripmap/services/gradienttext.dart';
import 'package:tripmap/globals.dart' as globals;

// ignore: must_be_immutable
class LoadingScreen extends StatefulWidget {
  static bool isLogined = false;
  static String currentRoute = '/homepage';
  // ignore: prefer_typing_uninitialized_variables
  static var currentLocation;
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late String userName, password;

  void tryToLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName') ?? '';
    password = prefs.getString('password') ?? '';
    await AuthService().login(userName.toString(), password.toString()).then(
      (val) async {
        if (val.data['success']) {
          await AuthService().getinfo(val.data['token']).then(
            (val) {
              if (val.data['success']) {
                LoadingScreen.isLogined = true;
                LoginScreen.userid = val.data['userid'];
                LoginScreen.email = val.data['email'];
                LoginScreen.username = val.data['username'];
                LoginScreen.profilepicture = val.data['profilepicture'];
                LoginScreen.fullname = val.data['fullname'];

                Navigator.of(context).popAndPushNamed('/main', arguments: []);
              } else {
                Navigator.of(context).popAndPushNamed('/main', arguments: []);
              }
            },
          );
          Fluttertoast.showToast(
            msg: val.data['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          Navigator.of(context).popAndPushNamed('/main', arguments: []);
        }
      },
    );

    Position position = await globals.deviceLocation;
    LatLng location = LatLng(position.latitude, position.longitude);
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: 13.5,
        //tilt: CAMERA_TILT,
        bearing: 30,
        target: location);
    LoadingScreen.currentLocation = initialCameraPosition;
  }

  @override
  void initState() {
    super.initState();
    tryToLogin();
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 250),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('png/Login_Logo.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: CircularProgressIndicator(
                    color: Color(0xFF6C43BC),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: const GradientText(
                    'Yükleniyor..',
                    style: TextStyle(fontSize: 20),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF6C43BC),
                        Color(0xFF72DFC5),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
