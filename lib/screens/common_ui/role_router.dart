import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_search_system/cubits/login_cubit.dart';
import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/models/tutor.dart';
import 'package:tutor_search_system/repositories/login_repository.dart';
import 'package:tutor_search_system/screens/common_ui/splash_screen.dart';
import 'package:tutor_search_system/screens/tutee_screens/tutee_wrapper.dart';
import 'package:tutor_search_system/screens/common_ui/login_screen.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_register_screens/tutor_register_successfully.dart';
import 'package:tutor_search_system/screens/tutor_screens/tutor_wrapper.dart';
import 'package:tutor_search_system/states/login_state.dart';
import 'package:tutor_search_system/commons/global_variables.dart' as globals;

class RoleRouter extends StatelessWidget {
  final String userEmail;

  const RoleRouter({Key key, @required this.userEmail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(LoginRepository()),
      child: BlocBuilder<LoginCubit, LoginState>(
        // ignore: missing_return
        builder: (context, state) {
          //
          final loginCubit = context.watch<LoginCubit>();
          loginCubit.routeRole(userEmail);
          //
          if (state is InitialLoginState) {
            return SplashScreen();
          } else if (state is SignedInFailedState) {
            return Container(
              child: Center(
                child: Text('this error: ' + state.errorMessage),
              ),
            );
          } else if (state is SignInSucceededState) {
            if (state.person == null) {
              //remove all screen stack and navigate
              WidgetsBinding.instance.addPostFrameCallback((_) {
                return Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      snackBarIcon: Icons.error_outline,
                      snackBarContent: "Invalid Email! Please try again!",
                      snackBarThemeColor: Colors.red[900],
                      snackBarTitle: 'Error',
                    ),
                  ),
                );
              });
            } else if (state.person is Tutor) {
              //set authorized Tutor
              globals.authorizedTutor = state.person;
              if (globals.authorizedTutor.status == 'Pending') {
                //remove all screen stack and navigate
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  return Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => TutorRegisterSuccessfullyScreen(),
                    ),
                  );
                });
              } else if (globals.authorizedTutor.status == 'Active') {
                //remove all screen stack and navigate
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  return Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => TutorBottomNavigatorBar(),
                    ),
                  );
                });
              }
            } else if (state.person is Tutee) {
              //set authorized tutee
              globals.authorizedTutee = state.person;
              //remove all screen stack and navigate
              WidgetsBinding.instance.addPostFrameCallback((_) {
                return Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TuteeBottomNavigatorBar(),
                  ),
                );
              });
            }
            return SplashScreen();
          }
        },
      ),
    );
  }
}
