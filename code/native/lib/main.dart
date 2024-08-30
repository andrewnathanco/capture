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
        child: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<CaptureBloc, CaptureState>(
          builder: (context, state) {
            return Stack(
              children: [
                state.pressed ? const ActionGrid() : Container(),
                Center(
                  child: Draggable(
                    data: "test",
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ButtonBase extends StatelessWidget {
  const ButtonBase({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptureBloc, CaptureState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            const Spacer(),
            const Spacer(),
            // only show text when button is pressed
            state.pressed ? const Text('Pressed') : Container(),
            const Spacer(),
          ],
        );
      },
    );
  }
}

class ActionGrid extends StatelessWidget {
  const ActionGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ActionTarget(),
            ActionTarget(),
            ActionTarget(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ActionTarget(),
            ActionTarget(),
            ActionTarget(),
          ],
        ),
      ],
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
  Color _color = Colors.deepPurple;
  final double _press = 60;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onMove: (details) {
        setState(() {
          _size = _press;
          _color = Colors.blue;
          HapticFeedback.lightImpact();
        });
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 75),
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: _color,
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
