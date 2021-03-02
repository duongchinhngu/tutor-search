import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/commons/colors.dart';
import 'package:tutor_search_system/commons/styles.dart';
import 'package:tutor_search_system/cubits/tutor_cubit.dart';
import 'package:tutor_search_system/repositories/tutor_repository.dart';
import 'package:tutor_search_system/screens/common_ui/waiting_indicator.dart';
import 'package:tutor_search_system/states/tutee_state.dart';
import 'package:tutor_search_system/states/tutor_state.dart';

class TutorDetails extends StatelessWidget {
  final int tutorId;
  const TutorDetails({Key key, @required this.tutorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TutorCubit(TutorRepository()),
      child:
          // ignore: missing_return
          BlocBuilder<TutorCubit, TutorState>(builder: (context, state) {
        //call category cubit and get all course
        final tutorCubit = context.watch<TutorCubit>();
        tutorCubit.getTutorByTutorId(tutorId);
        //render proper UI for each Course state
        if (state is TutorLoadingState) {
          return buildLoadingIndicator();
        } else if (state is TutorLoadedState) {
          return Scaffold(
            body: Container(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                        color: mainColor,
                      ),
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 60, 0, 0),
                      child: Row(
                        children: [
                          Container(
                            child: CircleAvatar(
                              radius: 65,
                              backgroundImage: NetworkImage(
                                state.tutor.avatarImageLink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(140, 60, 0, 0),
                      child: Column(
                        children: [
                          Container(
                            child: Container(
                              width: 200,
                              height: 40,
                              child: Text(
                                state.tutor.fullname,
                                style: TextStyle(
                                    color: textWhiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/starsmall.png'),
                                Image.asset('assets/images/starsmall.png'),
                                Image.asset('assets/images/starsmall.png'),
                                Image.asset('assets/images/starsmall.png'),
                                Image.asset('assets/images/starsmall.png'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                boxShadow: [
                                  // BoxShadow(
                                  //   color: Colors.grey.withOpacity(0.02),
                                  //   spreadRadius: 5,
                                  //   blurRadius: 7,
                                  //   offset: Offset(0, 3), // changes position of shadow
                                  // ),
                                  boxShadowStyle,
                                ],
                              ),
                              width: 210,
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "12",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Courses",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "125",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Reviews",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "176",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Followers",
                                          style: TextStyle(
                                            color: textGreyColor,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 230, 0, 0),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        state.tutor.description,
                                        style: TextStyle(
                                          color: textGreyColor,
                                          fontSize: 11,
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 10, 10),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30),
                                                child: Image.asset(
                                                    'assets/images/gender.png'),
                                              ),
                                              Text(state.tutor.gender)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 10, 10),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30),
                                                child: Image.asset(
                                                    'assets/images/birthday-cake.png'),
                                              ),
                                              Text(state.tutor.birthday)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 10, 10),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30),
                                                child: Image.asset(
                                                    'assets/images/email.png'),
                                              ),
                                              Text(state.tutor.email)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 10, 10),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30),
                                                child: Image.asset(
                                                    'assets/images/phone.png'),
                                              ),
                                              Text(state.tutor.phone)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 10, 10),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30),
                                                child: Image.asset(
                                                    'assets/images/pinlocation.png'),
                                              ),
                                              Container(
                                                width: 250,
                                                child: Text(
                                                  state.tutor.address,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 5, 10, 10),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30),
                                                child: Image.asset(
                                                    'assets/images/major.png'),
                                              ),
                                              Text(state.tutor.educationLevel)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (state is TutorLoadFailedState) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
      }),
    );
  }
}
