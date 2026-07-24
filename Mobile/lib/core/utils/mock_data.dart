import 'package:nexora/features/brands/domain/entities/brand.dart';
import 'package:nexora/features/cart/domain/entities/cart.dart';
import 'package:nexora/features/category/domain/entities/category.dart';
import 'package:nexora/features/product/domain/entities/product.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/banner/domain/entities/banner.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/reviews/domain/entities/review.dart';

class MockData {
  MockData._();

  static List<Product> get products => List.generate(
        10,
        (i) => Product(
          id: i.toString(),
          name: "Product $i",
          brand: brands[0],
          category: categories[0],
          description: "Description for Product $i",
          price: 299.99,
          discount: 20.0,
          stock: 50,
          sold: 120,
          ratingRate: 4.8,
          ratingCount: 320,
          thumbnail: "https://i.imgur.com/yVeIeDa.jpeg",
          images: ["https://i.imgur.com/yVeIeDa.jpeg"],
        ),
      );

  static List<Category> get categories => List.generate(
        6,
        (i) => Category(
          id: i.toString(),
          name: "Category $i",
          image: "https://i.imgur.com/yVeIeDa.jpeg",
        ),
      );

  static List<Brand> get brands => List.generate(
        6,
        (i) => Brand(
          id: i.toString(),
          name: "Brand $i",
          image: "https://i.imgur.com/yVeIeDa.jpeg",
        ),
      );

  static List<ShippingAddress> get addresses => List.generate(
        3,
        (i) => ShippingAddress(
          id: i.toString(),
          label: "Home",
          street: "Grove ST",
          apartment: "Grove",
          city: "Alex",
          postalCode: "21500",
          phone: "01234567891",
          isDefault: i == 0,
        ),
      );

  static List<PromoBanner> get banners => List.generate(
        3,
        (i) => PromoBanner(
          id: i.toString(),
          title: "Promo Banner",
          image:
              "https://cdn.thewirecutter.com/wp-content/media/2026/03/BG-IPHONE-5334-2X1.jpg?width=2048&quality=75&crop=2:1&auto=webp",
          type: "product",
          target: "id",
          isActive: true,
        ),
      );

  static List<Order> get orders => List.generate(
        5,
        (i) => Order(
          id: "00000000000000",
          totalOrderPrice: 999.99,
          status: "pending",
          cartItems: List.generate(
            2,
            (_) => OrderItem(
              productId: "00000000000000",
              productName: "P1",
              productThumbnail: "https://via.placeholder.com/150",
              quantity: 2,
              price: 499.99,
            ),
          ),
          paymentMethodType: "card",
          isPaid: false,
          shippingAddress: ShippingAddress(
            street: "Grove St",
            city: "Groove City",
            postalCode: "12345",
            phone: "01234567891",
          ),
          createdAt: DateTime.now(),
        ),
      );

  static Cart get cart => Cart(
        items: List.generate(
          3,
          (i) => CartItem(
            id: (i + 1).toString(),
            product: products[i],
            quantity: 1,
            price: 10,
          ),
        ),
        totalPrice: 30,
      );

  static List<Review> get reviews => List.generate(
        3,
        (i) => Review(
          id: i.toString(),
          productId: "",
          userId: "",
          userName: "",
          rating: 2,
          createdAt: DateTime.now(),
        ),
      );
}
