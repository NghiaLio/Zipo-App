import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';

import '../../bloc/auth/authBloc.dart';
import '../../bloc/auth/authEvent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home_screen_title),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            context.read<AuthBloc>().add(LogoutEvent());
          },
          child: Text(AppLocalizations.of(context)!.logout_button),
        ),
      ),
    );
  }
}
