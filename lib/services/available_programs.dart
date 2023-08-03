const _prefix = "https://firebasestorage.googleapis.com/v0"
    "/b/excel-academy-online.appspot.com"
    "/o/assets%2Fpages%2Fhomepage%2Fprograms%2F"
    "{icon}?alt=media";

String _getURL(String icon) {
  return _prefix.replaceFirst("{icon}", icon);
}

class CourseProgramItemData {
  final int color;
  final String initial;
  final String fullName;
  final String assetUrl;
  final int numOfLevels;
  final int numOfCourses;

  const CourseProgramItemData({
    required this.color,
    required this.initial,
    required this.fullName,
    required this.assetUrl,
    required this.numOfLevels,
    required this.numOfCourses,
  });
}

class ProgramsService {
  Future<List<CourseProgramItemData>> getAllPrograms() async {
    return Future.delayed(
      const Duration(seconds: 5),
      () => _sampleCoursePrograms,
    );
  }
}

final List<CourseProgramItemData> _sampleCoursePrograms = [
  CourseProgramItemData(
    initial: "ICAN",
    color: 0xFF0F0BAB,
    fullName: "Institute of Chartered Accountants of Nigeria",
    assetUrl: _getURL("ican_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  ),
  CourseProgramItemData(
    initial: "ACCA",
    color: 0xFFFF822B,
    fullName: "Association of Chartered Certified Accountants",
    assetUrl: _getURL("acca_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  ),
  CourseProgramItemData(
    initial: "CIMA",
    color: 0xFF1FAF73,
    fullName: "Chartered Institute of Management Accountants",
    assetUrl: _getURL("cima_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  ),
  CourseProgramItemData(
    initial: "CITN",
    color: 0xFF9747FF,
    fullName: "Chartered Institute of Taxation of Nigeria",
    assetUrl: _getURL("citn_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  ),
];
