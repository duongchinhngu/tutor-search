import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/global_variables.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/models/feedback.dart';
import 'package:tutor_search_system/models/tutor.dart';
import 'package:tutor_search_system/repositories/feedback_repository.dart';
import 'package:tutor_search_system/screens/common_ui/common_snackbars.dart';

//sending status
bool isSending = false;
//feedback dialog when use complete a course
Future showFeedbackDialog(BuildContext context, Tutor tutor) {
  return showDialog(
    barrierDismissible: !isSending,
    context: context,
    builder: (context) => Dialog(
      backgroundColor: backgroundColor,
      elevation: 1.0,
      insetAnimationCurve: Curves.ease,
      child: FeedbackDialogBody(tutor: tutor),
    ),
  );
}

class FeedbackDialogBody extends StatefulWidget {
  final Tutor tutor;

  const FeedbackDialogBody({Key key, @required this.tutor}) : super(key: key);
  @override
  _FeedbackDialogBodyState createState() => _FeedbackDialogBodyState();
}

class _FeedbackDialogBodyState extends State<FeedbackDialogBody> {
  //text controller for comment
  TextEditingController commentController = TextEditingController();
  //rating point
  double selectedRating = 3.0;

  //
  final feedbackRepository = FeedbackRepository();
  //
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IgnorePointer(
        ignoring: isSending,
        ignoringSemantics: true,
        child: Container(
          height: 460,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //title and icon label
              _buildFeedbackTitle(),
              //row user avatar; course name; tutor name
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //avatar
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        widget.tutor.avatarImageLink,
                      ),
                    ),
                    //COlumn of tutor gender and tutor name
                    Container(
                      padding: EdgeInsetsDirectional.only(
                        start: 7,
                      ),
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //tutor name
                          Text(
                            widget.tutor.fullname,
                            style: titleStyle,
                          ),
                          //
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 110,
                            child: Text(
                              widget.tutor.gender,
                              style: textStyle,
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //star rate
              Container(
                child: RatingBar.builder(
                  initialRating: selectedRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    selectedRating = rating;
                  },
                ),
              ),
              //comment
              Container(
                height: 180,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10, bottom: 0),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextFormField(
                  readOnly: isSending,
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  maxLength: 500,
                  maxLines: null,
                  controller: commentController,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    fillColor: Color(0xffF9F2F2),
                    filled: true,
                    focusedBorder: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 0.0),
                    ),
                    counter: Text(''),
                    hintText:
                        'How do you feel about this course,\ntutor, experiences..',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: textFontSize,
                    ),
                  ),
                ),
              ),
              // send button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    // to lock screen
                    setState(() {
                      isSending = !isSending;
                      //
                    });
                    //init feedback dto
                    //tutorId here is 1; temporary
                    final feedback = Feedbacks.constructor(
                      //id
                      0,
                      //comment
                      commentController.text,
                      //to tutorId
                      widget.tutor.id,
                      // //create date
                      // defaultDatetime,
                      //status
                      'Pending',
                      //tutee id
                      authorizedTutee.id,
                      //rate
                      selectedRating,
                      //this is temporary value; back end will process this
                      // defaultDatetime,
                      //this is temporary value; back end will process this
                      // 0,
                    );
                    //post feedback
                    await feedbackRepository
                        .postFeedback(feedback)
                        .then((value) => {
                              //close feedback dialog
                              Navigator.pop(context),
                              // show complete feeback
                              showFeedbackCompletedDialog(context),
                              //
                            })
                        .catchError((error) => {
                              //close feedback dialog
                              Navigator.pop(context),
                              ScaffoldMessenger.of(context).showSnackBar(
                                buildDefaultSnackBar(
                                  Icons.error_outline,
                                  'Sending feedback failed..',
                                  'Please try again later.',
                                  Colors.red[900],
                                ),
                              ),
                            });
                  },
                  child: Container(
                    width: 94,
                    height: 38,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: mainColor,
                    ),
                    child: Text(
                      isSending ? 'Sending..' : 'Send',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: textWhiteColor,
                        fontWeight: FontWeight.bold,
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

Future<dynamic> showFeedbackCompletedDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //complete icon
            Container(
              height: 100,
              alignment: Alignment.topCenter,
              child: Icon(
                Icons.check_circle_outlined,
                size: 80,
                color: Colors.greenAccent[700],
              ),
            ),
            //thank you title
            Container(
              child: Text(
                'Thank You, ' + authorizedTutee.fullname + '!',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: textGreyColor,
                    fontSize: headerFontSize,
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
                'Your feedback will improve the tutor and\nour services for your next experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textFontSize,
                  color: Colors.grey,
                ),
              ),
            ),
            //
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 94,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: mainColor,
                ),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: textWhiteColor,
                    fontWeight: FontWeight.bold,
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

Container _buildFeedbackTitle() {
  return Container(
    alignment: Alignment.centerLeft,
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //feedback icon
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            'assets/images/feedback.png',
            height: 50,
            width: 50,
            color: Colors.green,
          ),
        ),
        //label
        Text(
          'Feedback your tutor !',
          style: TextStyle(
            fontSize: headerFontSize,
            fontWeight: FontWeight.bold,
            color: defaultBlueTextColor,
          ),
        ),
      ],
    ),
  );
}
