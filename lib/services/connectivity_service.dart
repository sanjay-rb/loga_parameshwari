import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loga_parameshwari/screens/internet_error_screen.dart';
import 'package:provider/provider.dart';

class ConnectivityService with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ConnectivityService() {
    startMonitoring();
  }

  Future<void> startMonitoring() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged.listen((
      ConnectivityResult result,
    ) async {
      if (result == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      } else {
        await _updateConnectionStatus().then((bool isConnected) {
          _isOnline = isConnected;
          notifyListeners();
        });
      }
    });
  }

  Future<void> initConnectivity() async {
    try {
      final status = await _connectivity.checkConnectivity();

      if (status == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      } else {
        _isOnline = true;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      debugPrint("PlatformException: $e");
    }
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected;
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }
}

class IsConnected extends StatelessWidget {
  final Widget child;
  const IsConnected({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, value, child) {
        if (value.isOnline) {
          return child;
        } else {
          return const InternetErrorScreen();
        }
      },
      child: child,
    );
  }
}
