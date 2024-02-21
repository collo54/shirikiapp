class LatLangModel {
  LatLangModel({
    required this.lat,
    required this.lang,
  });

  final double lat;
  final double lang;

  Map<String, dynamic> toMap() {
    return {
      'latitude': lat,
      'longitude': lang,
    };
  }

  factory LatLangModel.fromJson(Map<String, dynamic> data) {
    final latData = data['latitude'] as double?;
    final lat = latData ?? 0.0;
    final langData = data['longitude'] as double?;
    final lang = langData ?? 0.0;

    return LatLangModel(
      lat: lat,
      lang: lang,
    );
  }
}
