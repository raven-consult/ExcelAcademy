import "package:grpc/grpc.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

import "package:mobile/services/course.dart";
import "package:mobile/services/generated/services/search/search.pbgrpc.dart";

Map<String, String> searchServiceConn = {
  "host": dotenv.env["SEARCH"] ?? "localhost",
  "port": dotenv.env["SEARCH_PORT"] ?? "443",
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

  Future<List<String>> getPreviousSearches(String userId) async {
    var req = GetPreviousSearchesRequest(userId: userId);
    var res = await _client.getPreviousSearches(req);

    return res.queries;
  }
}
