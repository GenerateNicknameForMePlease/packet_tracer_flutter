class FeedbackModel {
  final String title;
  final String body;

  const FeedbackModel({this.title, this.body});

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
  };
}