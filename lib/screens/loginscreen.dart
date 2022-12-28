import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripmap/screens/loadingscreen.dart';
import 'package:tripmap/services/authservices.dart';
export 'loginscreen.dart';

class LoginScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  static var username, email, profilepicture, userid, fullname;

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var username, password;
  final _formKey = GlobalKey<FormState>();
  OverlayEntry? entry;

  void showLoadingOverlay() {
    final overlay = Overlay.of(context)!;

    entry = OverlayEntry(
      builder: (context) => buildLoadingOverlay(),
    );

    overlay.insert(entry!);
  }

  void hideLoadingOverlay() {
    entry!.remove();
    entry = null;
  }

  Widget buildLoadingOverlay() => const Material(
        color: Colors.transparent,
        elevation: 8,
        child: Center(
          child: CircularProgressIndicator(
              color: Color.fromARGB(255, 163, 171, 192)),
        ),
      );

  void _handleRemeberme() {
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setString('userName', nameController.text);
        prefs.setString('password', passwordController.text);
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Giriş Yap', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(1),
                    child: Image.asset('png/Login_Logo.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Kullanıcı Adı',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF6C43BC),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF72DFC5),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      onChanged: (val) {
                        username = val;
                      },
                      validator: (val) {
                        if (val != null) {
                          if (val.isEmpty) {
                            return 'Boş Bırakılamaz';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF6C43BC),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF72DFC5),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      onChanged: (val) {
                        password = val;
                      },
                      validator: (val) {
                        if (val != null) {
                          if (val.isEmpty) {
                            return 'Boş Bırakılamaz';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/forgotpassowrd');
                        },
                        child: const Text(
                          'Şifremi Unuttum',
                          style: TextStyle(
                            color: Color(0xFF6C43BC),
                            fontFamily: 'Inter',
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6C43BC),
                          Color(0xFF72DFC5),
                        ],
                        stops: [
                          0.2,
                          1.0,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        child: const Text(
                          'Giriş Yap',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(
                              () {
                                WidgetsBinding.instance.addPostFrameCallback(
                                    (_) => showLoadingOverlay());
                              },
                            );
                            AuthService().login(username, password).then(
                              (val) {
                                if (val.data['success']) {
                                  AuthService().getinfo(val.data['token']).then(
                                    (val) {
                                      if (val.data['success']) {
                                        LoadingScreen.isLogined = true;
                                        LoginScreen.userid = val.data['userid'];
                                        LoginScreen.email = val.data['email'];
                                        LoginScreen.username =
                                            val.data['username'];
                                        LoginScreen.fullname =
                                            val.data['fullname'];
                                        LoginScreen.profilepicture =
                                            val.data['profilepicture'];
                                        _handleRemeberme();
                                        setState(
                                          () {
                                            hideLoadingOverlay();
                                          },
                                        );
                                        LoadingScreen.currentRoute = '/main';
                                        Navigator.of(context)
                                            .popUntil((route) => false);
                                        Navigator.of(context)
                                            .pushNamed('/main', arguments: []);
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: val.data['msg'],
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        setState(
                                          () {
                                            hideLoadingOverlay();
                                          },
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: val.data['msg'],
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  setState(
                                    () {
                                      hideLoadingOverlay();
                                    },
                                  );
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6C43BC),
                          Color(0xFF72DFC5),
                        ],
                        stops: [
                          0.2,
                          1.0,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        child: const Text(
                          'Kayıt Ol',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/register', arguments: []);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
