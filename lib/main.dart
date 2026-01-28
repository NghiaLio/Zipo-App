import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:maintain_chat_app/bloc/auth/authBloc.dart';
import 'package:maintain_chat_app/bloc/chat/chatBloc.dart';
import 'package:maintain_chat_app/bloc/messages/messageBloc.dart';
import 'package:maintain_chat_app/bloc/post/postBloc.dart';
import 'package:maintain_chat_app/bloc/theme/themeCubit.dart';
import 'package:maintain_chat_app/bloc/theme/themeState.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/l10n/l10n.dart';
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
import 'package:maintain_chat_app/themes/appTheme.dart';
import 'package:maintain_chat_app/themes/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'Caching/Database/Init.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  //native splash
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  await dotenv.load(fileName: '.env');
  // Ensure Flutter engine & services are initialized before using plugins/platform channels
  WidgetsFlutterBinding.ensureInitialized();

  //supabase setup
  await Supabase.initialize(
    url: dotenv.env['URL_SUPABASE']!,
    anonKey: dotenv.env['ANONKEY_SUPABASE']!,
  );
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  await Hive.openBox('settings');
  await InitializedCaching.initializeListChat();
  // Initialize Firebase before running the app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create:
              (create) => AuthBloc(
                authrepo,
                chatRepository,
                userRepo,
                messageRepository,
                postRepository,
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
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Zipo Social',
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            /// 👇 Always fallback to Vietnamese if locale doesn't match
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return const Locale('vi'); // default fallback
            },
            locale: state.lang,
            theme: AppTheme.lightTheme(
              selectedItemColor: state.color ?? AppColors.primaryLight,
              fontSize: state.fontSize ?? 14.0,
            ),
            darkTheme: AppTheme.darkTheme(
              selectedItemColor: state.color ?? AppColors.primaryDark,
              fontSize: state.fontSize ?? 14.0,
            ),
            themeMode: state.themeMode,
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
          );
        },
      ),
    );
  }
}
