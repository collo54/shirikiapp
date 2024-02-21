import 'package:shiriki/models/polyline_model.dart';

class ProjectModel {
  ProjectModel({
    required this.mainPipesPolylines,
    required this.proposedPipesPolylines,
    required this.projectId,
    required this.projectName,
    required this.costEstimate,
    required this.description,
    required this.timeStamp,
    required this.userId,
  });

  final String projectId;
  final String projectName;
  final double costEstimate;
  final String description;
  final String timeStamp;
  final String userId;
  final List<PolylineModel> mainPipesPolylines;
  final List<PolylineModel> proposedPipesPolylines;

  factory ProjectModel.fromJson(Map<String, dynamic> data, String id) {
    // final projectId = data['projectId'] as String?;
    // final projectIdData = projectId ?? '';
    final projectName = data['projectName'] as String?;
    final projectNameData = projectName ?? '';
    final description = data['description'] as String?;
    final descriptionData = description ?? '';
    final userid = data['userId'] as String?;
    final userIdData = userid ?? '';
    final time = data['timeStamp'] as String?;
    final timeData = time ?? '';
    final cost = data['costEstimate'] as double?;
    final costData = cost ?? 0.0;
    final mainPipesData = data['mainPipesPolylines'] as List<dynamic>?;
    final mainPolylines = mainPipesData != null
        ? mainPipesData
            .map((polyine) => PolylineModel.fromJson(polyine))
            .toList()
        : <PolylineModel>[];

    final proposedPipesData = data['proposedPipesPolylines'] as List<dynamic>?;
    final proposedPolylines = proposedPipesData != null
        ? proposedPipesData
            .map((polyine) => PolylineModel.fromJson(polyine))
            .toList()
        : <PolylineModel>[];

    return ProjectModel(
      projectId: id,
      projectName: projectNameData,
      description: descriptionData,
      userId: userIdData,
      timeStamp: timeData,
      costEstimate: costData,
      mainPipesPolylines: mainPolylines,
      proposedPipesPolylines: proposedPolylines,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'costEstimate': costEstimate,
      'description': description,
      'timeStamp': timeStamp,
      'userId': userId,
      'mainPipesPolylines':
          mainPipesPolylines.map((polyline) => polyline.toMap()).toList(),
      'proposedPipesPolylines':
          proposedPipesPolylines.map((polyline) => polyline.toMap()).toList(),
    };
  }
}
