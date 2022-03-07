import 'package:cetis32_app_registro/src/constants/constants.dart';
import 'package:cetis32_app_registro/src/controllers/SignIn/SignInEmailController.dart';
import 'package:cetis32_app_registro/src/screens/login/recovery_screen.dart';
import 'package:cetis32_app_registro/src/screens/login/request_password.dart';
import 'package:cetis32_app_registro/src/utils/notify_ui.dart';
import 'package:cetis32_app_registro/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginEmailScreen extends StatefulWidget {
  _LoginEmailScreenState createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _emailError = false;
  bool _passwordError = false;
  bool _passwordVisible = false;
  final FocusNode passwordFocus = FocusNode();
  final SignInEmailController signInController = SignInEmailController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  _signIn() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState.save();

    _formKey.currentState.validate();
    if (!_formKey.currentState.validate()) return;

    var _email = emailController.text.trim();
    var _password = passwordController.text.trim();

    try {
      setLoading(true);
      Map<String, dynamic> response =
          await signInController.authenticate(context, _email, _password);

      if (response["code"] == "sign_in_success") {
      } else {
        setLoading(false);
        await NotifyUI.showError(
            context, "Estatus de inicio de sesión", response["message"]);
      }
    } catch (e) {
      print("error");
      print(e.toString());
      setLoading(false);
      await NotifyUI.showError(
          context, "Error de inicio de sesión", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 1.0,
              title: Text(
                "INICIAR SESIÓN",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
            body: ModalProgressHUD(
                inAsyncCall: loading,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight,
                    //decoration: BoxDecoration(color: Color(0Xcdcdcdff)),
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        height: 350,
                        child: _form(),
                      ),
                    ),
                    // Expanded(child: _notHavePassword()),
                  ),
                ))));
  }

  _form() {
    return (Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Align(
                alignment: Alignment.center,
                child: Text(
                  "CORREO ELECTRÓNICO: *",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textFieldLabel),
                )),
            SizedBox(height: 4),
            _emailTextField(),
            SizedBox(
              height: 0,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "CONTRASEÑA: *",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textFieldLabel),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            _passwordTextField(),
            SizedBox(
              height: 5,
            ),
            //SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text("ENTRAR"),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  fixedSize: Size(200, 45),
                  primary: AppColors.morenaLightColor,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestPasswordScreen()));
                },
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecoveryPasswordScreen()));
                    },
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ))),
          ],
        ),
      ),
    ));
  }

  _emailTextField() {
    return Container(
        height: !_emailError ? 64 : 84,
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColors.morenaLightColor, width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            // filled: true,
            //fillColor: Color.fromRGBO(255, 248, 248, 1),
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            hintText: "",
          ),
          onFieldSubmitted: (value) => passwordFocus.requestFocus(),
          validator: (value) {
            var error = "";
            if (value.trim() == "") {
              setState(() {
                _emailError = true;
              });
              return "Campo requerido.";
            }
            error = ValidatorsLumen().validateEmail(value);
            if (error != "" && error != null) {
              setState(() {
                _emailError = true;
              });
              return error;
            }

            return null;
          },
        ));
  }

  _passwordTextField() {
    return Container(
        height: !_passwordError ? 64 : 84,
        child: Stack(
          children: [
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              focusNode: passwordFocus,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.morenaLightColor, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 1)),
              onFieldSubmitted: (value) => _signIn(),
              validator: (value) {
                if (value.trim() == "") {
                  setState(() {
                    _passwordError = true;
                  });
                  return "Campo requerido";
                }

                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
          ],
        ));
  }

  _notHavePassword() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            "Si no cuentas con contraseña",
            style: TextStyle(fontSize: 15),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("puedes ", style: TextStyle(fontSize: 15)),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestPasswordScreen()));
                },
                child: Text(
                  "solicitarla aquí",
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ))
          ])
        ]));
  }
}
