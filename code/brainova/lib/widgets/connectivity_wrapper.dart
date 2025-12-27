import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';

/// Widget qui enveloppe l'app et affiche un banner si pas de connexion
class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        _updateConnectionStatus(results.first);
      }
    });
  }

  Future<void> _checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isNotEmpty) {
      _updateConnectionStatus(results.first);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (mounted) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          if (!_isOnline)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kMediumSpace,
                      vertical: kSmallSpace,
                    ),
                    margin: const EdgeInsets.all(kMediumSpace),
                    decoration: BoxDecoration(
                      color: kAccentPink,
                      borderRadius: BorderRadius.circular(kInputRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(kOpacityMinimal),
                          blurRadius: kIndicatorSize,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                          size: kIconSizeMedium,
                        ),
                        SizedBox(width: kSmallSpace),
                        Expanded(
                          child: Text(
                            'Vous êtes hors ligne',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: kFontSizeSmall,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}