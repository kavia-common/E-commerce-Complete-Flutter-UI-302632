class Preferences {
  const Preferences({
    required this.analyticsEnabled,
    required this.personalizationEnabled,
    required this.marketingEnabled,
    required this.socialMediaEnabled,
    required this.updatedAt,
  });

  final bool analyticsEnabled;
  final bool personalizationEnabled;
  final bool marketingEnabled;
  final bool socialMediaEnabled;
  final DateTime updatedAt;

  static Preferences defaults() => Preferences(
        analyticsEnabled: true,
        personalizationEnabled: false,
        marketingEnabled: false,
        socialMediaEnabled: false,
        updatedAt: DateTime.now(),
      );

  Preferences copyWith({
    bool? analyticsEnabled,
    bool? personalizationEnabled,
    bool? marketingEnabled,
    bool? socialMediaEnabled,
    DateTime? updatedAt,
  }) {
    return Preferences(
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      personalizationEnabled:
          personalizationEnabled ?? this.personalizationEnabled,
      marketingEnabled: marketingEnabled ?? this.marketingEnabled,
      socialMediaEnabled: socialMediaEnabled ?? this.socialMediaEnabled,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Preferences.fromJson(Map<String, Object?> json) {
    // Migration-friendly: missing keys fall back to defaults.
    final Preferences d = Preferences.defaults();
    return Preferences(
      analyticsEnabled: (json['analyticsEnabled'] as bool?) ?? d.analyticsEnabled,
      personalizationEnabled:
          (json['personalizationEnabled'] as bool?) ?? d.personalizationEnabled,
      marketingEnabled: (json['marketingEnabled'] as bool?) ?? d.marketingEnabled,
      socialMediaEnabled:
          (json['socialMediaEnabled'] as bool?) ?? d.socialMediaEnabled,
      updatedAt: DateTime.tryParse((json['updatedAt'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'schemaVersion': 1,
      'analyticsEnabled': analyticsEnabled,
      'personalizationEnabled': personalizationEnabled,
      'marketingEnabled': marketingEnabled,
      'socialMediaEnabled': socialMediaEnabled,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
