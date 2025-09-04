import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'router.dart';
import 'services/auth_state_notifier.dart';
import 'providers/user_provider.dart';
import 'services/theme_service.dart';
import 'services/notification_service.dart';
import 'services/smart_notification_service.dart';
import 'services/performance_service.dart';
import 'services/error_service.dart';
import 'services/health_kit_service.dart';
import 'services/localization_service.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize error handling first
  await ErrorService.initialize();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');

    // Initialize performance optimizations
    await PerformanceService.initialize();

    // Initialize AdMob (Google Mobile Ads) - with crash protection
    try {
      await MobileAds.instance.initialize();
      debugPrint('✅ MobileAds initialized successfully');
    } catch (e, st) {
      debugPrint('⚠️ MobileAds initialization failed: $e');
      ErrorService.logError(e, stackTrace: st, context: 'MobileAds.initialize');
    }

    // Initialize services
    final themeService = ThemeService();
    await themeService.init();

    final localizationService = LocalizationService();
    await localizationService.initialize();

    // Initialize HealthKit service (don't await - let it initialize in background)
    final healthKitService = HealthKitService();
    try {
      // HealthKit is not available on simulators; guard to avoid crashes
      // Initialization will internally check availability as well
      healthKitService.initialize();
    } catch (e, st) {
      ErrorService.logError(
        e,
        stackTrace: st,
        context: 'HealthKitService.initialize',
      );
    }

    // Preload critical data for faster startup
    await PerformanceService.preloadCriticalData();

    // Optimize performance for device
    PerformanceService.optimizeForDevice();

    // Initialize notifications (don't await - let it initialize in background)
    NotificationService.initialize();
    SmartNotificationService.initialize();

    // Start performance monitoring in debug mode
    PerformanceService.startPerformanceMonitoring();

    runApp(
      MyApp(
        themeService: themeService,
        localizationService: localizationService,
        healthKitService: healthKitService,
      ),
    );
  } catch (error, stackTrace) {
    // Log startup error
    debugPrint('❌ App startup failed: $error');
    ErrorService.logError(
      error,
      stackTrace: stackTrace,
      context: 'App Startup',
      severity: ErrorSeverity.fatal,
    );

    // Still try to run the app with minimal functionality
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;
  final LocalizationService localizationService;
  final HealthKitService healthKitService;

  const MyApp({
    super.key,
    required this.themeService,
    required this.localizationService,
    required this.healthKitService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStateNotifier()),
        ChangeNotifierProvider(
          create: (_) {
            final userProvider = UserProvider();
            // Initialize in the background
            userProvider.initialize();
            return userProvider;
          },
        ),
        ChangeNotifierProvider.value(value: themeService),
        ChangeNotifierProvider.value(value: localizationService),
        // HealthKitService is a singleton, so we provide the instance
        Provider.value(value: healthKitService),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.router(context);
          final themeService = Provider.of<ThemeService>(context);
          final localizationService = Provider.of<LocalizationService>(context);

          return MaterialApp.router(
            title: 'Flow iQ',
            theme: ThemeService.lightTheme,
            darkTheme: ThemeService.darkTheme,
            themeMode: themeService.themeMode,
            locale: localizationService.currentLocale,

            // Supported locales - limit to those with Material/Cupertino support
            supportedLocales: _getSafeLocales(),

            // Localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            routerConfig: router,

            // Smart locale resolution with fallbacks
            localeResolutionCallback: (locale, supportedLocales) {
              // If no locale provided, use English
              if (locale == null) {
                return const Locale('en', 'US');
              }

              // Try to find exact match first
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }

              // Try to find language match
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }

              // Return closest alternative or English
              return _getBestFallbackLocale(locale.languageCode) ??
                  const Locale('en', 'US');
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

/// Get locales that are safe to use (have Material/Cupertino support)
List<Locale> _getSafeLocales() {
  // Only include locales that match our generated AppLocalizations
  // Note: These must match exactly with the ARB files we created
  return const [
    Locale('en'), // English (matches app_en.arb)
    Locale('es'), // Spanish (matches app_es.arb)
    Locale('fr'), // French (matches app_fr.arb)
    Locale('de'), // German (matches app_de.arb)
    Locale('sw'), // Swahili (matches app_sw.arb)
    Locale('ar'), // Arabic (matches app_ar.arb)
  ];
}

/// Get best fallback locale for unsupported language codes
Locale? _getBestFallbackLocale(String languageCode) {
  // Map unsupported languages to similar supported ones
  const fallbackMap = {
    // Map regional variants to main languages
    'es': Locale('es', 'ES'), // Spanish variants → Spanish (Spain)
    'pt': Locale('pt', 'BR'), // Portuguese variants → Portuguese (Brazil)
    'zh': Locale('zh', 'CN'), // Chinese variants → Chinese (Simplified)
    'en': Locale('en', 'US'), // English variants → English (US)
    // Map unsupported languages to related ones
    'id': Locale('ms', 'MY'), // Indonesian → Malay (similar language)
    'ms': Locale(
      'id',
      'ID',
    ), // Malay → Indonesian (if Indonesian not available)
    'bn': Locale('hi', 'IN'), // Bengali → Hindi (same region)
    'ur': Locale('hi', 'IN'), // Urdu → Hindi (same region)
    'fa': Locale('ar', 'SA'), // Persian → Arabic (similar script)
    'sw': Locale('en', 'US'), // Swahili → English (common in East Africa)
  };

  return fallbackMap[languageCode];
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow iQ - Error',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flow iQ - Error'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.red,
              ),
              SizedBox(height: 24),
              Text(
                'Startup Error',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'App failed to initialize properly.\nPlease restart the app.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FlowIQAppNoFirebase extends StatelessWidget {
  const FlowIQAppNoFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow iQ - Safe Mode',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flow iQ - Safe Mode'),
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: Colors.orange,
              ),
              SizedBox(height: 24),
              Text(
                'Running in Safe Mode',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Firebase features unavailable\nbut core app is stable',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
