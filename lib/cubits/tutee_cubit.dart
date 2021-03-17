import 'package:bloc/bloc.dart';
import 'package:tutor_search_system/models/tutee.dart';
import 'package:tutor_search_system/repositories/tutee_repository.dart';
import 'package:tutor_search_system/states/tutee_state.dart';
import 'package:http/http.dart';

class TuteeCubit extends Cubit<TuteeState> {
  final TuteeRepository _repository;
  TuteeCubit(this._repository) : super(TuteeLoadingState());
  

  //get all active class
  Future getTuteesByCourseId(int courseId) async {
    try {
      List<Tutee> tutees = await _repository.fetchTuteeByCourseId(Client(), courseId);
      if( tutees != null){
        emit(TuteeListLoadedState(tutees));
      }else{
        emit(TuteeNoDataState());
      }
      
    } catch (e) {
      emit(TuteeErrorState('$e'));
    }
  }
  
}