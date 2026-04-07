class ProductModel {
  final String category;
  final String name;
  final double price;
  final bool isFavorite;
  final double? discount;
  final String imageUrl;

  ProductModel({
    required this.category,
    required this.name,
    required this.price,
    this.isFavorite = false,
    this.discount,
    required this.imageUrl,
  });
}

final List<ProductModel> dummyProducts = [
  ProductModel(
      category: 'Electronics',
      name: 'Premium Wireless Headphones',
      price: 299.99,
      isFavorite: true,
      discount: 20.0,
      imageUrl: 'https://i.imgur.com/yVeIeDa.jpeg'),
  ProductModel(
      category: 'Electronics',
      name: 'Smart Watch Series 5',
      price: 399.99,
      isFavorite: false,
      imageUrl: 'https://i.imgur.com/LGk9Jn2.jpeg'),
  ProductModel(
      category: 'Fashion',
      name: 'Urban Style Backpack',
      price: 89.99,
      isFavorite: false,
      imageUrl: 'https://i.imgur.com/BG8J0Fj.jpg'),
  ProductModel(
      category: 'Sports',
      name: 'Running Shoes Pro',
      price: 129.99,
      isFavorite: true,
      discount: 15.0,
      imageUrl: 'https://imgur.com/AzAY4Ed.jpeg'),
  ProductModel(
      category: 'Electronics',
      name: 'Premium Wireless Headphones',
      price: 299.99,
      isFavorite: false,
      imageUrl: 'https://i.imgur.com/yVeIeDa.jpeg'),
  ProductModel(
      category: 'Electronics',
      name: 'Smart Watch Series 5',
      price: 399.99,
      isFavorite: true,
      discount: 25.0,
      imageUrl: 'https://i.imgur.com/LGk9Jn2.jpeg'),
  ProductModel(
      category: 'Fashion',
      name: 'Urban Style Backpack',
      price: 89.99,
      isFavorite: false,
      imageUrl: 'https://i.imgur.com/BG8J0Fj.jpg'),
  ProductModel(
      category: 'Sports',
      name: 'Running Shoes Pro',
      price: 129.99,
      isFavorite: false,
      imageUrl: 'https://imgur.com/AzAY4Ed.jpeg'),
];
