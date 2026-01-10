import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brainova/styles/colors.dart';
import 'package:brainova/styles/sizes.dart';
import 'package:brainova/styles/spacings.dart';
import 'package:brainova/styles/texts.dart';
import 'package:brainova/services/notification_service.dart'; 
import 'package:brainova/styles/constants.dart';
import 'package:brainova/services/local_notification_service.dart';


class SessionActiveScreen extends StatefulWidget {
  final String groupeId;
  final String sessionId;
  final String groupeNom;
  final String sujet;
  final int dureePrevueMinutes;

  const SessionActiveScreen({
    super.key,
    required this.groupeId,
    required this.sessionId,
    required this.groupeNom,
    required this.sujet,
    required this.dureePrevueMinutes,
  });

  static const String routeName = '/session-active';

  @override
  State<SessionActiveScreen> createState() => _SessionActiveScreenState();
}

class _SessionActiveScreenState extends State<SessionActiveScreen> with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isPaused = false;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTime = DateTime.now();
    _startTimer();
    
    //  NOTIFIER QUE LA SESSION EST EN COURS (chrono démarre)
    _notifySessionStart();

    // Programmer les rappels locaux
  _scheduleLocalNotifications();
  }

  //  NOUVELLE FONCTION POUR NOTIFIER
  Future<void> _notifySessionStart() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await NotificationService.notifySessionEnCours(
        groupeId: widget.groupeId,
        sessionId: widget.sessionId,
        sujet: widget.sujet,
        userId: userId,
      );
    }
  }

  // Programmer les notifications locales (rappels personnels)
  Future<void> _scheduleLocalNotifications() async {
    // ID unique basé sur l'ID de la session
    final baseId = widget.sessionId.hashCode;
    
    // Notification 1 : Motivation après 30 minutes
    await LocalNotificationService.scheduleNotification(
      id: baseId + 1,
      title: 'Bravo !',
      body: 'Tu étudies "${widget.sujet}" depuis 5 secondes. Continue comme ça !',
      scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
      payload: 'session:${widget.sessionId}',
    );
    
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (!_isPaused) {
        _pauseTimer();
      }
    }
  }

  void _startTimer() {
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
    });
    _timer?.cancel();
  }

  void _resumeTimer() {
    _startTimer();
  }

  Future<void> _terminerSession() async {
    _timer?.cancel();

    final baseId = widget.sessionId.hashCode;
    await LocalNotificationService.cancelNotification(baseId + 1);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      await _firestore
          .collection('groupes')
          .doc(widget.groupeId)
          .collection('sessions')
          .doc(widget.sessionId)
          .update({
        'dureeSecondes': _secondsElapsed,
        'dureeMinutes': _secondsElapsed ~/ kSecondsPerMinute,
        'isTermine': true,
        'endTime': DateTime.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session terminée avec succès !'),
            backgroundColor: kSuccessColor,
          ),
        );
        
        Navigator.of(context).popUntil((route) => route.settings.name == '/groupe-detail');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: kErrorColor,
          ),
        );
      }
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ kSecondsPerMinute;
    final seconds = totalSeconds % kSecondsPerMinute;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    final totalSecondsPrevu = widget.dureePrevueMinutes * kSecondsPerMinute;
    if (totalSecondsPrevu == 0) return 0;
    final progress = _secondsElapsed / totalSecondsPrevu;
    return progress.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: kSurfaceColor,
            title: const Text('Quitter la session ?', style: kTitleMedium),
            content: Text(
              'La session continuera en arrière-plan. Vous pourrez y revenir.',
              style: kBodyMedium.copyWith(color: kTextSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler', style: TextStyle(color: kTextSecondary)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Quitter', style: TextStyle(color: kAccentColor)),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back-accueil.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(kScreenPadding),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final shouldPop = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: kSurfaceColor,
                              title: const Text('Quitter la session ?', style: kTitleMedium),
                              content: Text(
                                'La session continuera en arrière-plan.',
                                style: kBodyMedium.copyWith(color: kTextSecondary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Annuler', style: TextStyle(color: kTextSecondary)),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Quitter', style: TextStyle(color: kAccentColor)),
                                ),
                              ],
                            ),
                          );
                          if (shouldPop == true && mounted) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.arrow_back, color: kTextPrimary),
                      ),
                      const SizedBox(width: kPaddingHorizontalXS),
                      const Text('Retour', style: kBodyMedium),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre
                          Row(
                            children: [
                              const Text('✨', style: TextStyle(fontSize: kFontSizeXLarge)),
                              const SizedBox(width: kSmallSpace),
                              const Text('Nouvelle Session', style: kTitleLarge),
                            ],
                          ),

                          const SizedBox(height: kSmallSpace),

                          // Nom du groupe
                          Text(
                            widget.groupeNom,
                            style: kBodyMedium.copyWith(
                              fontSize: kFontSizeMedium,
                              color: kTextSecondary,
                            ),
                          ),

                          const SizedBox(height: kLargeSpace),

                          // Card Sujet
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(kMediumSpace),
                            decoration: BoxDecoration(
                              color: kSurfaceColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(kInputRadius),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sujet',
                                  style: kBodyMedium.copyWith(
                                    fontSize: kFontSizeSmall,
                                    color: kTextSecondary,
                                  ),
                                ),
                                const SizedBox(height: kPaddingVerticalXS),
                                Text(
                                  widget.sujet,
                                  style: kTitleMedium.copyWith(fontSize: kFontSizeLarge),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: kLargeSpace),

                          // Card Chronomètre
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(kLargeSpace),
                            decoration: BoxDecoration(
                              color: kSurfaceColor.withOpacity(kOpacityMediumHigh),
                              borderRadius: BorderRadius.circular(kCardRadius),
                              border: Border.all(
                                color: kAccentColor.withOpacity(kOpacityVeryLow),
                                width: kBorderWidth,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Temps écoulé',
                                  style: kBodyMedium.copyWith(
                                    fontSize: kFontSizeMedium,
                                    color: kTextSecondary,
                                  ),
                                ),
                                const SizedBox(height: kMediumSpace),
                                
                                // Chronomètre
                                Text(
                                  _formatTime(_secondsElapsed),
                                  style: kTitleLarge.copyWith(
                                    fontSize: kIconSizeXL * kIconMultiplierDouble,
                                    color: kAccentColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: kLetterSpacingWide, //4
                                  ),
                                ),

                                const SizedBox(height: kSmallSpace),

                                // Durée prévue
                                Text(
                                  'sur ${widget.dureePrevueMinutes} min prévues',
                                  style: kBodyMedium.copyWith(
                                    fontSize: kFontSizeSmall,
                                    color: kTextSecondary,
                                  ),
                                ),

                                const SizedBox(height: kLargeSpace),

                                // Barre de progression
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(kPaddingHorizontalXS),
                                  child: LinearProgressIndicator(
                                    value: _getProgress(),
                                    minHeight: kPaddingVerticalXS,
                                    backgroundColor: kPrimaryColor,
                                    valueColor: const AlwaysStoppedAnimation<Color>(kAccentColor),
                                  ),
                                ),

                                const SizedBox(height: kLargeSpace),

                                // Boutons Pause/Reprendre et Terminer
                                Row(
                                  children: [
                                    // Bouton Pause/Reprendre
                                    Expanded(
                                      child: SizedBox(
                                        height: kButtonHeight,
                                        child: OutlinedButton.icon(
                                          onPressed: _isPaused ? _resumeTimer : _pauseTimer,
                                          icon: Icon(
                                            _isPaused ? Icons.play_arrow : Icons.pause,
                                            color: _isPaused ? kAccentColor : kAccentPurple,
                                          ),
                                          label: Text(
                                            _isPaused ? 'Reprendre' : 'Pause',
                                            style: kButtonText.copyWith(
                                              color: _isPaused ? kAccentColor : kAccentPurple,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: _isPaused ? kAccentColor : kAccentPurple,
                                              width: kBorderWidth,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(kInputRadius),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: kMediumSpace),
                                    // Bouton Terminer
                                    Expanded(
                                      child: SizedBox(
                                        height: kButtonHeight,
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            final shouldTerminate = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: kSurfaceColor,
                                                title: const Text('Terminer la session ?', style: kTitleMedium),
                                                content: Text(
                                                  'Temps écoulé: ${_formatTime(_secondsElapsed)}',
                                                  style: kBodyMedium.copyWith(color: kTextSecondary),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    child: const Text('Annuler', style: TextStyle(color: kTextSecondary)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, true),
                                                    child: const Text('Terminer', style: TextStyle(color: kAccentPink)),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (shouldTerminate == true) {
                                              _terminerSession();
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: kWhiteColor,
                                          ),
                                          label: const Text(
                                            'Terminer',
                                            style: TextStyle(color: kWhiteColor),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kAccentPink,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(kInputRadius),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: kLargeSpace),

                          // Info
                          Row(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                color: kAccentColor,
                                size: kIconSizeMedium,
                              ),
                              const SizedBox(width: kSmallSpace),
                              Expanded(
                                child: Text(
                                  'Le chrono se met en pause si vous quittez la page',
                                  style: kBodyMedium.copyWith(
                                    fontSize: kFontSizeSmall,
                                    color: kTextSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}