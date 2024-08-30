import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'capture_event.dart';
part 'capture_state.dart';

class CaptureBloc extends Bloc<CaptureEvent, CaptureState> {
  CaptureBloc() : super(const CaptureState()) {
    on<PressButton>((event, emit) {
      emit(state.copyWith(pressed: true));
    });

    on<ReleaseButton>((event, emit) {
      emit(state.copyWith(pressed: false));
    });
  }
}
