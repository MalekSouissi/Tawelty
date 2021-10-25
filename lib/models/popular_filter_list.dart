class PopularFilterListData {
  String titleTxt;
  bool isSelected;

  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  static List<PopularFilterListData> popularFList = [
    PopularFilterListData(
      titleTxt: 'free_breakfast',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'free_Parking',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'alcohol_text',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'karaoke_text',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'TPE_text',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'pet_friendlly',
      isSelected: false,
    ),
    // PopularFilterListData(
    //   titleTxt: 'reservation_text',
    //   isSelected: false,
    // ),
    PopularFilterListData(
      titleTxt: 'shisha_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Free_Wifi',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> cuisineFList = [
    PopularFilterListData(
      titleTxt: 'Cuisine_tunisienne',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Cuisine_italienne',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Cuisine_française',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Cuisine_asiatique',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Cuisine_mexicaine',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Cuisine_europeene',
      isSelected: false,
    ),
    // PopularFilterListData(
    //   titleTxt: 'reservation_text',
    //   isSelected: false,
    // ),
    PopularFilterListData(
      titleTxt: 'Cuisine_mer',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Cuisine_steak',
      isSelected: false,
    ),
  ];


  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'all_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'apartment',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Home_text',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'villa_data',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'hotel_data',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Resort_data',
      isSelected: false,
    ),
  ];
}
