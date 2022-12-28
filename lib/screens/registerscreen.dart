import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tripmap/services/authservices.dart';
export 'registerscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  OverlayEntry? entry;
  final _formKey = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordagainController = TextEditingController();

  bool comparePaswords(String password, String passwordagain, String name,
      String mail, String fullname) {
    if (password != '' &&
        passwordagain != '' &&
        name != '' &&
        mail != '' &&
        fullname != '') {
      if (password == passwordagain) {
        return true;
      } else {
        return false;
      }
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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF6C43BC)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'png/DuzLogo.PNG',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              physics: const ClampingScrollPhysics(),
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const SizedBox(height: 100),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: fullnameController,
                    decoration: InputDecoration(
                      labelText: 'Ad Soyad',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF6C43BC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF72DFC5)),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: mailController,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF6C43BC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF72DFC5)),
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
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)) {
                          return 'Geçerli Bir Email Adresi Girin';
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
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Kullanıcı Adı',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF6C43BC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF72DFC5)),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF6C43BC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF72DFC5)),
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
                        } else if (!comparePaswords(
                          passwordController.text,
                          passwordagainController.text,
                          nameController.text,
                          mailController.text,
                          fullnameController.text,
                        )) {
                          return 'Şifreler Uyuşmuyor';
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
                    obscureText: true,
                    controller: passwordagainController,
                    decoration: InputDecoration(
                      labelText: 'Şifre Tekrar',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF6C43BC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF72DFC5)),
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
                        } else if (!comparePaswords(
                            passwordController.text,
                            passwordagainController.text,
                            nameController.text,
                            mailController.text,
                            fullnameController.text)) {
                          return 'Şifreler Uyuşmuyor';
                        } else {
                          return null;
                        }
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 50),
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
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            WidgetsBinding.instance.addPostFrameCallback(
                                (_) => showLoadingOverlay());
                          });
                          AuthService()
                              .adduser(
                                  nameController.text,
                                  passwordController.text,
                                  mailController.text,
                                  fullnameController.text)
                              .then(
                            (val) {
                              if (val.data['success']) {
                                setState(() {
                                  hideLoadingOverlay();
                                });
                                Fluttertoast.showToast(
                                  msg: 'Başarıyla Kaydolundu',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.of(context).pop();
                              } else {
                                Fluttertoast.showToast(
                                  msg: val.data['msg'],
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
