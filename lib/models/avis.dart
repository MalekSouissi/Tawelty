class Avis {
  int id;
  String text;
  int restaurantId;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  Avis(
      {
        required this.id,
        required this.text,
        required this.restaurantId,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,});
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'RestaurantId':restaurantId,
      'UserId':userId,
    };
  }
  factory Avis.fromJson(Map<String, dynamic> item) {
    return Avis(
      id: item['id'],
      text: item['text'],
      restaurantId: item['RestaurantId'],
      userId: item['UserId'],
      // dateDebut: DateTime.parse(item['dateDebut']),
      // dateFin:
      //     item['dateFin'] != null ? DateTime.parse(item['dateFin']) : null,
      createdAt: DateTime.parse(item['createdAt']),
      updatedAt: DateTime.parse(item['updatedAt']),
    );
  }
}
