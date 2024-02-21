import 'latlng_model.dart';

class LocationModel {
  LocationModel({
    required this.latLangModel,
  });

  final LatLangModel latLangModel;

  Map<String, dynamic> toMap() {
    return {
      'latLng': latLangModel.toMap(),
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> data) {
    final latLangModel = data['latLng'] as Map<String, dynamic>?;
    final latLangModelData = LatLangModel.fromJson(latLangModel!);

    return LocationModel(
      latLangModel: latLangModelData,
    );
  }
}
