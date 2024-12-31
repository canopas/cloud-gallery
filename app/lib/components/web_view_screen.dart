import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style/buttons/action_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/indicators/circular_progress_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'app_page.dart';

void showWebView(BuildContext context, String url) {
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (BuildContext context) => WebViewScreen(url: url),
    ),
  );
}

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;

  bool _loading = true;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith("https://cloud-gallery.canopas.com/") &&
                request.url != "https://cloud-gallery.canopas.com/") {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
          onPageFinished: (_) => setState(() {
            _loading = false;
          }),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.setBackgroundColor(context.colorScheme.surface);
    return AppPage(
      title: '',
      automaticallyImplyLeading: false,
      leading: ActionButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.close,
          color: context.colorScheme.textSecondary,
        ),
      ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: context.systemPadding,
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_loading)
                  const Center(child: AppCircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
