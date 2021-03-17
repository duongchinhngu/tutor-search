import 'package:bloc/bloc.dart';
import 'package:tutor_search_system/models/subject.dart';
import 'package:tutor_search_system/repositories/subject_repository.dart';
import 'package:tutor_search_system/states/subject_state.dart';
import 'package:http/http.dart' as http;

class SubjectCubit extends Cubit<SubjectState> {
  SubjectRepository _repository;
  SubjectCubit(this._repository) : super(SubjectLoadingState());

  //get all subjects
  Future getSubjectsByStatus(String status) async {
    try {
      List<Subject> subjects = await _repository.fetchSubjectsByStatus(http.Client(), status);
      emit(SubjectListLoadedState(subjects));
    } catch (e) {
      emit(SubjectLoadFailedState('$e'));
    }
  }
}
