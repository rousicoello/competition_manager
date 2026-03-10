import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/registration/request_screen.dart';
import '../features/auth/registration/register_with_code_screen.dart';
import '../features/competitions/competitions_list_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeagueHub - Competition Manager',
      theme: AppTheme.lightTheme,  // Usamos nuestro tema personalizado
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const CompetitionsListScreen(),
        '/registration-request': (context) => const RegistrationRequestScreen(),
        '/register-with-code': (context) => const RegisterWithCodeScreen(),
      },
    );
  }
}