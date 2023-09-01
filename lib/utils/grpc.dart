import "package:grpc/grpc.dart";
import "package:firebase_auth/firebase_auth.dart";

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
