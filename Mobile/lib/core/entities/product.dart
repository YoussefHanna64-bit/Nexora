class Product {
  final String id;
  final String name;
  final String brand;
  final String description;
  final num price;
  final num discount;
  final int stock;
  final int sold;
  final num ratingRate;
  final int ratingCount;
  final String categoryId;
  final String categoryName;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.discount,
    required this.stock,
    required this.sold,
    required this.ratingRate,
    required this.ratingCount,
    required this.categoryId,
    required this.categoryName,
    required this.thumbnail,
    required this.images,
  });

  static List<Product> get mockProducts => List.generate(
      10,
      (index) => Product(
            id: index.toString(),
            name: "Product",
            brand: "Brand",
            description: "Description for Product",
            price: 299.99,
            discount: 20.0,
            stock: 50,
            sold: 120,
            ratingRate: 4.8,
            ratingCount: 320,
            categoryId: "categoryId",
            categoryName: "CategoryName",
            thumbnail: "https://i.imgur.com/yVeIeDa.jpeg",
            images: ["https://i.imgur.com/yVeIeDa.jpeg"],
          ));
}
