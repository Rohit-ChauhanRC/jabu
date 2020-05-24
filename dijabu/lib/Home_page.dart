import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'http://dijabu.com/';

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onchanged;
  // bool _checkConnection;
  var _connectionStatus = 'known';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    _onchanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.finishLoad) {
          print("loaded...");
        } else if (state.type == WebViewState.abortLoad) {
          // if there is a problem with loading the url
          print("there is a problem...");
        } else if (state.type == WebViewState.startLoad) {
          // if the url started loading
          print("start loading...");
        }
      }
    });
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(result);
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // _checkConnection = true;
        setState(() {
          flutterWebviewPlugin.reload();
        });
      } else {
        flutterWebviewPlugin.stopLoading();
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    flutterWebviewPlugin.dispose();
    
    super.dispose(); // disposing the webview widget
  }

  // Future<bool> _onBackPressed() {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Are you sure'),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('No'),
  //               onPressed: () {
  //                 // Navigator.of(context).pop(false);
  //                 flutterWebviewPlugin.show();
  //               },
  //             ),
  //             FlatButton(
  //               child: Text('Yes'),
  //               onPressed: () {
  //                 // Navigator.of(context).pop(true);
  //                 flutterWebviewPlugin.canGoBack();
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return 
    // WillPopScope(
    //   onWillPop: _onBackPressed,
    //   child: 
      SafeArea(
        child: WebviewScaffold(
          geolocationEnabled: true,
          // mediaPlaybackRequiresUserGesture: true,
          scrollBar: true,
          appCacheEnabled: true,
          url: selectedUrl,
          withZoom: true,
          withLocalStorage: true,
          withLocalUrl: true,
          supportMultipleWindows: true,
          // useWideViewPort: true,
          ignoreSSLErrors: true,
          // clearCache: true,
          hidden: true,
          withJavascript: true,
          // appBar: AppBar(
          //   title: const Text('jabu'),
          //   // actions: <Widget>[
          //   //   InkWell(
          //   //     child: Icon(Icons.refresh),
          //   //     onTap: () {
          //   //       flutterWebviewPlugin.reload();
          //   //       // flutterWebviewPlugin.reloadUrl("any link");
          //   //     },
          //   //   ),
          //   //   SizedBox(
          //   //     width: 10.0,
          //   //   ),
          //   //   InkWell(
          //   //     child: Icon(Icons.stop),
          //   //     onTap: () {
          //   //       flutterWebviewPlugin.stopLoading();
          //   //     },
          //   //   ),
          //   //   SizedBox(
          //   //     width: 10.0,
          //   //   ),
          //   //   InkWell(
          //   //     child: Icon(Icons.remove_red_eye),
          //   //     onTap: () {
          //   //       flutterWebviewPlugin.show(); // appear the webview widget
          //   //     },
          //   //   ),
          //   //   SizedBox(
          //   //     width: 10.0,
          //   //   ),

          //   //   InkWell(
          //   //     child: Icon(Icons.close),
          //   //     onTap: () {
          //   //       flutterWebviewPlugin.hide(); // hide the webview widget
          //   //     },
          //   //   ),
          //   //   SizedBox(
          //   //     width: 15.0,
          //   //   ),

          //   //   InkWell(
          //   //     child: Icon(Icons.arrow_back),
          //   //     onTap: () {
          //   //       flutterWebviewPlugin.goBack(); // for going back
          //   //     },
          //   //   ),
          //   //   SizedBox(
          //   //     width: 15.0,
          //   //   ),

          //   //   // InkWell(
          //   //   //   child: Icon(Icons.forward),
          //   //   //   onTap: (){
          //   //   //     flutterWebviewPlugin.goForward(); // for going forward
          //   //   //   },
          //   //   // ),
          //   // ],
          
          // ),

          initialChild: new Center(
            child: Container(
              height: 200,
              width: 200,
              child: new Image.asset(
                'assets/images/Jabu1.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Center(
          //   child: Container(
          //     child: CircularProgressIndicator(

          //     ),
          //   ),
          // ),
          bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      flutterWebviewPlugin.goBack();
                    },
                  ),
                  
                  // IconButton(
                  //   icon: const Icon(Icons.autorenew),
                  //   onPressed: () {
                  //     Duration(seconds: 5);
                      
                  //     flutterWebviewPlugin.reloadUrl(selectedUrl);
                  //   },
                  // ),
                  IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage()));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      flutterWebviewPlugin.goForward();
                    },
                  ),
                ],
              ),
        ),
      
      ),
    );
  }
}
