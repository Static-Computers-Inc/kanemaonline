import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/api/auth_api.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:transparent_route/transparent_route.dart';

class WebSocketService with ChangeNotifier {
  io.Socket socket = io.io('http://kanemaonline.com:6600',
      OptionBuilder().setTransports(['websocket']).build());

  // Connect and Join Network
  void connectAndListen(String phoneNumber) {
    socket.onConnect((_) {
      debugPrint('connected');

      join(phoneNumber);
    });
  }

  void join(String phone) {
    debugPrint("Attempting to Join with phone: $phone");
    socket.emitWithAck('join', {'phone': phone}, ack: (data) {
      debugPrint('ack $data');
      if (data != null) {
        debugPrint('from server $data');
      } else {
        debugPrint("Null");
      }
    });

    debugPrint("Finished");

    joinChannel(socket, "token-verification");
  }

  void joinChannel(Socket socket, String channelName) {
    socket.emit('join', channelName);

    listenToChannel(socket, channelName);
  }

  void listenToChannel(Socket socket, String channelName) async {
    debugPrint("Listening for OTP in channel: $channelName");
    socket.on(channelName, (data) async {
      final otpCode =
          data['token'].toString(); // Assuming the OTP code is sent as a string
      debugPrint(
        "Received OTP: $otpCode",
      );
      try {
        await AuthAPI().verifyOTP(code: otpCode);
        BotToasts.showToast(message: "OTP Verified", isError: false);

        pushScreen(
          navigatorKey.currentContext!,
          Scaffold(
            backgroundColor: black.withOpacity(0.4),
            body: Center(
              child: Column(
                children: [
                  CupertinoActivityIndicator(
                    color: white,
                    radius: 14,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Verifying Account...",
                    style: TextStyle(
                      color: white,
                    ),
                  )
                ],
              ),
            ),
          ),
        );

        //get user data
      } catch (err) {
        BotToasts.showToast(
            message: err.toString().split(':').last.trim(), isError: true);
        debugPrint(err.toString());
      }
      // Process the OTP code as needed
      debugPrint("Listen End");
    });

    socket.onDisconnect((_) => debugPrint('disconnect'));
  }
}
