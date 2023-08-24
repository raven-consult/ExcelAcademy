import "package:grpc/grpc.dart";
import "package:firebase_auth/firebase_auth.dart";

import "package:mobile/services/course.dart";
import "package:mobile/services/generated/services/recommendations/recommendations.pbgrpc.dart";

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

  Future<List<Course>> getPopularCourses() async {
    var req = GetRecommendedCoursesRequest();
    var res = await _client.getRecommendedCourses(req);

    return Future.wait(res.courses
        .map((course) async => await Course.fromId(course.courseId))
        .toList());
  }
}
