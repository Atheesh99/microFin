class BaseAPI {
  static String base = "http://154.38.175.150:8090";
  static var api = "$base/api";
  String authPath = "$api/users/validateMobileUser";
  String memberNumberFetch = "$api/members/getMembershipDetails";

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };
}
