import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/screens/common_ui/common_dialogs.dart';

class TutorRegisterSuccessfullyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildSignOutButton(context),
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            //welcome title
            _buildWelcomeLabel(),
            //illustration image
            buildIllustrationImage(),
            //explanation text field
            _buildExtraInformation(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buildSignOutButton(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.blue.shade300,
        elevation: 3.0,
        isExtended: false,
        onPressed: () async {
          //
          showLogoutConfirmDialog(context);
        },
        child: Icon(
          Icons.power_settings_new_outlined,
          color: textWhiteColor,
        ));
  }

//extra info
  Widget _buildExtraInformation() {
    return Column(
      children: [
        //
        Container(
          child: Text(
            'Verification is going to complete soon!',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                color: textGreyColor,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        //explanation text field
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 10,
            bottom: 30,
          ),
          child: Text(
            'Your account status is Pending now!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textFontSize,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Container buildIllustrationImage() {
    return Container(
      padding: EdgeInsets.only(
        top: 0,
        bottom: 20,
      ),
      child: Image.asset(
        'assets/images/education-concept-vector-illustration-in-flat-style-online-education-school-university-creative-ideas.jpg',
      ),
    );
  }

  Container _buildWelcomeLabel() {
    return Container(
      padding: EdgeInsets.only(top: 110, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 30,
            color: Colors.greenAccent[700],
          ),
          Text(
            'Your registration succeeded!',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                color: textGreyColor,
                fontSize: headerFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
