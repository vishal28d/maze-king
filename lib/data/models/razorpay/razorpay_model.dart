class RazorPayModel {
  final String razorPayKey;
  final String razorPaySecret;

  RazorPayModel({
    required this.razorPayKey,
    required this.razorPaySecret,
  });

  factory RazorPayModel.fromJson(Map<String, dynamic> json) => RazorPayModel(
        razorPayKey: json["razorPayKey"],
        razorPaySecret: json["razorPaySecret"],
      );

  Map<String, dynamic> toJson() => {
        "razorPayKey": razorPayKey,
        "razorPaySecret": razorPaySecret,
      };
}
