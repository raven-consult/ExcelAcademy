import "package:grpc/grpc.dart";

import "package:mobile/services/course.dart";
import "package:mobile/services/generated/services/search/search.pbgrpc.dart";

const Map<String, String> searchServiceConn = {
  "host": "query-gdw5iipadq-uc.a.run.app",
  "port": "443"
};

class SearchService {
  late ClientChannel _channel;
  late SearchServiceClient _client;

  SearchService(String host, String port, CallOptions callOptions) {
    const options = ChannelOptions(credentials: ChannelCredentials.secure());
    _channel = ClientChannel(host, port: int.parse(port), options: options);
    _client = SearchServiceClient(_channel, options: callOptions);
  }

  Future<List<Course>> query(String queryString) async {
    var req = QueryRequest(query: queryString);
    var res = await _client.query(req);

    return Future.wait(res.results
        .map((course) async => await Course.fromId(course.courseId))
        .toList());
  }

  Future<List<String>> getPopularSearches() async {
    throw Exception("Not Implemented");
  }

  Future<List<Video>> getFeaturedVideos() async {
    throw Exception("Not Implemented");
  }
}