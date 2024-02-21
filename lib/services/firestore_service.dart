import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shiriki/models/project_model.dart';

import 'document_path.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreService {
  FirestoreService({required this.uid});
  final String uid;

  // generic funtion creates a dcomcument and sets data in the document
  Future<void> _set({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    final DocumentReference<Map<String, dynamic>?> reference =
        FirebaseFirestore.instance.doc(path);
    debugPrint('$path: $data');
    await reference.set(data);
  }

  //creates or writes a project for all projects collection
  Future<void> setProjectAll(ProjectModel projectModel) async {
    await _set(
        path: DocumentPath.newAllProjects(projectModel.projectId),
        data: projectModel.toMap());
  }

  //reads a project from all projects collection
  Stream<List<ProjectModel>> projectItemStreamAll() {
    final path = DocumentPath.streamAllProjects();
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((
          snapshot,
        ) =>
            ProjectModel.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  //deletes a doc from all projects collection
  Future<void> deleteAllProjects(ProjectModel projectModel) async {
    final path = DocumentPath.newAllProjects(projectModel.projectId);
    final reference = FirebaseFirestore.instance.doc(path);

    debugPrint('delete: $path');

    await reference.delete();
  }

  //creates or writes a project for user projects collection per user id
  Future<void> setUserProjects(ProjectModel projectModel) async {
    await _set(
        path: DocumentPath.userProject(uid, projectModel.projectId),
        data: projectModel.toMap());
  }

  //reads a project from user project collection per user id
  Stream<List<ProjectModel>> userProjectsStream() {
    final path = DocumentPath.streamUserProjects(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((
          snapshot,
        ) =>
            ProjectModel.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  //deletes a doc from user projects collection/uid/docid
  Future<void> deleteUserProject(ProjectModel projectModel) async {
    final path = DocumentPath.userProject(uid, projectModel.projectId);
    final reference = FirebaseFirestore.instance.doc(path);

    debugPrint('delete: $path');

    await reference.delete();
  }
}
