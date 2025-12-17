 import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Theme/Colors.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const PaymentWebView({
    Key? key,
    required this.paymentUrl,
    required this.orderId,
  }) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView>
    with WidgetsBindingObserver {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasRedirected = false;
  bool _paymentVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeWebView();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                setState(() {
                  _isLoading = progress < 100;
                });
              },
              onPageStarted: (String url) {
                debugPrint('Page started loading: $url');
              },
              onPageFinished: (String url) {
                debugPrint('Page finished loading: $url');

                if (!_hasRedirected && url.contains('payment-status')) {
                  _hasRedirected = true;

                  // Optionally check success/failure in the URL
                  final uri = Uri.parse(url);
                  final status =
                      uri.queryParameters['status']; // e.g., success or failed

                  // Pop the screen with a result
                  Future.delayed(Duration(milliseconds: 300), () {
                    Navigator.pop(
                      context,
                      status == 'success',
                    ); // pass true/false
                  });
                }

                setState(() {
                  _isLoading = false;
                });
              },
              onNavigationRequest: (NavigationRequest request) async {
                debugPrint('Navigation request: ${request.url}');

                if (_isUpiAppLink(request.url)) {
                  await _launchUPIApp(request.url);
                  return NavigationDecision.prevent;
                }

                // Allow navigation
                return NavigationDecision.navigate;
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint('Web resource error: ${error.description}');
                _showErrorDialog('Payment page failed to load');
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  bool _isUpiAppLink(String url) {
    final upiSchemes = [
      'tez:',
      'phonepe:',
      'paytm:',
      'upi:',
      'googlepay:',
      'bhim:',
    ];
    return upiSchemes.any((scheme) => url.toLowerCase().startsWith(scheme));
  }

  Future<void> _launchUPIApp(String url) async {
    try {
      final uri = Uri.parse(url);

      // First try launching directly
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // If direct launch fails, try checking if any UPI app is installed
        final upiApps = await _getInstalledUpiApps();
        if (upiApps.isNotEmpty) {
          // Try launching a generic UPI intent
          final genericUpiUrl = url.replaceFirst(
            RegExp(r'^[a-z]+://'),
            'upi://',
          );
          await launchUrl(
            Uri.parse(genericUpiUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          _showErrorDialog('No UPI app found to handle payment');
        }
      }
    } catch (e) {
      debugPrint('Error launching UPI app: $e');
      _showErrorDialog('Error initiating payment. Please try another method.');
    }
  }

  Future<List<String>> _getInstalledUpiApps() async {
    try {
      const upiSchemes = ['tez', 'phonepe', 'paytm', 'googlepay', 'bhim'];
      final installedApps = <String>[];

      for (final scheme in upiSchemes) {
        final testUrl = '$scheme://test';
        if (await canLaunchUrl(Uri.parse(testUrl))) {
          installedApps.add(scheme);
        }
      }

      return installedApps;
    } catch (e) {
      debugPrint('Error checking UPI apps: $e');
      return [];
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle case when user returns from UPI app
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.onBoardSecondary,
            title: Text('Payment Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: TextStyle(color: AppColors.textColor)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldClose =
            await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Cancel Payment?'),
                    content: Text(
                      'Are you sure you want to cancel this payment?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Yes'),
                      ),
                    ],
                  ),
            ) ??
            false;

        if (shouldClose && mounted) {
          Navigator.pop(context, false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Complete Payment'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              // final shouldClose =
              //     await showDialog<bool>(
              //       context: context,
              //       builder:
              //           (context) =>
              //               AlertDialog(
              //             backgroundColor: AppColors.onBoardSecondary,
              //             title: Text('Cancel Payment?'),
              //             content: Text(
              //               'Are you sure you want to cancel this payment?',
              //             ),
              //             actions: [
              //               TextButton(
              //                 onPressed: () => Navigator.pop(context, false),
              //                 child: Text(
              //                   'No',
              //                   style: TextStyle(color: Colors.white),
              //                 ),
              //               ),
              //               TextButton(
              //                 onPressed: () => Navigator.pop(context, true),
              //                 child: Text(
              //                   'Yes',
              //                   style: TextStyle(color: Colors.white),
              //                 ),
              //               ),
              //             ],
              //           ),
              //     ) ??
              //     false;
              //
              // if (shouldClose && mounted) {
              //   Navigator.pop(context, false);
              // }
              Navigator.pop(context, true);
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
