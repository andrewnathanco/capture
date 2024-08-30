part of 'capture_bloc.dart';

@immutable
final class CaptureState extends Equatable {
  const CaptureState({this.pressed = false});

  final bool pressed;

  @override
  List<Object> get props => [pressed];

  // copy with
  CaptureState copyWith({
    bool? pressed,
  }) {
    return CaptureState(
      pressed: pressed ?? this.pressed,
    );
  }
}
