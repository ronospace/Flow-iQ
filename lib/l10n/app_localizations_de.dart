// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'CycleSync';

  @override
  String get bottomNavHome => 'Startseite';

  @override
  String get bottomNavCycle => 'Zyklus';

  @override
  String get bottomNavHealth => 'Gesundheit';

  @override
  String get bottomNavSettings => 'Einstellungen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSubtitle => 'Wählen Sie Ihre bevorzugte Sprache';

  @override
  String get settingsNotifications => 'Benachrichtigungen';

  @override
  String get settingsPrivacy => 'Datenschutz & Sicherheit';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsHelp => 'Hilfe & Support';

  @override
  String get languageSelectorTitle => 'Sprache wählen';

  @override
  String get languageSelectorSubtitle => 'Globale Zugänglichkeit für alle';

  @override
  String get languageSelectorSearch => 'Sprachen suchen...';

  @override
  String languageSelectorResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sprachen gefunden',
      one: '1 Sprache gefunden',
      zero: 'Keine Sprachen gefunden',
    );
    return '$_temp0';
  }

  @override
  String get cycleTitle => 'Zyklusverfolgung';

  @override
  String get cycleCurrentPhase => 'Aktuelle Phase';

  @override
  String get cycleNextPeriod => 'Nächste Periode';

  @override
  String cycleDaysLeft(int days) {
    return '$days Tage verbleibend';
  }

  @override
  String get healthTitle => 'Gesundheitseinblicke';

  @override
  String get healthSymptoms => 'Symptome';

  @override
  String get healthMood => 'Stimmung';

  @override
  String get healthEnergy => 'Energielevel';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profilePersonalInfo => 'Persönliche Informationen';

  @override
  String get profileCycleHistory => 'Zyklusverlauf';

  @override
  String get profileDataExport => 'Daten exportieren';

  @override
  String get helpTitle => 'Hilfe & Support';

  @override
  String get helpFaq => 'Häufig gestellte Fragen';

  @override
  String get helpContactSupport => 'Support kontaktieren';

  @override
  String get helpUserGuide => 'Benutzerhandbuch';

  @override
  String get helpPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get helpReportIssue => 'Problem melden';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonError => 'Fehler';

  @override
  String get commonSuccess => 'Erfolgreich';

  @override
  String get commonLoading => 'Wird geladen...';

  @override
  String get todayTitle => 'Heute';

  @override
  String get yesterdayTitle => 'Gestern';

  @override
  String get tomorrowTitle => 'Morgen';

  @override
  String get phaseFollicular => 'Follikelphase';

  @override
  String get phaseOvulation => 'Eisprung';

  @override
  String get phaseLuteal => 'Lutealphase';

  @override
  String get phaseMenstruation => 'Menstruation';

  @override
  String get symptomCramps => 'Krämpfe';

  @override
  String get symptomHeadache => 'Kopfschmerzen';

  @override
  String get symptomBackache => 'Rückenschmerzen';

  @override
  String get symptomBloating => 'Blähungen';

  @override
  String get symptomFatigue => 'Müdigkeit';

  @override
  String get moodHappy => 'Glücklich';

  @override
  String get moodSad => 'Traurig';

  @override
  String get moodAnxious => 'Ängstlich';

  @override
  String get moodIrritated => 'Gereizt';

  @override
  String get moodCalm => 'Ruhig';

  @override
  String get energyHigh => 'Hohe Energie';

  @override
  String get energyMedium => 'Mittlere Energie';

  @override
  String get energyLow => 'Niedrige Energie';

  @override
  String get notificationTitle => 'CycleSync Benachrichtigung';

  @override
  String get notificationPeriodReminder => 'Ihre Periode sollte bald beginnen';

  @override
  String get notificationOvulationReminder => 'Sie nähern sich Ihrem fruchtbaren Fenster';

  @override
  String get accessibilityMenuButton => 'Menü-Schaltfläche';

  @override
  String get accessibilityCalendar => 'Kalenderansicht';

  @override
  String get accessibilitySettingsButton => 'Einstellungen-Schaltfläche';

  @override
  String get homeTitle => 'CycleSync';

  @override
  String homeWelcomeMessage(String name) {
    return 'Hallo, $name!';
  }

  @override
  String get homeWelcomeSubtitle => 'Verfolgen Sie Ihren Zyklus mit Vertrauen';

  @override
  String get homeMenstrualPhase => 'Menstruationsphase';

  @override
  String homeCycleDayInfo(int day) {
    return 'Tag $day Ihres Zyklus';
  }

  @override
  String get homeUpcomingEvents => 'Bevorstehende Ereignisse';

  @override
  String get homeNextPeriod => 'Nächste Periode';

  @override
  String get homeOvulation => 'Eisprung';

  @override
  String get homeFertileWindow => 'Fruchtbares Fenster';

  @override
  String get homeQuickActions => 'Schnelle Aktionen';

  @override
  String get homeLogCycle => 'Zyklus protokollieren';

  @override
  String get homeViewHistory => 'Verlauf anzeigen';

  @override
  String get homeCalendar => 'Kalender';

  @override
  String get homeAnalytics => 'Analysen';

  @override
  String get homeAIInsights => 'KI-Einblicke';

  @override
  String get homeDailyLog => 'Tägliches Protokoll';

  @override
  String get homeTomorrow => 'Morgen';

  @override
  String homeDaysAgo(int days) {
    return 'Vor $days Tagen';
  }

  @override
  String get appearanceTitle => 'Erscheinungsbild';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get lightModeDescription => 'Helles Design verwenden';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get darkModeDescription => 'Dunkles Design verwenden';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get systemDefaultDescription => 'Systemeinstellungen folgen';

  @override
  String get languageTitle => 'Sprache';

  @override
  String get languageSubtitle => 'Deutsch • 36 Sprachen verfügbar';

  @override
  String get swahiliLanguage => 'Kiswahili';

  @override
  String get toolsTitle => 'Werkzeuge';

  @override
  String get notificationsManage => 'Zyklus-Erinnerungen und Warnungen verwalten';

  @override
  String get smartNotifications => 'Intelligente Benachrichtigungen';

  @override
  String get smartNotificationsDescription => 'KI-gestützte Einblicke und Vorhersagen';

  @override
  String get diagnosticsTitle => 'Diagnose';

  @override
  String get diagnosticsDescription => 'Firebase-Verbindung testen';

  @override
  String get userTitle => 'Benutzer';

  @override
  String get homeHealthInsights => 'Gesundheits-Einblicke';

  @override
  String get homeSymptomTrends => 'Symptom-Trends';

  @override
  String get homeAIHealthCoach => 'KI-Gesundheitscoach';

  @override
  String homeInDays(int days) {
    return 'In $days Tagen';
  }

  @override
  String get homeToday => 'Heute';

  @override
  String get homeYesterday => 'Gestern';

  @override
  String get homeRecentCycles => 'Aktuelle Zyklen';

  @override
  String get homeViewAll => 'Alle anzeigen';

  @override
  String get homeStartTracking => 'Beginnen Sie mit der Verfolgung Ihres Zyklus';

  @override
  String get homeStartTrackingDescription => 'Protokollieren Sie Ihren ersten Zyklus, um personalisierte Einblicke und Vorhersagen zu sehen.';

  @override
  String get homeLogFirstCycle => 'Ersten Zyklus protokollieren';

  @override
  String get homeUnableToLoad => 'Aktuelle Zyklen können nicht geladen werden';

  @override
  String get homeTryAgain => 'Erneut versuchen';

  @override
  String get homeNoCycles => 'Noch keine Zyklen protokolliert. Beginnen Sie mit der Verfolgung!';

  @override
  String get dailyLogTitle => 'Tägliches Protokoll';

  @override
  String get logToday => 'Heute protokollieren';

  @override
  String get history => 'Verlauf';

  @override
  String get selectedDate => 'Ausgewähltes Datum';

  @override
  String get quickLogTemplates => 'Schnelle Protokoll-Vorlagen';

  @override
  String get greatDay => 'Großartiger Tag';

  @override
  String get goodDay => 'Guter Tag';

  @override
  String get okayDay => 'Normaler Tag';

  @override
  String get toughDay => 'Schwieriger Tag';

  @override
  String get periodDay => 'Menstruationstag';

  @override
  String get pms => 'PMS';

  @override
  String get mood => 'Stimmung';

  @override
  String get energy => 'Energie';

  @override
  String get painLevel => 'Schmerzniveau';

  @override
  String get notesOptional => 'Notizen (optional)';

  @override
  String get saveDailyLog => 'Tägliches Protokoll speichern';

  @override
  String get loggingFor => 'Protokollieren für';

  @override
  String get change => 'Ändern';

  @override
  String get moodLevel => 'Stimmungsniveau';

  @override
  String get energyLevel => 'Energieniveau';

  @override
  String get stressLevel => 'Stressniveau';

  @override
  String get sleepQuality => 'Schlafqualität';

  @override
  String get waterIntake => 'Wasseraufnahme';

  @override
  String get exercise => 'Sport';

  @override
  String get symptomsToday => 'Heutige Symptome';

  @override
  String get dailyNotes => 'Tägliche Notizen';

  @override
  String get wellbeing => 'Wohlbefinden';

  @override
  String get lifestyle => 'Lebensstil';

  @override
  String get symptoms => 'Symptome';

  @override
  String get aiInsights => 'KI-Einblicke';

  @override
  String get aiPredictions => 'KI-Vorhersagen';

  @override
  String get personalInsights => 'Persönliche Einblicke';

  @override
  String get nextPeriod => 'Nächste Periode';

  @override
  String get ovulation => 'Eisprung';

  @override
  String get cycleRegularity => 'Zyklusregelmäßigkeit';

  @override
  String get confidence => 'Vertrauen';

  @override
  String get glasses => 'Gläser';

  @override
  String get minutes => 'Minuten';

  @override
  String get dailyGoalAchieved => '🎉 Tagesziel erreicht!';

  @override
  String minToReachDailyGoal(int minutes) {
    return '$minutes min bis zum Tagesziel';
  }

  @override
  String get tapSymptomsExperienced => 'Tippen Sie auf alle Symptome, die Sie heute erlebt haben:';

  @override
  String symptomSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Symptome ausgewählt',
      one: '1 Symptom ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get howFeelingToday => 'Wie fühlen Sie sich heute? Irgendwelche Gedanken oder Beobachtungen?';

  @override
  String get feelingGreatToday => 'z.B., Fühle mich heute großartig, hatte ein gutes Training...';

  @override
  String get generatingAIInsights => 'KI-Einblicke werden generiert...';

  @override
  String get noInsightsYet => 'Noch keine Einblicke';

  @override
  String get keepTrackingForInsights => 'Führen Sie weiter Ihre täglichen Daten, um personalisierte KI-Einblicke zu erhalten!';

  @override
  String get smartDailyLog => 'Intelligentes Tagesprotokoll';

  @override
  String get save => 'Speichern';

  @override
  String get saving => 'Wird gespeichert...';

  @override
  String dailyLogSavedFor(String date) {
    return 'Tägliches Protokoll gespeichert für $date';
  }

  @override
  String errorSavingDailyLog(String error) {
    return 'Fehler beim Speichern des Tagesprotokolls: $error';
  }

  @override
  String get retry => 'Wiederholen';

  @override
  String get veryLow => 'Sehr niedrig';

  @override
  String get low => 'Niedrig';

  @override
  String get neutral => 'Neutral';

  @override
  String get good => 'Gut';

  @override
  String get excellent => 'Ausgezeichnet';

  @override
  String get exhausted => 'Erschöpft';

  @override
  String get normal => 'Normal';

  @override
  String get high => 'Hoch';

  @override
  String get energetic => 'Energisch';

  @override
  String get none => 'Keine';

  @override
  String get mild => 'Mild';

  @override
  String get moderate => 'Moderat';

  @override
  String get severe => 'Schwer';

  @override
  String get extreme => 'Extrem';

  @override
  String get veryCalm => 'Sehr ruhig';

  @override
  String get relaxed => 'Entspannt';

  @override
  String get stressed => 'Gestresst';

  @override
  String get veryStressed => 'Sehr gestresst';

  @override
  String get poor => 'Schlecht';

  @override
  String get fair => 'Mittelmäßig';

  @override
  String get veryGood => 'Sehr gut';

  @override
  String get cramps => 'Krämpfe';

  @override
  String get headache => 'Kopfschmerzen';

  @override
  String get moodSwings => 'Stimmungsschwankungen';

  @override
  String get fatigue => 'Müdigkeit';

  @override
  String get bloating => 'Blähungen';

  @override
  String get breastTenderness => 'Brustschmerzen';

  @override
  String get nausea => 'Übelkeit';

  @override
  String get backPain => 'Rückenschmerzen';

  @override
  String get acne => 'Akne';

  @override
  String get foodCravings => 'Heißhunger';

  @override
  String get sleepIssues => 'Schlafprobleme';

  @override
  String get hotFlashes => 'Hitzewallungen';

  @override
  String get noDailyLogsYet => 'Noch keine täglichen Protokolle';

  @override
  String get startLoggingDailyMood => 'Beginnen Sie mit der Protokollierung Ihrer täglichen Stimmung und Energie';

  @override
  String failedToLoadLogs(String error) {
    return 'Fehler beim Laden der Protokolle: $error';
  }

  @override
  String get notes => 'Notizen';

  @override
  String get more => 'mehr';

  @override
  String get dailyLogSaved => 'Tägliches Protokoll gespeichert!';

  @override
  String failedToSaveLog(String error) {
    return 'Fehler beim Speichern des Protokolls: $error';
  }

  @override
  String failedToLoadExistingLog(String error) {
    return 'Fehler beim Laden des vorhandenen Protokolls: $error';
  }

  @override
  String get howAreYouFeelingToday => 'Wie fühlen Sie sich heute?';

  @override
  String get updated => 'Aktualisiert';

  @override
  String get okay => 'Okay';

  @override
  String get tools => 'Werkzeuge';

  @override
  String get dataManagement => 'Datenmanagement';

  @override
  String get account => 'Konto';

  @override
  String get verified => 'Verifiziert';

  @override
  String get healthIntegration => 'Gesundheitsintegration';

  @override
  String get healthIntegrationDescription => 'Mit HealthKit und Google Fit synchronisieren';

  @override
  String get dataManagementDescription => 'Daten exportieren, importieren und sichern';

  @override
  String get exportBackup => 'Export & Backup';

  @override
  String get exportBackupDescription => 'Berichte erstellen und Daten sichern';

  @override
  String get socialSharing => 'Soziales Teilen';

  @override
  String get socialSharingDescription => 'Daten mit Anbietern und Partnern teilen';

  @override
  String get syncStatus => 'Synchronisierungsstatus';

  @override
  String get syncStatusDescription => 'Cloud-Synchronisation prüfen';

  @override
  String get about => 'Über';

  @override
  String get aboutDescription => 'App-Version und Credits';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signOutDescription => 'Von Ihrem Konto abmelden';

  @override
  String get getHelpUsingFlowSense => 'Get help using FlowSense';

  @override
  String get viewSymptomPatterns => 'Symptommuster und Einblicke anzeigen';

  @override
  String get viewAllCycles => 'Alle Zyklen anzeigen';

  @override
  String get viewCycleInsights => 'Zyklus-Einblicke anzeigen';

  @override
  String get testFirebaseConnection => 'Firebase-Verbindung testen';

  @override
  String get comingSoon => 'Demnächst verfügbar';

  @override
  String featureAvailableInFuture(String feature) {
    return '$feature wird in einem zukünftigen Update verfügbar sein.';
  }

  @override
  String get ok => 'OK';

  @override
  String get aboutFlowSense => 'About FlowSense';

  @override
  String get flowSenseVersion => 'FlowSense v1.0.0';

  @override
  String get modernCycleTrackingApp => 'Eine moderne Zyklus-Tracking-App, entwickelt mit Flutter.';

  @override
  String get features => 'Funktionen:';

  @override
  String get cycleLoggingTracking => '• Zyklusprotokollierung und -verfolgung';

  @override
  String get analyticsInsights => '• Analysen und Einblicke';

  @override
  String get darkModeSupport => '• Dunkler Modus-Unterstützung';

  @override
  String get cloudSynchronization => '• Cloud-Synchronisation';

  @override
  String get privacyFocusedDesign => '• Datenschutzorientiertes Design';

  @override
  String get areYouSureSignOut => 'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get firebaseAuthentication => 'Firebase-Authentifizierung';

  @override
  String get connected => 'Verbunden';

  @override
  String get cloudFirestore => 'Cloud Firestore';

  @override
  String syncedMinutesAgo(int minutes) {
    return 'Vor $minutes Minuten synchronisiert';
  }

  @override
  String get healthData => 'Gesundheitsdaten';

  @override
  String get pendingSync => 'Synchronisation ausstehend';

  @override
  String get analyticsData => 'Analysedaten';

  @override
  String get upToDate => 'Aktuell';

  @override
  String get totalSyncedRecords => 'Insgesamt synchronisierte Datensätze:';

  @override
  String get lastFullSync => 'Letzte vollständige Synchronisation:';

  @override
  String todayAt(String time) {
    return 'Heute um $time';
  }

  @override
  String get storageUsed => 'Genutzter Speicher:';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get manualSyncCompleted => 'Manuelle Synchronisation erfolgreich abgeschlossen!';

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
