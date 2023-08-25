import "package:grpc/grpc.dart";
import "package:firebase_auth/firebase_auth.dart";

import "package:mobile/services/course.dart";
import "package:mobile/services/generated/services/recommendations/recommendations.pbgrpc.dart";

const Map<String, String> recommendationsServiceConn = {
  "host": "recommendations-gdw5iipadq-uc.a.run.app",
  "port": "443"
};

CallOptions getGRPCCallOptions() {
  return CallOptions(providers: [
    (metadata, uri) async {
      String? authorization;
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        authorization = "";
      } else {
        authorization = await currentUser.getIdToken(true);
      }
      metadata['Authorization'] = "Bearer $authorization";
    }
  ]);
}

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
