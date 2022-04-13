class Product {
  Product(
      {required this.id,
      required this.label,
      required this.image,
      required this.category,
      required this.price,
      required this.rating});
  final String id, label, image;
  final ProductCategory category;
  final int price, rating;

  //Terjemahkan Data Json ke Bentuk Data Product
  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String,
      label: json['label'] as String,
      image: json['image'] as String,
      category: ProductCategory.values[json['category'] as int],
      price: json['price'] as int,
      rating: json['rating'] as int);

  //Terjemahkan Data Product ke Json
  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'image': image,
        'category': category.index,
        'price': price,
        'rating': rating
      };
}

enum ProductCategory { apple, banana, orange }
