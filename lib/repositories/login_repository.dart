import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_search_system/commons/authorization.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_search_system/commons/urls.dart';
import 'package:tutor_search_system/models/person.dart';
import 'package:tutor_search_system/models/project_token.dart';
import 'package:tutor_search_system/repositories/account_repository.dart';
import 'package:tutor_search_system/repositories/tutee_repository.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/role_router.dart';
import 'package:tutor_search_system/screens/common_ui/login_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/home_screens/tutee_home_screen.dart';

class LoginRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

//sign in (login) by Google account
//need to  refactor
//add JWT heres
  Future handleGoogleSignIn(BuildContext context) async {
    //reset global var
    isTakeFeedback = false;
    //
    await _googleSignIn.signIn().whenComplete(() async {
      //authenticate and save token to use
      authenticateByEmail(_googleSignIn.currentUser.email);
      // navigate to role roouter if token is provided
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (_googleSignIn.currentUser != null) {
            //if email is selected; navigate to roleRouter
            return Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => RoleRouter(
                  userEmail: _googleSignIn.currentUser.email,
                ),
              ),
            );
          }
        },
      );
    });
  }

  Future authenticateByEmail(String email) async {
    final http.Response response = await http.post(
      '$AUTH_API/authenticate?email=$email',
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      ProjectToken currentToken =
          ProjectToken.fromJson(json.decode(response.body));
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', currentToken.token);
      // //
      return true;
    } else {
      print('atuthenticate error: ' + response.statusCode.toString());
      throw ('Failed to Authenticate');
    }
  }

//sign out (log out)
  Future handleSignOut(BuildContext context) async {
    await _googleSignIn.signOut().whenComplete(() {
      //set global tutor (tutee) is null
      globals.authorizedTutor = null;
      globals.authorizedTutee = null;
      //push without back
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        ModalRoute.withName("/Login"),
      );
    });
  }

  //load account by email; and then use RoleId to load Tutor or Tutee account info
  Future<Person> fetchPersonByEmail(String email) async {
    final account = await AccountRepository().fetchAccountByEmail(
      http.Client(),
      email,
    );
    //if account == null here means: account doesn't register yet
    if (account == null) {
      return null;
    }
    //
    int roleId = account.roleId;
    if (roleId == 3) {
      return await TutorRepository()
          .fetchTutorByTutorEmail(http.Client(), account.email);
    } else if (roleId == 4) {
      return await TuteeRepository()
          .fetchTuteeByTuteeEmail(http.Client(), account.email);
    }
    return null;
  }

  Future fetchAuthTest() async {
    final response = await http.Client().get(
      'https://tutorsearchsystem.azurewebsites.net/api/auth',
      headers: await AuthorizationContants().getAuthorizeHeader(),
    );
    if (response.statusCode == 200) {
      print('thí sí dcn and marymai: ' + response.body);
    } else if (response.statusCode == 404) {
      print('Not found email in authenticate');
    } else {
      print('thí sí dcn and marymai error: ' + response.statusCode.toString());
      throw Exception('Failed to get to authenticate authorization!!!!!');
    }
  }
}
