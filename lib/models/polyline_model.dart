import 'package:shiriki/models/location.dart';

class PolylineModel {
  PolylineModel({
    required this.polylineId,
    required this.startlocation,
    required this.stoplocation,
  });

  final String polylineId;
  final LocationModel startlocation;
  final LocationModel stoplocation;

  Map<String, dynamic> toMap() {
    return {
      'polylineId': polylineId,
      'startLocation': startlocation.toMap(),
      'stopLocation': stoplocation.toMap(),
    };
  }

  factory PolylineModel.fromJson(Map<String, dynamic> data) {
    final polylineId = data['polylineId'] as String?;
    final polylineData = polylineId ?? '';
    final startlocation = data['startLocation'] as Map<String, dynamic>?;
    final startlocationData = LocationModel.fromJson(startlocation!);
    final stoplocation = data['stopLocation'] as Map<String, dynamic>?;
    final stoplocationData = LocationModel.fromJson(stoplocation!);

    return PolylineModel(
      polylineId: polylineData,
      startlocation: startlocationData,
      stoplocation: stoplocationData,
    );
  }
}
