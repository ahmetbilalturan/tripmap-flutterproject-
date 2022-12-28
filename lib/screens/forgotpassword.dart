import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'png/DuzLogo.PNG',
          width: 140,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: const Color(0xFF6C43BC),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(40, 200, 40, 0),
                child: Text(
                  "Lütfen şifresini yenilemek istediğiniz hesabın e-posta adresini aşağıya ekleyerek yeni şifre mail'i isteyiniz.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF6C43BC),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6C43BC),
                        Color(0xFF72DFC5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Şifreyi Yenile',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
}
