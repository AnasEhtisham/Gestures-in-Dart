import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Offset _startLastOffset = Offset.zero;
  Offset _lastOffset = Offset.zero;
  Offset _currentOffset = Offset.zero;

  double _lastScale = 1.0;
  double _currentScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gesture Detector Example')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onDoubleTap: _onDoubleTap,
      onLongPress: _onLongPress,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _transformScaleAndTranslate(),
          _positionedStatusBar(context),
        ],
      ),
    );
  }

  // Method to handle scaling and translation of the image
  Transform _transformScaleAndTranslate() {
    return Transform.scale(
      scale: _currentScale,
      child: Transform.translate(
        offset: _currentOffset,
        child: Image.asset('assets/elephant.jpg'),
      ),
    );
  }

  // Status bar at the top to display current scale and position
  Positioned _positionedStatusBar(BuildContext context) {
    return Positioned(
      top: 0.0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.white54,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Scale: ${_currentScale.toStringAsFixed(4)}'),
            Text('Position: $_currentOffset'),
          ],
        ),
      ),
    );
  }

  // Gesture Handlers
  void _onScaleStart(ScaleStartDetails details) {
    _startLastOffset = details.focalPoint;
    _lastOffset = _currentOffset;
    _lastScale = _currentScale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentScale = _lastScale * details.scale;
      _currentOffset = _lastOffset + (details.focalPoint - _startLastOffset);
    });
  }

  void _onDoubleTap() {
    setState(() {
      _currentScale *= 1.5; // Increase scale by 50% on double-tap
    });
  }

  void _onLongPress() {
    setState(() {
      _currentScale = 1.0; // Reset to original scale
      _currentOffset = Offset.zero; // Reset position
    });
  }
}
