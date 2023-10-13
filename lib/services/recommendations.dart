import "package:grpc/grpc.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

import "package:mobile/services/course.dart";
import "package:mobile/services/generated/services/recommendations/recommendations.pbgrpc.dart";

Map<String, String> recommendationsServiceConn = {
  "host": dotenv.env["RECOMMENDATIONS"] ?? "localhost",
  "port": dotenv.env["RECOMMENDATIONS_PORT"] ?? "443",
};

class RecommendationService {
  late ClientChannel _channel;
  late RecommendationsServiceClient _client;

  RecommendationService(String host, String port, CallOptions callOptions) {
    const options = ChannelOptions(credentials: ChannelCredentials.secure());
    _channel = ClientChannel(host, port: int.parse(port), options: options);
    _client = RecommendationsServiceClient(_channel, options: callOptions);
  }

  Future<List<Course>> getLatestCourses() async {
    var req = GetLatestCoursesRequest();
    var res = await _client.getLatestCourses(req);

    return Future.wait(res.courses
        .map((course) async => await Course.fromId(course.courseId))
        .toList());
  }

  Future<List<Course>> getPopularCourses() async {
    var req = GetPopularCoursesRequest();
    var res = await _client.getPopularCourses(req);

    return Future.wait(res.courses
        .map((course) async => await Course.fromId(course.courseId))
        .toList());
  }
}
