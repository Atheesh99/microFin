class BaseAPI {
  static String base = "http://154.38.175.150:8090";
  static var api = "$base/api";
  String authPath = "$api/users/validateMobileUser";
  String memberNumberFetch = "$api/members/getMembershipDetails";
  static String hashcode = "00A581CC-B199-486E-831C-247C57DB5E92";

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };
}
