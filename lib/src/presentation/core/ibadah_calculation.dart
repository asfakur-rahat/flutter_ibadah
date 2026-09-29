/// The prayer-time calculation method, i.e. whose convention to follow for the
/// solar angles that define Fajr and Isha.
///
/// Different authorities use different angles, so the same city can legitimately
/// have several "correct" timetables. Pick the one your users' local mosques
/// follow. [karachi] is the package default, since it is the convention used in
/// Bangladesh and the rest of South Asia.
///
/// Values mirror the `method` parameter of the AlAdhan API.
enum IbadahCalculationMethod {
  /// Shia Ithna-Ashari, Leva Institute, Qum.
  jafari(0),

  /// University of Islamic Sciences, Karachi. Common across South Asia.
  karachi(1),

  /// Islamic Society of North America (ISNA).
  isna(2),

  /// Muslim World League. A reasonable default for Europe and elsewhere.
  muslimWorldLeague(3),

  /// Umm Al-Qura University, Makkah. Used in Saudi Arabia.
  ummAlQura(4),

  /// Egyptian General Authority of Survey.
  egypt(5),

  /// Institute of Geophysics, University of Tehran.
  tehran(7),

  /// Gulf Region.
  gulf(8),

  /// Kuwait.
  kuwait(9),

  /// Qatar.
  qatar(10),

  /// Majlis Ugama Islam Singapura, Singapore.
  singapore(11),

  /// Union Organization Islamic de France.
  france(12),

  /// Diyanet İşleri Başkanlığı, Turkey (experimental).
  turkey(13),

  /// Spiritual Administration of Muslims of Russia.
  russia(14),

  /// Moonsighting Committee Worldwide.
  moonsighting(15),

  /// Dubai (experimental).
  dubai(16),

  /// Jabatan Kemajuan Islam Malaysia (JAKIM).
  malaysia(17),

  /// Tunisia.
  tunisia(18),

  /// Algeria.
  algeria(19),

  /// Kementerian Agama Republik Indonesia.
  indonesia(20),

  /// Morocco.
  morocco(21),

  /// Comunidade Islamica de Lisboa, Portugal.
  portugal(22),

  /// Ministry of Awqaf, Islamic Affairs and Holy Places, Jordan.
  jordan(23);

  /// The `method` id understood by the API.
  final int id;

  const IbadahCalculationMethod(this.id);
}

/// The juristic school used for the Asr calculation.
///
/// [hanafi] puts Asr noticeably later than [shafi]. The package defaults to
/// [hanafi], which is the prevailing school in Bangladesh and South Asia.
///
/// Values mirror the `school` parameter of the AlAdhan API.
enum IbadahSchool {
  /// Shafi'i, Maliki and Hanbali — the API calls this "standard".
  shafi(0),

  /// Hanafi.
  hanafi(1);

  /// The `school` id understood by the API.
  final int id;

  const IbadahSchool(this.id);
}
