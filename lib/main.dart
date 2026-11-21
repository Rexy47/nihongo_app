import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Nihongo',
    debugShowCheckedModeBanner: false,
    home: const Screen(),
  );
}

class Screen extends StatefulWidget {
  const Screen({super.key});
  @override
  State<Screen> createState() => _S();
}

class _S extends State<Screen> {
  late final WebViewController c;
  bool ld = true;

  @override
  void initState() {
    super.initState();
    c = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => setState(() => ld = false),
        onProgress: (p) { if (p > 80) setState(() => ld = false); },
      ))
      ..loadFlutterAsset('assets/index.html');
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (d, r) async {
      if (d) return;
      if (await c.canGoBack()) c.goBack();
    },
    child: Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: c),
            if (ld) Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFE60012)),
                    SizedBox(height: 16),
                    Text('日本語 Loading...',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE60012))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
