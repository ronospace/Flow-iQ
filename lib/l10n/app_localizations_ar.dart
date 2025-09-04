// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'CycleSync';

  @override
  String get bottomNavHome => 'الرئيسية';

  @override
  String get bottomNavCycle => 'الدورة';

  @override
  String get bottomNavHealth => 'الصحة';

  @override
  String get bottomNavSettings => 'الإعدادات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageSubtitle => 'اختر لغتك المفضلة';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsPrivacy => 'الخصوصية والأمان';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsHelp => 'المساعدة والدعم';

  @override
  String get languageSelectorTitle => 'اختيار اللغة';

  @override
  String get languageSelectorSubtitle => 'إمكانية الوصول العالمي للجميع';

  @override
  String get languageSelectorSearch => 'البحث عن اللغات...';

  @override
  String languageSelectorResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count لغة',
      one: 'تم العثور على لغة واحدة',
      zero: 'لا توجد لغات',
    );
    return '$_temp0';
  }

  @override
  String get cycleTitle => 'تتبع الدورة';

  @override
  String get cycleCurrentPhase => 'المرحلة الحالية';

  @override
  String get cycleNextPeriod => 'الدورة التالية';

  @override
  String cycleDaysLeft(int days) {
    return '$days أيام متبقية';
  }

  @override
  String get healthTitle => 'نصائح صحية';

  @override
  String get healthSymptoms => 'الأعراض';

  @override
  String get healthMood => 'الحالة المزاجية';

  @override
  String get healthEnergy => 'مستوى الطاقة';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profilePersonalInfo => 'المعلومات الشخصية';

  @override
  String get profileCycleHistory => 'تاريخ الدورات';

  @override
  String get profileDataExport => 'تصدير البيانات';

  @override
  String get helpTitle => 'المساعدة والدعم';

  @override
  String get helpFaq => 'الأسئلة الشائعة';

  @override
  String get helpContactSupport => 'التواصل مع الدعم';

  @override
  String get helpUserGuide => 'دليل المستخدم';

  @override
  String get helpPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get helpReportIssue => 'الإبلاغ عن مشكلة';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonDone => 'تم';

  @override
  String get commonError => 'خطأ';

  @override
  String get commonSuccess => 'نجح';

  @override
  String get commonLoading => 'جاري التحميل...';

  @override
  String get todayTitle => 'اليوم';

  @override
  String get yesterdayTitle => 'أمس';

  @override
  String get tomorrowTitle => 'غداً';

  @override
  String get phaseFollicular => 'المرحلة الجريبية';

  @override
  String get phaseOvulation => 'التبويض';

  @override
  String get phaseLuteal => 'المرحلة الصفراء';

  @override
  String get phaseMenstruation => 'الحيض';

  @override
  String get symptomCramps => 'تقلصات';

  @override
  String get symptomHeadache => 'صداع';

  @override
  String get symptomBackache => 'ألم في الظهر';

  @override
  String get symptomBloating => 'انتفاخ';

  @override
  String get symptomFatigue => 'تعب';

  @override
  String get moodHappy => 'سعيدة';

  @override
  String get moodSad => 'حزينة';

  @override
  String get moodAnxious => 'قلقة';

  @override
  String get moodIrritated => 'منزعجة';

  @override
  String get moodCalm => 'هادئة';

  @override
  String get energyHigh => 'طاقة عالية';

  @override
  String get energyMedium => 'طاقة متوسطة';

  @override
  String get energyLow => 'طاقة منخفضة';

  @override
  String get notificationTitle => 'إشعار CycleSync';

  @override
  String get notificationPeriodReminder => 'من المتوقع أن تبدأ دورتك قريباً';

  @override
  String get notificationOvulationReminder => 'أنت تقتربين من فترة الخصوبة';

  @override
  String get accessibilityMenuButton => 'زر القائمة';

  @override
  String get accessibilityCalendar => 'عرض التقويم';

  @override
  String get accessibilitySettingsButton => 'زر الإعدادات';

  @override
  String get homeTitle => 'CycleSync';

  @override
  String homeWelcomeMessage(String name) {
    return 'مرحباً، $name!';
  }

  @override
  String get homeWelcomeSubtitle => 'تتبعي دورتك بثقة';

  @override
  String get homeMenstrualPhase => 'مرحلة الحيض';

  @override
  String homeCycleDayInfo(int day) {
    return 'اليوم $day من دورتك';
  }

  @override
  String get homeUpcomingEvents => 'الأحداث القادمة';

  @override
  String get homeNextPeriod => 'الدورة التالية';

  @override
  String get homeOvulation => 'التبويض';

  @override
  String get homeFertileWindow => 'نافذة الخصوبة';

  @override
  String get homeQuickActions => 'إجراءات سريعة';

  @override
  String get homeLogCycle => 'تسجيل الدورة';

  @override
  String get homeViewHistory => 'عرض التاريخ';

  @override
  String get homeCalendar => 'التقويم';

  @override
  String get homeAnalytics => 'التحليلات';

  @override
  String get homeAIInsights => 'رؤى الذكاء الاصطناعي';

  @override
  String get homeDailyLog => 'السجل اليومي';

  @override
  String get homeTomorrow => 'غداً';

  @override
  String homeDaysAgo(int days) {
    return 'منذ $days أيام';
  }

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get lightModeDescription => 'استخدام المظهر الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get darkModeDescription => 'استخدام المظهر الداكن';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String get systemDefaultDescription => 'اتباع إعدادات النظام';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get languageSubtitle => 'العربية • 36 لغة متاحة';

  @override
  String get swahiliLanguage => 'السواحيلية';

  @override
  String get toolsTitle => 'الأدوات';

  @override
  String get notificationsManage => 'إدارة تذكيرات الدورة والتنبيهات';

  @override
  String get smartNotifications => 'الإشعارات الذكية';

  @override
  String get smartNotificationsDescription => 'رؤى وتوقعات مدعومة بالذكاء الاصطناعي';

  @override
  String get diagnosticsTitle => 'التشخيص';

  @override
  String get diagnosticsDescription => 'اختبار اتصال Firebase';

  @override
  String get userTitle => 'المستخدم';

  @override
  String get homeHealthInsights => 'رؤى صحية';

  @override
  String get homeSymptomTrends => 'اتجاهات الأعراض';

  @override
  String get homeAIHealthCoach => 'مدرب الصحة الذكي';

  @override
  String homeInDays(int days) {
    return 'خلال $days أيام';
  }

  @override
  String get homeToday => 'اليوم';

  @override
  String get homeYesterday => 'أمس';

  @override
  String get homeRecentCycles => 'الدورات الأخيرة';

  @override
  String get homeViewAll => 'عرض الكل';

  @override
  String get homeStartTracking => 'ابدئي تتبع دورتك';

  @override
  String get homeStartTrackingDescription => 'سجلي دورتك الأولى لرؤية رؤى وتوقعات شخصية.';

  @override
  String get homeLogFirstCycle => 'تسجيل الدورة الأولى';

  @override
  String get homeUnableToLoad => 'لا يمكن تحميل الدورات الأخيرة';

  @override
  String get homeTryAgain => 'حاولي مرة أخرى';

  @override
  String get homeNoCycles => 'لا توجد دورات مسجلة بعد. ابدئي التتبع!';

  @override
  String get dailyLogTitle => 'Daily Log';

  @override
  String get logToday => 'Log Today';

  @override
  String get history => 'History';

  @override
  String get selectedDate => 'Selected Date';

  @override
  String get quickLogTemplates => 'Quick Log Templates';

  @override
  String get greatDay => 'Great Day';

  @override
  String get goodDay => 'Good Day';

  @override
  String get okayDay => 'Okay Day';

  @override
  String get toughDay => 'Tough Day';

  @override
  String get periodDay => 'Period Day';

  @override
  String get pms => 'PMS';

  @override
  String get mood => 'Mood';

  @override
  String get energy => 'Energy';

  @override
  String get painLevel => 'Pain Level';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get saveDailyLog => 'Save Daily Log';

  @override
  String get loggingFor => 'Logging for';

  @override
  String get change => 'Change';

  @override
  String get moodLevel => 'Mood Level';

  @override
  String get energyLevel => 'Energy Level';

  @override
  String get stressLevel => 'Stress Level';

  @override
  String get sleepQuality => 'Sleep Quality';

  @override
  String get waterIntake => 'Water Intake';

  @override
  String get exercise => 'Exercise';

  @override
  String get symptomsToday => 'Symptoms Today';

  @override
  String get dailyNotes => 'Daily Notes';

  @override
  String get wellbeing => 'Wellbeing';

  @override
  String get lifestyle => 'Lifestyle';

  @override
  String get symptoms => 'Symptoms';

  @override
  String get aiInsights => 'AI Insights';

  @override
  String get aiPredictions => 'AI Predictions';

  @override
  String get personalInsights => 'Personal Insights';

  @override
  String get nextPeriod => 'Next Period';

  @override
  String get ovulation => 'Ovulation';

  @override
  String get cycleRegularity => 'Cycle Regularity';

  @override
  String get confidence => 'confidence';

  @override
  String get glasses => 'glasses';

  @override
  String get minutes => 'minutes';

  @override
  String get dailyGoalAchieved => '🎉 Daily goal achieved!';

  @override
  String minToReachDailyGoal(int minutes) {
    return '$minutes min to reach daily goal';
  }

  @override
  String get tapSymptomsExperienced => 'Tap any symptoms you experienced today:';

  @override
  String symptomSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count symptoms selected',
      one: '1 symptom selected',
    );
    return '$_temp0';
  }

  @override
  String get howFeelingToday => 'How are you feeling today? Any thoughts or observations?';

  @override
  String get feelingGreatToday => 'e.g., Feeling great today, had a good workout...';

  @override
  String get generatingAIInsights => 'Generating AI insights...';

  @override
  String get noInsightsYet => 'No insights yet';

  @override
  String get keepTrackingForInsights => 'Keep tracking your daily data to get personalized AI insights!';

  @override
  String get smartDailyLog => 'Smart Daily Log';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving...';

  @override
  String dailyLogSavedFor(String date) {
    return 'Daily log saved for $date';
  }

  @override
  String errorSavingDailyLog(String error) {
    return 'Error saving daily log: $error';
  }

  @override
  String get retry => 'Retry';

  @override
  String get veryLow => 'Very Low';

  @override
  String get low => 'Low';

  @override
  String get neutral => 'Neutral';

  @override
  String get good => 'Good';

  @override
  String get excellent => 'Excellent';

  @override
  String get exhausted => 'Exhausted';

  @override
  String get normal => 'Normal';

  @override
  String get high => 'High';

  @override
  String get energetic => 'Energetic';

  @override
  String get none => 'None';

  @override
  String get mild => 'Mild';

  @override
  String get moderate => 'Moderate';

  @override
  String get severe => 'Severe';

  @override
  String get extreme => 'Extreme';

  @override
  String get veryCalm => 'Very Calm';

  @override
  String get relaxed => 'Relaxed';

  @override
  String get stressed => 'Stressed';

  @override
  String get veryStressed => 'Very Stressed';

  @override
  String get poor => 'Poor';

  @override
  String get fair => 'Fair';

  @override
  String get veryGood => 'Very Good';

  @override
  String get cramps => 'Cramps';

  @override
  String get headache => 'Headache';

  @override
  String get moodSwings => 'Mood Swings';

  @override
  String get fatigue => 'Fatigue';

  @override
  String get bloating => 'Bloating';

  @override
  String get breastTenderness => 'Breast Tenderness';

  @override
  String get nausea => 'Nausea';

  @override
  String get backPain => 'Back Pain';

  @override
  String get acne => 'Acne';

  @override
  String get foodCravings => 'Food Cravings';

  @override
  String get sleepIssues => 'Sleep Issues';

  @override
  String get hotFlashes => 'Hot Flashes';

  @override
  String get noDailyLogsYet => 'No daily logs yet';

  @override
  String get startLoggingDailyMood => 'Start logging your daily mood and energy';

  @override
  String failedToLoadLogs(String error) {
    return 'Failed to load logs: $error';
  }

  @override
  String get notes => 'Notes';

  @override
  String get more => 'more';

  @override
  String get dailyLogSaved => 'Daily log saved!';

  @override
  String failedToSaveLog(String error) {
    return 'Failed to save log: $error';
  }

  @override
  String failedToLoadExistingLog(String error) {
    return 'Failed to load existing log: $error';
  }

  @override
  String get howAreYouFeelingToday => 'How are you feeling today?';

  @override
  String get updated => 'Updated';

  @override
  String get okay => 'Okay';

  @override
  String get tools => 'Tools';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get account => 'Account';

  @override
  String get verified => 'Verified';

  @override
  String get healthIntegration => 'Health Integration';

  @override
  String get healthIntegrationDescription => 'Sync with HealthKit and Google Fit';

  @override
  String get dataManagementDescription => 'Export, import, and backup your data';

  @override
  String get exportBackup => 'Export & Backup';

  @override
  String get exportBackupDescription => 'Generate reports and backup your data';

  @override
  String get socialSharing => 'Social Sharing';

  @override
  String get socialSharingDescription => 'Share data with providers and partners';

  @override
  String get syncStatus => 'Sync Status';

  @override
  String get syncStatusDescription => 'Check cloud synchronization';

  @override
  String get about => 'About';

  @override
  String get aboutDescription => 'App version and credits';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutDescription => 'Sign out of your account';

  @override
  String get getHelpUsingFlowSense => 'Get help using FlowSense';

  @override
  String get viewSymptomPatterns => 'View symptom patterns and insights';

  @override
  String get viewAllCycles => 'View all cycles';

  @override
  String get viewCycleInsights => 'View cycle insights';

  @override
  String get testFirebaseConnection => 'Test Firebase connection';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String featureAvailableInFuture(String feature) {
    return '$feature will be available in a future update.';
  }

  @override
  String get ok => 'OK';

  @override
  String get aboutFlowSense => 'About FlowSense';

  @override
  String get flowSenseVersion => 'FlowSense v1.0.0';

  @override
  String get modernCycleTrackingApp => 'A modern cycle tracking app built with Flutter.';

  @override
  String get features => 'Features:';

  @override
  String get cycleLoggingTracking => '• Cycle logging and tracking';

  @override
  String get analyticsInsights => '• Analytics and insights';

  @override
  String get darkModeSupport => '• Dark mode support';

  @override
  String get cloudSynchronization => '• Cloud synchronization';

  @override
  String get privacyFocusedDesign => '• Privacy-focused design';

  @override
  String get areYouSureSignOut => 'Are you sure you want to sign out?';

  @override
  String get firebaseAuthentication => 'Firebase Authentication';

  @override
  String get connected => 'Connected';

  @override
  String get cloudFirestore => 'Cloud Firestore';

  @override
  String syncedMinutesAgo(int minutes) {
    return 'Synced $minutes minutes ago';
  }

  @override
  String get healthData => 'Health Data';

  @override
  String get pendingSync => 'Pending sync';

  @override
  String get analyticsData => 'Analytics Data';

  @override
  String get upToDate => 'Up to date';

  @override
  String get totalSyncedRecords => 'Total synced records:';

  @override
  String get lastFullSync => 'Last full sync:';

  @override
  String todayAt(String time) {
    return 'Today at $time';
  }

  @override
  String get storageUsed => 'Storage used:';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get manualSyncCompleted => 'Manual sync completed successfully!';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get signInWithApple => 'Continue with Apple';

  @override
  String get tryAsGuest => 'Try as Guest';

  @override
  String get orContinueWithEmail => 'or email';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinFlowSenseCommunity => 'Join the FlowSense community';

  @override
  String get passwordHelp => 'At least 6 characters';

  @override
  String get termsAgreement => 'By creating an account, you agree to our Terms of Service and Privacy Policy';
}
