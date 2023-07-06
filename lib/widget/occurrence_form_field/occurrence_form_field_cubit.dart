import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/model/occurrence.dart';

class OccurrenceFormFieldCubit extends Cubit<Occurrence> {
  OccurrenceFormFieldCubit(Occurrence initial) : super(initial);

  void set(Occurrence occurrence) {
    emit(occurrence);
  }
}
