import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class CrabPage extends StatefulWidget {
  const CrabPage({super.key});

  @override
  State<CrabPage> createState() => _CrabPageState();
}

class _CrabPageState extends State<CrabPage> {
  // Rive Properties
  Artboard? riveArtboard;
  SMIBool? isWalk;
  SMIBool? isHands;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: riveArtboard == null
            ? const SizedBox()
            : Column(
                children: [
                  Expanded(
                    child: Rive(
                      artboard: riveArtboard!,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Walk'),
                      Switch(
                        value: isWalk!.value,
                        onChanged: (value) => toggleWalk(value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Hands'),
                      Switch(
                        value: isHands!.value,
                        onChanged: (value) => toggleHands(value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
      ),
    );
  }

  void _loadRiveFile() async {
    // Load your Rive data
    final bytes = await rootBundle.load('assets/rive_assets/interactive_crab.riv');
    final file = RiveFile.import(bytes);

    // Get the artboard and controller
    final artboard = file.mainArtboard;
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);

    // Find the properties
    isWalk = controller.findSMI('Walk');
    isHands = controller.findSMI('Hands');

    // Add a controller to play back a known animation on the main/default artboard
    setState(() => riveArtboard = artboard);
  }

  void toggleWalk(bool newValue) {
    setState(() => isWalk!.value = newValue);
  }

  void toggleHands(bool newValue) {
    setState(() => isHands!.value = newValue);
  }
}
