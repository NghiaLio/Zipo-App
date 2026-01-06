import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            context.read<AuthBloc>().add(LogoutEvent());
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
