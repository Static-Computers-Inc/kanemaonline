import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/services/websocket_service.dart';

class SocketTestScreen extends StatefulWidget {
  const SocketTestScreen({super.key});

  @override
  State<SocketTestScreen> createState() => _SocketTestScreenState();
}

class _SocketTestScreenState extends State<SocketTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Socket Test"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Socket Test"),
            GestureDetector(
              onTap: () {
                debugPrint('clicked');
                WebSocketService().connectAndListen("998435576");
              },
              child: Text(
                "Socket Test",
                style: TextStyle(
                  color: white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
