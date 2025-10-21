import 'package:cloud_firestore/cloud_firestore.dart';

/// Health diagnosis and condition screening model
class HealthDiagnosis {
  final String id;
  final String userId;
  final DiagnosisType type;
  final String conditionName;
  final double riskScore;
  final List<String> symptoms;
  final List<String> riskFactors;
  final String assessment;
  final String recommendation;
  final DiagnosisSeverity severity;
  final bool requiresProfessionalConsultation;
  final DateTime createdAt;
  final DateTime? followUpDate;
  final Map<String, dynamic> diagnosticData;

  const HealthDiagnosis({
    required this.id,
    required this.userId,
    required this.type,
    required this.conditionName,
    required this.riskScore,
    required this.symptoms,
    required this.riskFactors,
    required this.assessment,
    required this.recommendation,
    required this.severity,
    required this.requiresProfessionalConsultation,
    required this.createdAt,
    this.followUpDate,
    required this.diagnosticData,
  });

  factory HealthDiagnosis.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HealthDiagnosis(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: DiagnosisType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => DiagnosisType.screening,
      ),
      conditionName: data['conditionName'] ?? '',
      riskScore: data['riskScore']?.toDouble() ?? 0.0,
      symptoms: List<String>.from(data['symptoms'] ?? []),
      riskFactors: List<String>.from(data['riskFactors'] ?? []),
      assessment: data['assessment'] ?? '',
      recommendation: data['recommendation'] ?? '',
      severity: DiagnosisSeverity.values.firstWhere(
        (e) => e.toString().split('.').last == data['severity'],
        orElse: () => DiagnosisSeverity.low,
      ),
      requiresProfessionalConsultation: data['requiresProfessionalConsultation'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      followUpDate: data['followUpDate'] != null
          ? (data['followUpDate'] as Timestamp).toDate()
          : null,
      diagnosticData: Map<String, dynamic>.from(data['diagnosticData'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type.toString().split('.').last,
      'conditionName': conditionName,
      'riskScore': riskScore,
      'symptoms': symptoms,
      'riskFactors': riskFactors,
      'assessment': assessment,
      'recommendation': recommendation,
      'severity': severity.toString().split('.').last,
      'requiresProfessionalConsultation': requiresProfessionalConsultation,
      'createdAt': Timestamp.fromDate(createdAt),
      'followUpDate': followUpDate != null ? Timestamp.fromDate(followUpDate!) : null,
      'diagnosticData': diagnosticData,
    };
  }

  HealthDiagnosis copyWith({
    String? id,
    String? userId,
    DiagnosisType? type,
    String? conditionName,
    double? riskScore,
    List<String>? symptoms,
    List<String>? riskFactors,
    String? assessment,
    String? recommendation,
    DiagnosisSeverity? severity,
    bool? requiresProfessionalConsultation,
    DateTime? createdAt,
    DateTime? followUpDate,
    Map<String, dynamic>? diagnosticData,
  }) {
    return HealthDiagnosis(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      conditionName: conditionName ?? this.conditionName,
      riskScore: riskScore ?? this.riskScore,
      symptoms: symptoms ?? this.symptoms,
      riskFactors: riskFactors ?? this.riskFactors,
      assessment: assessment ?? this.assessment,
      recommendation: recommendation ?? this.recommendation,
      severity: severity ?? this.severity,
      requiresProfessionalConsultation: requiresProfessionalConsultation ?? this.requiresProfessionalConsultation,
      createdAt: createdAt ?? this.createdAt,
      followUpDate: followUpDate ?? this.followUpDate,
      diagnosticData: diagnosticData ?? this.diagnosticData,
    );
  }

  bool get isHighRisk => riskScore >= 0.7;
  bool get isMediumRisk => riskScore >= 0.4 && riskScore < 0.7;
  bool get isLowRisk => riskScore < 0.4;

  @override
  String toString() {
    return 'HealthDiagnosis(condition: $conditionName, risk: $riskScore, severity: $severity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthDiagnosis && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum DiagnosisType {
  screening,
  assessment,
  followUp,
  monitoring,
}

enum DiagnosisSeverity {
  low,
  mild,
  moderate,
  high,
  critical,
}

extension DiagnosisTypeExtension on DiagnosisType {
  String get displayName {
    switch (this) {
      case DiagnosisType.screening:
        return 'Health Screening';
      case DiagnosisType.assessment:
        return 'Health Assessment';
      case DiagnosisType.followUp:
        return 'Follow-up';
      case DiagnosisType.monitoring:
        return 'Ongoing Monitoring';
    }
  }

  String get icon {
    switch (this) {
      case DiagnosisType.screening:
        return '🔍';
      case DiagnosisType.assessment:
        return '📋';
      case DiagnosisType.followUp:
        return '📅';
      case DiagnosisType.monitoring:
        return '📊';
    }
  }
}

extension DiagnosisSeverityExtension on DiagnosisSeverity {
  String get displayName {
    switch (this) {
      case DiagnosisSeverity.low:
        return 'Low';
      case DiagnosisSeverity.mild:
        return 'Mild';
      case DiagnosisSeverity.moderate:
        return 'Moderate';
      case DiagnosisSeverity.high:
        return 'High';
      case DiagnosisSeverity.critical:
        return 'Critical';
    }
  }

  String get color {
    switch (this) {
      case DiagnosisSeverity.low:
        return 'green';
      case DiagnosisSeverity.mild:
        return 'lightgreen';
      case DiagnosisSeverity.moderate:
        return 'orange';
      case DiagnosisSeverity.high:
        return 'red';
      case DiagnosisSeverity.critical:
        return 'darkred';
    }
  }
}

/// Menstrual health conditions that can be screened
enum MenstrualCondition {
  pcos,
  endometriosis,
  fibroids,
  pms,
  pmdd,
  menorrhagia,
  amenorrhea,
  dysmenorrhea,
  ovarian_cysts,
  thyroid_disorder,
}

extension MenstrualConditionExtension on MenstrualCondition {
  String get displayName {
    switch (this) {
      case MenstrualCondition.pcos:
        return 'PCOS (Polycystic Ovary Syndrome)';
      case MenstrualCondition.endometriosis:
        return 'Endometriosis';
      case MenstrualCondition.fibroids:
        return 'Uterine Fibroids';
      case MenstrualCondition.pms:
        return 'PMS (Premenstrual Syndrome)';
      case MenstrualCondition.pmdd:
        return 'PMDD (Premenstrual Dysphoric Disorder)';
      case MenstrualCondition.menorrhagia:
        return 'Menorrhagia (Heavy Periods)';
      case MenstrualCondition.amenorrhea:
        return 'Amenorrhea (Absent Periods)';
      case MenstrualCondition.dysmenorrhea:
        return 'Dysmenorrhea (Painful Periods)';
      case MenstrualCondition.ovarian_cysts:
        return 'Ovarian Cysts';
      case MenstrualCondition.thyroid_disorder:
        return 'Thyroid-Related Menstrual Issues';
    }
  }

  String get description {
    switch (this) {
      case MenstrualCondition.pcos:
        return 'A hormonal disorder causing enlarged ovaries with small cysts';
      case MenstrualCondition.endometriosis:
        return 'Tissue similar to uterine lining grows outside the uterus';
      case MenstrualCondition.fibroids:
        return 'Non-cancerous growths in or around the uterus';
      case MenstrualCondition.pms:
        return 'Physical and emotional symptoms before menstruation';
      case MenstrualCondition.pmdd:
        return 'Severe form of PMS that significantly impacts daily life';
      case MenstrualCondition.menorrhagia:
        return 'Abnormally heavy or prolonged menstrual periods';
      case MenstrualCondition.amenorrhea:
        return 'Absence of menstrual periods when they should occur';
      case MenstrualCondition.dysmenorrhea:
        return 'Painful menstrual periods with severe cramping';
      case MenstrualCondition.ovarian_cysts:
        return 'Fluid-filled sacs that form on or inside the ovaries';
      case MenstrualCondition.thyroid_disorder:
        return 'Thyroid imbalances affecting menstrual regularity';
    }
  }

  List<String> get commonSymptoms {
    switch (this) {
      case MenstrualCondition.pcos:
        return [
          'Irregular periods',
          'Heavy bleeding',
          'Acne',
          'Weight gain',
          'Hair growth on face/body',
          'Hair loss on scalp',
          'Dark skin patches'
        ];
      case MenstrualCondition.endometriosis:
        return [
          'Severe pelvic pain',
          'Pain during intercourse',
          'Heavy periods',
          'Pain during bowel movements',
          'Fatigue',
          'Infertility',
          'Nausea'
        ];
      case MenstrualCondition.fibroids:
        return [
          'Heavy menstrual bleeding',
          'Prolonged periods',
          'Pelvic pressure',
          'Frequent urination',
          'Constipation',
          'Back pain',
          'Leg pain'
        ];
      case MenstrualCondition.pms:
        return [
          'Mood swings',
          'Breast tenderness',
          'Bloating',
          'Food cravings',
          'Fatigue',
          'Irritability',
          'Depression'
        ];
      case MenstrualCondition.pmdd:
        return [
          'Severe mood swings',
          'Severe depression',
          'Anxiety',
          'Anger outbursts',
          'Difficulty concentrating',
          'Sleep disturbances',
          'Physical symptoms'
        ];
      case MenstrualCondition.menorrhagia:
        return [
          'Soaking pad/tampon every hour',
          'Bleeding for more than 7 days',
          'Blood clots larger than quarter',
          'Fatigue',
          'Shortness of breath',
          'Anemia symptoms'
        ];
      case MenstrualCondition.amenorrhea:
        return [
          'No periods for 3+ months',
          'Hair loss',
          'Headaches',
          'Vision changes',
          'Excess facial hair',
          'Pelvic pain',
          'Acne'
        ];
      case MenstrualCondition.dysmenorrhea:
        return [
          'Severe menstrual cramps',
          'Lower back pain',
          'Thigh pain',
          'Nausea',
          'Vomiting',
          'Diarrhea',
          'Headaches'
        ];
      case MenstrualCondition.ovarian_cysts:
        return [
          'Pelvic pain',
          'Bloating',
          'Painful periods',
          'Pain during intercourse',
          'Nausea',
          'Breast tenderness'
        ];
      case MenstrualCondition.thyroid_disorder:
        return [
          'Irregular periods',
          'Very light or heavy periods',
          'Fatigue',
          'Weight changes',
          'Hair changes',
          'Temperature sensitivity',
          'Mood changes'
        ];
    }
  }

  List<String> get riskFactors {
    switch (this) {
      case MenstrualCondition.pcos:
        return [
          'Family history of PCOS',
          'Insulin resistance',
          'Obesity',
          'Type 2 diabetes',
          'High androgen levels'
        ];
      case MenstrualCondition.endometriosis:
        return [
          'Family history',
          'Never giving birth',
          'Starting periods early',
          'Short menstrual cycles',
          'Heavy periods',
          'Low BMI'
        ];
      case MenstrualCondition.fibroids:
        return [
          'Age 30-40',
          'African American ethnicity',
          'Family history',
          'Obesity',
          'Early onset of menstruation',
          'Never having children'
        ];
      case MenstrualCondition.pms:
        return [
          'High stress levels',
          'Family history',
          'Depression history',
          'Poor diet',
          'Lack of exercise',
          'Smoking'
        ];
      case MenstrualCondition.pmdd:
        return [
          'History of depression',
          'Family history of mood disorders',
          'History of trauma',
          'High stress levels',
          'Substance abuse history'
        ];
      default:
        return ['Family history', 'Age factors', 'Lifestyle factors', 'Hormonal factors'];
    }
  }
}
