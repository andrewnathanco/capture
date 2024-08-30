part of 'capture_bloc.dart';

@immutable
sealed class CaptureEvent {}

class PressButton extends CaptureEvent {}

class ReleaseButton extends CaptureEvent {}
