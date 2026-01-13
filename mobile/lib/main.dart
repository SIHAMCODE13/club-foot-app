import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/users/users_screen.dart';
import 'screens/equipes/equipes_screen.dart';
import 'screens/joueurs/joueurs_screen.dart';
import 'screens/entrainements/entrainements_screen.dart';
import 'screens/matchs/matchs_screen.dart';
import 'screens/cotisations/cotisations_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Club Foot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFFFC107), // Amber/Yellow
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: const Color(0xFFFFC107), // Yellow
            secondary: const Color(0xFF212121), // Almost Black
            tertiary: Colors.white,
            surface: Colors.white,
            background: const Color(0xFFFAFAFA),
            onPrimary: const Color(0xFF212121),
            onSecondary: Colors.white,
            onSurface: const Color(0xFF212121),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF212121),
            foregroundColor: const Color(0xFFFFC107),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: const Color(0xFFFFC107),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.zero,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC107),
              foregroundColor: const Color(0xFF212121),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFFC107), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: const Color(0xFF212121),
            selectedItemColor: const Color(0xFFFFC107),
            unselectedItemColor: Colors.grey[600],
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/users': (context) => const UsersScreen(),
          '/equipes': (context) => const EquipesScreen(),
          '/joueurs': (context) => const JoueursScreen(),
          '/entrainements': (context) => const EntrainementsScreen(),
          '/matchs': (context) => const MatchsScreen(),
          '/cotisations': (context) => const CotisationsScreen(),
          '/calendar': (context) => const CalendarScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
