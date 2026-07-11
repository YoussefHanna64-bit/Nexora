class PromoBanner {
  final String id;
  final String title;
  final String image;
  final String type;
  final String target;
  final bool isActive;

  PromoBanner({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
    required this.target,
    required this.isActive,
  });

  static List<PromoBanner> get mockBanners => List.generate(
      3,
      (index) => PromoBanner(
            id: index.toString(),
            title: "Promo Banner",
            image:
                "https://cdn.thewirecutter.com/wp-content/media/2026/03/BG-IPHONE-5334-2X1.jpg?width=2048&quality=75&crop=2:1&auto=webp",
            type: "product",
            target: "id",
            isActive: true,
          ));
}
