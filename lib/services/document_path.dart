class DocumentPath {
  static String userProject(String uid, String projectId) =>
      'Users/$uid/projects/$projectId';
  static String streamUserProjects(String uid) => 'Users/$uid/projects/';

  static String newAllProjects(String projectDocId) =>
      'All Projects/$projectDocId';
  static String streamAllProjects() => 'All Projects/';
}
