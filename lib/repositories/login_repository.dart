import 'package:tutor_search_system/commons/global_variables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_search_system/models/person.dart';
import 'package:tutor_search_system/repositories/account_repository.dart';
import 'package:tutor_search_system/repositories/tutee_repository.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/role_router.dart';
import 'package:tutor_search_system/screens/common_ui/login_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/home_screens/tutee_home_screen.dart';

class LoginRepository {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

//sign in (login) by Google account
//need to  refactor
//add JWT heres
  Future handleGoogleSignIn(BuildContext context) async {
    //reset global var
    isTakeFeedback = false;
    //
    await _googleSignIn.signIn().whenComplete(() async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
      });
    });

    // });
    // final GoogleSignInAccount account = await _googleSignIn.signIn();
    // final GoogleSignInAuthentication _googleAuth = await account.authentication;
    // final AuthCredential credential = GoogleAuthProvider.credential(
    //   idToken: _googleAuth.idToken,
    //   accessToken: _googleAuth.accessToken,
    // );

    // await _auth.signInWithCredential(credential).whenComplete(() {
    //   User currentUser = _auth.currentUser;
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     return Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(
    //         builder: (context) => RoleRouter(
    //           userEmail: currentUser.email,
    //         ),
    //       ),
    //     );
    //   });
    // });
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

//login by googole auth by firebase
  Future<GoogleSignInAccount> handleSignInGoogle() async {
    try {
      return await _googleSignIn.signIn();

      // GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // AuthCredential credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );
      // UserCredential authResult = (await _auth.signInWithCredential(credential));
      // User currentUser =  _auth.currentUser;
      // String tokenResult = await currentUser.getIdToken();

      // return userFromFirebaseUser(currentUser);
    } catch (e) {
      print('this is error when sign in: $e');
    }
  }

  //load account by email; and then use RoleId to load Tutor or Tutee account info
  Future<Person> fetchPersonByEmail(String email) async {
    final account =
        await AccountRepository().fetchAccountByEmail(http.Client(), email);
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
}
