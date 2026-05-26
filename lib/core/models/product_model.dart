class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});
}

class ProductModel {
  final String category;
  final String name;
  final String description;
  final Rating rating;
  final double price;
  final bool isFavorite;
  final double? discount;
  final List<String> imageUrls;

  ProductModel({
    required this.category,
    required this.name,
    required this.description,
    required this.rating,
    required this.price,
    this.isFavorite = false,
    this.discount,
    required this.imageUrls,
  });
}

final List<ProductModel> dummyProducts = [
  ProductModel(
      category: 'Electronics',
      name: 'Premium Wireless Headphones',
      description:
          'Experience unparalleled sound quality with our Premium Wireless Headphones. Featuring advanced noise-cancellation technology, a comfortable over-ear design, and up to 30 hours of battery life, these headphones are perfect for music lovers and professionals alike.',
      rating: Rating(rate: 4.8, count: 124),
      price: 299.99,
      isFavorite: true,
      discount: 20.0,
      imageUrls: [
        'https://i.imgur.com/yVeIeDa.jpeg',
        'https://i.imgur.com/yVeIeDa.jpeg',
        'https://i.imgur.com/yVeIeDa.jpeg'
      ]),
  ProductModel(
      category: 'Electronics',
      name: 'Smart Watch Series 5',
      description:
          'Stay connected and track your health with the Smart Watch Series 5. Featuring a sleek design, customizable watch faces, and advanced fitness tracking capabilities, this smartwatch is your perfect companion for a healthier lifestyle.',
      rating: Rating(rate: 4.5, count: 89),
      price: 399.99,
      isFavorite: false,
      imageUrls: [
        'https://i.imgur.com/LGk9Jn2.jpeg',
        'https://i.imgur.com/LGk9Jn2.jpeg',
        'https://i.imgur.com/LGk9Jn2.jpeg'
      ]),
  ProductModel(
      category: 'Fashion',
      name: 'Urban Style Backpack',
      description:
          'The Urban Style Backpack combines functionality with modern design. Made from durable materials, it features multiple compartments for organization, padded straps for comfort, and a sleek silhouette that complements any outfit.',
      rating: Rating(rate: 4.3, count: 67),
      price: 89.99,
      isFavorite: false,
      imageUrls: [
        'https://i.imgur.com/BG8J0Fj.jpg',
        'https://i.imgur.com/BG8J0Fj.jpg',
        'https://i.imgur.com/BG8J0Fj.jpg'
      ]),
  ProductModel(
      category: 'Sports',
      name: 'Running Shoes Pro',
      description:
          'The Running Shoes Pro are designed for performance and comfort. With advanced cushioning technology and a breathable mesh upper, these shoes provide excellent support for your daily runs.',
      rating: Rating(rate: 4.6, count: 98),
      price: 129.99,
      isFavorite: true,
      discount: 15.0,
      imageUrls: [
        'https://imgur.com/AzAY4Ed.jpeg',
        'https://imgur.com/AzAY4Ed.jpeg',
        'https://imgur.com/AzAY4Ed.jpeg'
      ]),
  ProductModel(
      category: 'Electronics',
      name: 'Premium Wireless Headphones',
      description:
          'Experience unparalleled sound quality with our Premium Wireless Headphones. Featuring advanced noise-cancellation technology, a comfortable over-ear design, and up to 30 hours of battery life, these headphones are perfect for music lovers and professionals alike.',
      rating: Rating(rate: 4.8, count: 124),
      price: 299.99,
      isFavorite: false,
      imageUrls: [
        'https://i.imgur.com/yVeIeDa.jpeg',
        'https://i.imgur.com/yVeIeDa.jpeg',
        'https://i.imgur.com/yVeIeDa.jpeg'
      ]),
  ProductModel(
      category: 'Electronics',
      name: 'Smart Watch Series 5',
      description:
          'Stay connected and track your health with the Smart Watch Series 5. Featuring a sleek design, customizable watch faces, and advanced fitness tracking capabilities, this smartwatch is your perfect companion for a healthier lifestyle.',
      rating: Rating(rate: 4.5, count: 89),
      price: 399.99,
      isFavorite: true,
      discount: 25.0,
      imageUrls: [
        'https://i.imgur.com/LGk9Jn2.jpeg',
        'https://i.imgur.com/LGk9Jn2.jpeg',
        'https://i.imgur.com/LGk9Jn2.jpeg'
      ]),
  ProductModel(
      category: 'Fashion',
      name: 'Urban Style Backpack',
      description:
          'The Urban Style Backpack combines functionality with modern design. Made from durable materials, it features multiple compartments for organization, padded straps for comfort, and a sleek silhouette that complements any outfit.',
      rating: Rating(rate: 4.3, count: 67),
      price: 89.99,
      isFavorite: false,
      imageUrls: [
        'https://i.imgur.com/BG8J0Fj.jpg',
        'https://i.imgur.com/BG8J0Fj.jpg',
        'https://i.imgur.com/BG8J0Fj.jpg'
      ]),
  ProductModel(
      category: 'Sports',
      name: 'Running Shoes Pro',
      description:
          'The Running Shoes Pro are designed for performance and comfort. With advanced cushioning technology and a breathable mesh upper, these shoes provide excellent support for your daily runs.',
      rating: Rating(rate: 4.6, count: 98),
      price: 129.99,
      isFavorite: false,
      imageUrls: [
        'https://imgur.com/AzAY4Ed.jpeg',
        'https://imgur.com/AzAY4Ed.jpeg',
        'https://imgur.com/AzAY4Ed.jpeg'
      ]),
];
