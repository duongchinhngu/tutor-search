import 'package:tutor_search_system/models/tutee.dart';

abstract class TuteeState {}

class TuteeLoadingState extends TuteeState {}
class TuteeNoDataState extends TuteeState {}

class TuteeLoadedState {
  final Tutee tutee;

  TuteeLoadedState(this.tutee);
}

class TuteeListLoadedState extends TuteeState {
  final List<Tutee> tutees;

  TuteeListLoadedState(this.tutees);
}

class TuteeErrorState extends TuteeState {
  final String errorMessage;

  TuteeErrorState(this.errorMessage);
}
