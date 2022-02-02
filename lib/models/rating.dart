class Rate {
  int id;
  int note;
  int restaurantId;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  Rate(
      {
        required this.id,
        required this.note,
        required this.restaurantId,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,});
  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'RestaurantId':restaurantId,
      'UserId':userId,
    };
  }
  factory Rate.fromJson(Map<String, dynamic> item) {
    return Rate(
      id: item['id'],
      note: item['note'],
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
