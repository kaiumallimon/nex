import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nex/app/providers/chat_provider.dart';
import 'package:nex/app/providers/conversation_provider.dart';
import 'package:nex/app/providers/login_provider.dart';
import 'package:nex/app/providers/register_provider.dart';
import 'package:nex/app/providers/splash_provider.dart';
import 'package:nex/app/providers/wrapper_provider.dart';
import 'package:nex/app/views/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => ConversationProvider()),
        ChangeNotifierProvider(create: (context) => WrapperProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.deepOrange,
          primarySwatch: Colors.deepOrange,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
