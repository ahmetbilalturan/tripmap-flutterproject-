import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripmap/screens/loadingscreen.dart';
import 'package:tripmap/screens/loginscreen.dart';
import 'package:tripmap/services/authservices.dart';

class ProfileScreenEdit extends StatefulWidget {
  const ProfileScreenEdit({Key? key}) : super(key: key);

  @override
  State<ProfileScreenEdit> createState() => _ProfileScreenEditState();
}

class _ProfileScreenEditState extends State<ProfileScreenEdit> {
  OverlayEntry? entry;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordagainController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  void changeusername(String username) async {
    await AuthService().changeusername(LoginScreen.userid, username);
    hideLoadingOverlay();
  }

  void changepassword(String password) async {
    await AuthService().changepassword(LoginScreen.userid, password);
    hideLoadingOverlay();
  }

  bool comparepassword(String password, String passwordagain) {
    if (password == passwordagain) {
      return true;
    } else {
      return false;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(LineAwesomeIcons.arrow_left),
              color: const Color(0xFF6C43BC),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  SharedPreferences.getInstance().then(
                    (prefs) {
                      prefs.setString('userName', '');
                      prefs.setString('password', '');
                    },
                  );
                  LoadingScreen.isLogined = false;
                  Navigator.of(context).popUntil((route) => false);
                  Navigator.of(context).pushNamed('/loading', arguments: []);
                },
                icon: const Icon(Icons.logout),
                color: const Color(0xFF6C43BC),
              )
            ],
            title: Container(
              padding: const EdgeInsets.only(top: 5),
              width: 150,
              child: Image.asset(
                'png/DuzLogo.PNG',
                height: 50,
                width: 60,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  transform: Matrix4.translationValues(-140, 25, 0),
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                  child: const Text("Kullanıcı Adı Değiştir",
                      style: TextStyle(
                          color: Color(0xFF6C43BC),
                          decoration: TextDecoration.underline)),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Yeni Kullanıcı Adı',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xFF6C43BC)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xFF72DFC5)),
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
                      validator: (val) {
                        if (val != null) {
                          if (val.isEmpty) {
                            return 'Boş Bırakılamaz';
                          } else {
                            return null;
                          }
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 300),
                  child: Container(
                    height: 35,
                    width: 75,
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              WidgetsBinding.instance.addPostFrameCallback(
                                  (_) => showLoadingOverlay());
                            });
                            changeusername(nameController.text);
                          }
                        },
                        child: const Text(
                          'KAYDET',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(-140, 25, 0),
                  child: const Text("Parola İşlemleri",
                      style: TextStyle(
                          color: Color(0xFF6C43BC),
                          decoration: TextDecoration.underline)),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                ),
                Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Eski Parola',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Color(0xFF6C43BC)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Color(0xFF72DFC5)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Colors.redAccent),
                            ),
                          ),
                          validator: (val) {
                            if (val != null) {
                              if (val.isEmpty) {
                                return 'Boş Bırakılamaz';
                              } else {
                                return null;
                              }
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Yeni Parola',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Color(0xFF6C43BC)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Color(0xFF72DFC5)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Colors.redAccent),
                            ),
                          ),
                          validator: (val) {
                            if (val != null) {
                              if (val.isEmpty) {
                                return 'Boş Bırakılamaz';
                              } else if (comparepassword(
                                  passwordController.text,
                                  passwordagainController.text)) {
                                return 'Parolalar Uyuşmuyor';
                              } else {
                                return null;
                              }
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: passwordagainController,
                          decoration: InputDecoration(
                            labelText: 'Parolayı Doğrula',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Color(0xFF6C43BC)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Color(0xFF72DFC5)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Colors.redAccent),
                            ),
                          ),
                          validator: (val) {
                            if (val != null) {
                              if (val.isEmpty) {
                                return 'Boş Bırakılamaz';
                              } else if (comparepassword(
                                  passwordController.text,
                                  passwordagainController.text)) {
                                return 'Parolalar Uyuşmuyor';
                              } else {
                                return null;
                              }
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 300),
                  child: Container(
                    height: 35,
                    width: 75,
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey2.currentState!.validate()) {
                          setState(() {
                            WidgetsBinding.instance.addPostFrameCallback(
                                (_) => showLoadingOverlay());
                          });
                          changepassword(passwordController.text);
                        }
                      },
                      child: const Text(
                        'KAYDET',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
