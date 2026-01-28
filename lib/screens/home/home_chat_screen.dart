import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'messenger_page.dart';
import '../Social/posts_page.dart';
import '../profiles/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  Timer? _heartbeatTimer;

  final List<Widget> _screens = [
    const MessengerHomePage(),
    const PostsPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startHeartbeat();
  }

  void _startHeartbeat() {
    // Update lastActive every 30 seconds while app is active
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      log('Heartbeat: Updating lastActive timestamp');
      context.read<UserBloc>().userRepository.updateUserStatus(true);
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('Lifecycle state changed: ${state.toString()}');

    if (state == AppLifecycleState.resumed) {
      log('App resumed - starting heartbeat and updating to ONLINE');
      _startHeartbeat();
      context.read<UserBloc>().userRepository.updateUserStatus(true);
    } else if (state == AppLifecycleState.paused) {
      log('App paused - stopping heartbeat and updating to OFFLINE');
      _stopHeartbeat();
      // Update immediately to offline since heartbeat will stop
      context.read<UserBloc>().userRepository.updateUserStatus(false);
    } else if (state == AppLifecycleState.inactive) {
      log('App inactive - stopping heartbeat temporarily');
      _stopHeartbeat();
    } else if (state == AppLifecycleState.detached) {
      log('App detached - cleaning up');
      _stopHeartbeat();
      // Try to update but may not complete if process kills
      context.read<UserBloc>().userRepository.updateUserStatus(false);
    }
  }

  @override
  void dispose() {
    _stopHeartbeat();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.message_outlined),
            activeIcon: const Icon(Icons.message),
            label: AppLocalizations.of(context)!.messages_tab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.article_outlined),
            activeIcon: const Icon(Icons.article),
            label: AppLocalizations.of(context)!.posts_tab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile_tab,
          ),
        ],
      ),
    );
  }
}
