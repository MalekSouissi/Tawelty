class Favorite {
  int id;
  int restaurantId;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  Favorite(
      {
        required this.id,
        required this.restaurantId,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,});
  Map<String, dynamic> toJson() {
    return {
      'RestaurantId':restaurantId,
      'UserId':userId,
    };
  }
  factory Favorite.fromJson(Map<String, dynamic> item) {
    return Favorite(
      id: item['id'],
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
