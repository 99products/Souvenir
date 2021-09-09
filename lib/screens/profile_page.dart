import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: LoginPageWidget()));

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> with WidgetsBindingObserver {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;
  static const platform =
      const MethodChannel('com.ninetynine.travel_explorer/wallet');

  bool isUserSignedIn = false;
  bool isWalletConnected = false;
  String walletAddress;

  @override
  void initState() {
    super.initState();

    initApp();
    checkIfUserConnectedToWallet();
    if(WidgetsBinding.instance != null){
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    if(WidgetsBinding.instance != null){
      WidgetsBinding.instance.removeObserver(this);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        checkIfUserConnectedToWallet();
        break;
    }
  }

  void initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);
    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
    var userSignedIn = await _googleSignIn.isSignedIn();
    log(userSignedIn.toString());
    setState(() {
      isUserSignedIn = userSignedIn;
    });
  }

  void checkIfUserConnectedToWallet() async {
    try {
      final bool isConnected = await platform.invokeMethod('walletConnectionState');
      String updatedWalletAddress = walletAddress;
      if(isConnected) {
        updatedWalletAddress = await platform.invokeMethod('walletAddress');
      }
      setState(() {
        isWalletConnected = isConnected;
        walletAddress = updatedWalletAddress;
      });
    } catch(e) {
      print(e);
    }
  }

  void updateWalletConnectState(bool isConnected) {
    setState(() {
      isWalletConnected = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(50),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          onGoogleSignIn(context);
                        },
                        color:
                            isUserSignedIn ? Colors.green : Colors.blueAccent,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.account_circle, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                    isUserSignedIn
                                        ? 'You\'re logged in with Google'
                                        : 'Login with Google',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ))),
                    isUserSignedIn ? WalletWidget(isWalletConnected, walletAddress) : Text('')
                  ],
                ))));
  }

  Future<User> _handleSignIn() async {
    User user;
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = _auth.currentUser;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }
    print(user);
    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    User user = await _handleSignIn();
    var userSignedIn = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WelcomeUserWidget(user, _googleSignIn)),
    );

    setState(() {
      isUserSignedIn = userSignedIn == null ? true : false;
    });
  }
}

class WelcomeUserWidget extends StatelessWidget {
  GoogleSignIn _googleSignIn;
  User _user;

  WelcomeUserWidget(User user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: Container(
            color: Colors.white,
            padding: EdgeInsets.all(50),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                        child: Image.network(_user.photoURL,
                            width: 100, height: 100, fit: BoxFit.cover)),
                    SizedBox(height: 20),
                    Text('Welcome,', textAlign: TextAlign.center),
                    Text(_user.displayName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                    SizedBox(height: 20),
                    FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          print(_user.email);
                          _googleSignIn.signOut();
                          Navigator.pop(context, false);
                        },
                        color: Colors.redAccent,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.exit_to_app, color: Colors.white),
                                SizedBox(width: 10),
                                Text('Log out of Google',
                                    style: TextStyle(color: Colors.white))
                              ],
                            )))
                  ],
                ))));
  }
}

class WalletWidget extends StatelessWidget {
  bool _isWalletConnected;
  String _walletAddress;
  static const platform = const MethodChannel('com.ninetynine.travel_explorer/wallet');

  WalletWidget(bool isWalletConnected, String walletAddress) {
    _isWalletConnected = isWalletConnected;
    _walletAddress = walletAddress;
  }

  Widget addressWidget() {
    return (
      Text('ETH address $_walletAddress')
    );
  }

  Widget connectWidget() {
    return (
    Container(
      color: Colors.white,
      padding: EdgeInsets.all(50),
      child: TextButton(
          child: Text('Connect to metamask'),
          onPressed: ()async  {
          await platform.invokeMethod('connectWallet');
        },
      ),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_isWalletConnected) {
      return addressWidget();
    } else {
      return connectWidget();
    }
  }

}
