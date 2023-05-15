import 'package:chatzy/firebase_services/apis.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../homepage.dart';
import '../widgets/style.dart';
import 'helper/teddy_controller.dart';
import 'helper/tracking_text_input.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TeddyController _teddyController;
  String _email = '';
  String _password = '';
  String _confirmpassword = '';
  bool _isLoading = false;
  bool _isObscured = true;
  bool isSignIn = false;
  String _name = "";
  @override
  void initState() {
    _teddyController = TeddyController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Style.upperGradientColor,
              Style.lowerGradientColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 40.0,
                  ),
                  onPressed: () {
                    _teddyController.play("fail");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm exit'),
                          content: const Text('Are you sure you want to exit?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                _teddyController.play("success");
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Exit'),
                              onPressed: () {
                                _teddyController.play("fail");
                                Navigator.of(context).pop();
                                SystemNavigator.pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: height * 0.25,
                child: FlareActor(
                  "assets/Teddy.flr",
                  shouldClip: false,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.contain,
                  controller: _teddyController,
                ),
              ),
              Container(
                height: height * (isSignIn ? 0.50 : 0.35),
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      isSignIn
                          ? TrackingTextInput(
                              onTextChanged: (String name) {
                                _name = name;
                              },
                              label: "Name",
                              onCaretMoved: (Offset caret) {
                                _teddyController.coverEyes(false);
                                _teddyController.lookAt(caret);
                              },
                              icon: Icons.person,
                              enable: !_isLoading,
                            )
                          : const SizedBox(height: 10.0),
                      TrackingTextInput(
                        onTextChanged: (String email) {
                          _email = email;
                        },
                        label: "Email",
                        onCaretMoved: (Offset caret) {
                          _teddyController.coverEyes(false);
                          _teddyController.lookAt(caret);
                        },
                        icon: Icons.email,
                        enable: !_isLoading,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TrackingTextInput(
                              label: "Password",
                              isObscured: _isObscured,
                              onCaretMoved: (Offset caret) {
                                _teddyController.coverEyes(true);
                                _teddyController.lookAt(null);
                              },
                              onTextChanged: (String password) {
                                _teddyController.coverEyes(true);
                                _password = password;
                              },
                              icon: Icons.lock,
                              enable: !_isLoading,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                                _isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black45),
                            onPressed: () {
                              setState(() {
                                _teddyController.coverEyes(_isObscured);
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                        ],
                      ),
                      isSignIn
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: TrackingTextInput(
                                    label: "Confirm Password",
                                    isObscured: true,
                                    onCaretMoved: (Offset caret) {
                                      _teddyController.coverEyes(true);
                                      _teddyController.lookAt(null);
                                    },
                                    onTextChanged: (String confirmPassword) {
                                      _teddyController.coverEyes(true);
                                      _confirmpassword = confirmPassword;
                                    },
                                    icon: Icons.lock,
                                    enable: !_isLoading,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: onPressed,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 2)),
                          backgroundColor:
                              MaterialStateProperty.all(Style.buttonColor),
                        ),
                        child: _isLoading
                            ? const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 25.0,
                              )
                            : Text(
                                isSignIn ? 'Sign Up' : 'Sign In',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isSignIn
                                ? 'Already have an account? '
                                : "Don't have an account? ",
                            style: const TextStyle(color: Colors.black87),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _teddyController.lookAt(null);
                                isSignIn = !isSignIn;
                              });
                            },
                            child: Text(
                              isSignIn ? 'Sign In!' : 'Sign Up!',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressed() async {
    _teddyController.coverEyes(false);
    if (!isSignIn) {
      if (_email.isEmpty && _password.isEmpty) {
        _showSnackBar('Please Enter Valid Information');
        _teddyController.play('fail');
      } else {
        String nemail = _isEmailValid(_email);
        if (nemail != 'false') {
          _isLoading = true;
          setState(() {});
          setState(() {
            _isLoading = true;
          });
          _checkEmailPassword(
            email: nemail,
            password: _password,
          );
        }
      }
    } else {
      if (_email.isEmpty ||
          _password.isEmpty ||
          _confirmpassword.isEmpty ||
          _name.isEmpty) {
        _teddyController.play('fail');
        _showSnackBar('Please Enter all field');
      } else {
        String nemail = _isEmailValid(_email);
        if (nemail == 'false') {
          _teddyController.play('fail');
          _showSnackBar('Please Enter valid email');
        } else if (_password != _confirmpassword) {
          _teddyController.play('fail');
          _showSnackBar("password does't match");
        } else {
          _isLoading = true;
          setState(() {});
          //Todo: Add info to firebase
          _register(
            name: _name,
            email: nemail,
            password: _password,
          );
        }
      }
    }
  }

  //Helper Methods
  /// Method to validate email id returns true if email is valid
  String _isEmailValid(String email) {
    if (!email.endsWith('@gmail.com')) {
      email += '@gmail.com';
    }
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(email)) {
      return email;
    } else {
      return 'false';
    }
  }

  void _showSnackBar(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title, textAlign: TextAlign.center),
      ),
    );
  }

  void _checkEmailPassword(
      {
        required String email, required String password}) async {
    Apis.auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      _teddyController.play("success");
      Future.delayed(const Duration(seconds: 2)).then(
            (_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
      );
    }).onError((error, stackTrace) {
      if(error.toString().contains('wrong-password'))
        {
          _showSnackBar('the password that u have entered is wrong please re-enter the password');
        }
      else if(error.toString().contains('user-not-found')){
        _showSnackBar('entered user not exists please sign up!');
        setState(() {
          _teddyController.lookAt(null);
          isSignIn = !isSignIn;
        });
      }
      _isLoading = false;
      setState(() {});
    });

  }


  void _register(
      {required String email,
      required String password,
      required String name}) async {
    Apis.auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
          Apis.createUser(name);
      _teddyController.play("success");
      Future.delayed(const Duration(seconds: 2)).then(
        (_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
      );
    }).onError((error, stackTrace) {
      _isLoading = false;
      setState(() {});
      _showSnackBar(error.toString());
    });
  }
}
