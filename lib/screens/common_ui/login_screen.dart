import 'dart:ui';
import 'package:braintree_payment/braintree_payment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/models/braintree.dart';
import 'package:tutor_search_system/repositories/braintree_repository.dart';
import 'package:tutor_search_system/repositories/login_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';
import 'package:tutor_search_system/screens/common_ui/common_snackbars.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_register_screens/tutee_register_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_register_screens/tutor_register_screen.dart';

class LoginScreen extends StatefulWidget {
  final IconData snackBarIcon;
  final String snackBarTitle;
  final String snackBarContent;
  final Color snackBarThemeColor;

  const LoginScreen(
      {Key key,
      this.snackBarContent,
      this.snackBarThemeColor,
      this.snackBarTitle,
      this.snackBarIcon})
      : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //
  //login repository
  final loginRepository = LoginRepository();
  //
  @override
  void initState() {
    super.initState();
    googleSignIn.signOut();
    //show error message like: "Invalid Account"
    if (widget.snackBarContent != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ScaffoldMessenger.of(context).showSnackBar(
          buildDefaultSnackBar(
            widget.snackBarIcon,
            widget.snackBarTitle,
            widget.snackBarContent,
            widget.snackBarThemeColor,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: googleSignIn.isSignedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                height: double.infinity,
                color: backgroundColor,
                child: Column(
                  children: <Widget>[
                    //welcome title
                    Container(
                      padding: EdgeInsets.only(top: 120, bottom: 30),
                      child: Text(
                        'Welcome to \nEasy Education App',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            color: textGreyColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    //illustration image
                    Container(
                      padding: EdgeInsets.only(
                        top: 0,
                        bottom: 30,
                      ),
                      child: Image.asset(
                        'assets/images/boy-studying-with-book_113065-238.jpg',
                        // width: 100,
                      ),
                    ),
                    // google login buotton
                    LoginButton(loginRepository: loginRepository),
                    //sign up link
                    InkWell(
                      onTap: () {
                        //show role selector dialog
                        showDialog(
                          context: context,
                          builder: (context) => buildDefaultDialog(
                            context,
                            'You\'d like to be Tutor or Tutee?',
                            'Choose role for registration',
                            [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TutorRegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Text('Tutor'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TuteeRegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Text('Tutee'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        // color: Colors.red,
                        width: 100,
                        height: 70,
                        alignment: Alignment.center,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: defaultBlueTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            print('Error');
          } else {
            return buildLoadingIndicator();
          }
        },
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    @required this.loginRepository,
  }) : super(key: key);

  final LoginRepository loginRepository;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //show email login dialog
        await loginRepository.handleGoogleSignIn(context);
        //
        // 
        
      },
      //
      child: Container(
        width: 263,
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffA80C0C),
        ),
        child: Text(
          'GOOGLE',
          style: TextStyle(
            fontSize: titleFontSize,
            color: textWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
