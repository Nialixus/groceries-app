class Order {
  Order({required this.productKey, required this.quantity});
  final String productKey;
  int quantity; //Tidak final karena akan diubah-ubah di Laman 'Cart'

  //Terjemahkan Data Json ke Bentuk Data Order
  factory Order.fromJson(Map<String, dynamic> json) => Order(
      productKey: json['productKey'] as String,
      quantity: json['quantity'] as int);

  //Terjemahkan Data Order ke Json
  Map<String, dynamic> toJson() =>
      {'productKey': productKey, 'quantity': quantity};
}
