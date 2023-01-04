import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:test_flutter/main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isLoading = true;
  late CameraController _cameraController;

  bool isRecording = false;

  //Volume
  double currentvol = 0;
  double currentTouch = 0;
  String buttontype = "none";

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
    PerfectVolumeControl.stream.listen((volume) {
      if(volume != currentvol){ //only execute button type check once time
        if(volume > currentvol){ //if n
            currentTouch = currentTouch + 1;
        }else{ //else it is down button
          // buttontype = "down";
        }
      }
      if(currentTouch == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Test Flutter')),
        );
      }
      setState(() {
        currentvol = volume;
      });

    });

  }


  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) =>
    camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
    setState(() => isLoading = false);
  }

  _recordVideo() async {
    if (isRecording) {
      //Stop Record || File for Open record video now not been used
      final file = await _cameraController.stopVideoRecording();
      setState(() => isRecording = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Test Flutter')),
      );
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.cyanAccent,
          ),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      );


    }

  }
}
