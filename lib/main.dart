import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/auth/authBloc.dart';
import 'package:maintain_chat_app/bloc/chat/chatBloc.dart';
import 'package:maintain_chat_app/bloc/messages/messageBloc.dart';
import 'package:maintain_chat_app/bloc/post/postBloc.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/repositories/authRepo.dart';
import 'package:maintain_chat_app/repositories/chatRepo.dart';
import 'package:maintain_chat_app/repositories/messageRepo.dart';
import 'package:maintain_chat_app/repositories/postRepo.dart';
import 'package:maintain_chat_app/repositories/userRepo.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/screens/auth/AuthScreen.dart';
import 'package:maintain_chat_app/screens/chat/chat_detail.dart';
import 'package:maintain_chat_app/services/authService.dart';
import 'package:maintain_chat_app/services/chatService.dart';
import 'package:maintain_chat_app/services/messageService.dart';
import 'package:maintain_chat_app/services/postsService.dart';
import 'package:maintain_chat_app/services/userService.dart';
import 'Caching/Database/Init.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
void main() async {
   //native splash
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  await dotenv.load(fileName: '.env');
  // Ensure Flutter engine & services are initialized before using plugins/platform channels
  WidgetsFlutterBinding.ensureInitialized();
  await InitializedCaching.initializeListChat();
  // Initialize Firebase before running the app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  //supabase setup
  await Supabase.initialize(
    url: dotenv.env['URL_SUPABASE']!,
    anonKey: dotenv.env['ANONKEY_SUPABASE']!,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  //repo
  final Authrepo authrepo = Authservice();
  final UserRepo userRepo = UserService();
  final MessageRepo messageRepository = MessageService();
  

  // Tạo instance 1 lần thay vì dùng getter
  late final ChatRepo chatRepository = ChatService(userRepo);
  late final PostRepo postRepository = PostService(userRepo);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (create) => AuthBloc(
                authrepo,
                chatRepository,
                userRepo,
                messageRepository,
                postRepository
              ),
        ),
        BlocProvider(
          create: (create) => ChatBloc(chatRepository: chatRepository),
        ),
        BlocProvider(create: (create) => UserBloc(userRepository: userRepo)),
        BlocProvider(
          create: (create) => MessageBloc(messageRepository: messageRepository),
        ),
        BlocProvider(
          create: (create) => PostBloc(postRepository: postRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: AuthScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/chatDetail': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
            return ModernChatScreen(
              user: args['user'] as UserApp,
              chatId: args['chatId'] as String,
            );
          },
        },
      ),
    );
  }
}
