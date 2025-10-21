import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/flow_iq_sync_service.dart';
import 'services/health_diagnosis_service.dart';
import 'services/enhanced_ai_service.dart';
import 'services/voice_input_service.dart';
import 'services/wearables_data_service.dart';
import 'services/multimodal_input_service.dart';
import 'services/phase_based_recommendations_service.dart';
import 'services/ml_prediction_service.dart';
import 'screens/home_screen.dart';
import 'screens/flow_iq_home_screen.dart';
import 'screens/tracking_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/health_diagnosis_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/dashboard_example.dart';
import 'screens/flow_iq_splash_screen.dart';
import 'themes/flow_iq_visual_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlowIQSyncService()),
        ChangeNotifierProvider(create: (context) => HealthDiagnosisService(
          Provider.of<FlowIQSyncService>(context, listen: false),
        )),
        ChangeNotifierProvider(create: (context) => EnhancedAIService(
          Provider.of<FlowIQSyncService>(context, listen: false),
        )),
        ChangeNotifierProvider(create: (_) => VoiceInputService()),
        ChangeNotifierProvider(create: (_) => WearablesDataService()),
        ChangeNotifierProvider(create: (context) => MultimodalInputService(
          Provider.of<VoiceInputService>(context, listen: false),
        )),
        ChangeNotifierProvider(create: (context) => PhaseBasedRecommendationsService(
          Provider.of<WearablesDataService>(context, listen: false),
          Provider.of<EnhancedAIService>(context, listen: false),
        )),
        ChangeNotifierProvider(create: (context) => MLPredictionService(
          Provider.of<WearablesDataService>(context, listen: false),
          Provider.of<EnhancedAIService>(context, listen: false),
        )),
      ],
      child: const FlowIQApp(),
    ),
  );
}

class FlowIQApp extends StatelessWidget {
  const FlowIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow iQ - Revolutionary Clinical Period Tracking',
      theme: FlowIQVisualSystem.lightTheme,
      darkTheme: FlowIQVisualSystem.darkTheme,
      themeMode: ThemeMode.system,
      home: const FlowIQSplashScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/home': (context) => const HomeScreen(),
        '/tracking': (context) => const TrackingScreen(),
        '/insights': (context) => const InsightsScreen(),
        '/health': (context) => const HealthDiagnosisScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/dashboard': (context) => const DashboardExample(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const FlowIQHomeScreen(),
    const TrackingScreen(),
    const InsightsScreen(),
    const HealthDiagnosisScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Track',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety),
            label: 'Health',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
