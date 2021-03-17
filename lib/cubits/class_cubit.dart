import 'package:bloc/bloc.dart';
import 'package:tutor_search_system/models/class.dart';
import 'package:tutor_search_system/repositories/class_repository.dart';
import 'package:tutor_search_system/states/class_state.dart';
import 'package:http/http.dart' as http;

class ClassCubit extends Cubit<ClassState> {
  final ClassRepository _repository;
  ClassCubit(this._repository) : super(ClassLoadingState());


  //get all active class by subject id
  Future getClassBySubjectId(int subjectId) async {
    try {
      List<Class> classes = await _repository.fetchClassBySubjectId(http.Client(), subjectId);
      emit(ClassListLoadedState(classes));
    } catch (e) {
      emit(ClassesLoadFailedState('$e'));
    }
  }
}
