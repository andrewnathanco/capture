import 'package:capture/capture/capture_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const Capture());
}

class Capture extends StatelessWidget {
  const Capture({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capture',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => CaptureBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<CaptureBloc, CaptureState>(
          builder: (context, state) {
            return Stack(
              children: [
                state.pressed
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          // give me a button that is 50x50 and the secondary color
                          ActionTarget(),
                          Spacer(),
                          ActionTarget(),
                          Spacer(),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Spacer(),
                          const Spacer(),
                          const Spacer(),
                          Draggable(
                            onDraggableCanceled: (velocity, offset) {
                              context.read<CaptureBloc>().add(ReleaseButton());
                            },
                            onDragEnd: (end) {
                              context.read<CaptureBloc>().add(ReleaseButton());
                            },
                            onDragCompleted: () {
                              context.read<CaptureBloc>().add(ReleaseButton());
                            },
                            onDragStarted: () {
                              context.read<CaptureBloc>().add(PressButton());
                              // print("button press");
                            },
                            feedback: const ClickButton(
                              pressed: true,
                            ),
                            childWhenDragging: Container(),
                            child: const ClickButton(),
                          ),
                          // only show text when button is pressed
                          state.pressed ? const Text('Pressed') : Container(),
                          const Spacer(),
                        ],
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// create a button that is a 100x100 circle that shrinks when you tap it
class ActionTarget extends StatefulWidget {
  const ActionTarget({super.key});

  @override
  State<ActionTarget> createState() => _ActionTargetState();
}

class _ActionTargetState extends State<ActionTarget> {
  // create a variable to store the size of the button that is passed to the stateful widget
  double _size = 50;
  final double _press = 60;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      
      onMove: (details) {
        setState(() {
          _size = _press;
          print("test");
        });
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 75),
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

// create a button that is a 100x100 circle that shrinks when you tap it
class ClickButton extends StatefulWidget {
  const ClickButton({super.key, this.pressed = false});

  final bool pressed;

  @override
  State<ClickButton> createState() => _ClickButtonState();
}

class _ClickButtonState extends State<ClickButton> {
  // create a variable to store the size of the button that is passed to the stateful widget
  double _size = 100;

  @override
  void initState() {
    _size = widget.pressed ? 75 : 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          HapticFeedback.lightImpact();
          _size = 75;
        });
      },
      onTapCancel: () {
        setState(() {
          _size = 100;
        });
      },
      onTapUp: (_) {
        setState(() {
          _size = 100;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 75),
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
