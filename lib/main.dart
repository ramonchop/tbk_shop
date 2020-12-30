import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Webpay On App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Webpay On App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final centralText = 'Acá puedes probar una tienda con Webpay desde webview ' +
      'o un customtab, 2 maneras diferentes de utilizar Webpay ' +
      'dentro de una aplicación móvil';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Icon(Icons.store, color: Colors.yellow[800], size: 160),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                centralText,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    child: Text('WEBVIEW'),
                    onPressed: () async {
                      final remoteConfig = await getRemoteConfig();
                      final url = remoteConfig.getString("url_webpay_on_app");
                      final all = remoteConfig.getAll();
                      print("url: $url");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Theme.of(context).platform !=
                                          TargetPlatform.macOS
                                      ? WebpayWebView(url)
                                      : WebpayWebViewIOS(url)));
                    },
                    // onPressed: () async {
                    //   if (await canLaunch(url)) {
                    //     launch(url, forceSafariVC: true);
                    //   }
                    // },
                  ),
                )),
            SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    child: Text('CUSTOM TAB'),
                    onPressed: () async {
                      final remoteConfig = await getRemoteConfig();
                      final url = remoteConfig.getString("url_webpay_on_app");
                      print("url: $url");

                      if (await canLaunch(url)) {
                        launch(url, forceSafariVC: true);
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<RemoteConfig> getRemoteConfig() async {
    await Firebase.initializeApp();
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    final defaults = <String, dynamic>{
      'url_webpay_on_app': 'https://wp-tbk.cumbregroup.cl/tienda/'
    };
    await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();

    return remoteConfig;
  }
}

class WebpayWebView extends StatelessWidget {
  final String url;
  const WebpayWebView(this.url, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: url,
      ),
    );
  }
}

class WebpayWebViewIOS extends StatelessWidget {
  final String url;
  const WebpayWebViewIOS(this.url, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: url,
      ),
    );
  }
}
