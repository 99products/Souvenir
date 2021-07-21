import 'package:flutter/services.dart';

class PlatformService {
  final String _channelName = 'com.ninetynine.travel_explorer/wallet';
  static final PlatformService _instance = new PlatformService._internal();
  static MethodChannel _platform;

  factory PlatformService() {
    return _instance;
  }

  PlatformService._internal() {
    _platform = MethodChannel(_channelName);
  }

  Future<String> connectToWallet() async {
    return _platform.invokeMethod('connectWallet');
  }

  Future<String> getWalletAddress() async {
    return _platform.invokeMethod('walletAddress');
  }

  Future<String> mintToken() async {
    return _platform.invokeMethod('mintToken', {});
  }
}
