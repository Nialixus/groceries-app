import 'package:flutter/material.dart';
import 'package:klikdaily_test/data/product.dart';
import 'package:klikdaily_test/main.dart';
import 'package:provider/provider.dart';

//Halaman Index 1
class Cart extends StatelessWidget {
  const Cart({Key? key, required this.order}) : super(key: key);
  final OrderedData order; //State Cart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1EA050),
        flexibleSpace: SafeArea(
            child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.075),
          child: const Text(
            'Cart Product',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )),
      ),
      body:
          //Daftar Cart
          Consumer<OrderedData>(builder: (_, ordered, orderedChild) {
        //Pemintas ~ Data Produk yang memiliki kunci yang sama dengan Data Cart
        Product newProduct(int index) => order.productList.firstWhere(
            (e) => e.id == ordered.orderList[index].productKey,
            orElse: () => order.productList[0]);

        return Stack(
          children: [
            ordered.orderList.isEmpty
                ?
                //Tampilkan Kasus Data Cart Kosong
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - kToolbarHeight,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          size: 50,
                        ),
                        SizedBox(
                          height: 7.5,
                        ),
                        Text(
                          'Cart is Empty',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                          ),
                        )
                      ],
                    ),
                  )
                :
                //Tampilkan Data Cart
                ListView.builder(
                    padding: const EdgeInsets.only(bottom: kToolbarHeight),
                    itemBuilder: (c, x) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.5, vertical: 10),
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.075,
                              right: MediaQuery.of(context).size.width * 0.075,
                              top: x == 0
                                  ? MediaQuery.of(context).size.width * 0.075
                                  : 0,
                              bottom: x == 9
                                  ? MediaQuery.of(context).size.width * 0.075
                                  : MediaQuery.of(context).size.width * 0.05),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1,
                                  color: const Color.fromRGBO(
                                      229, 229, 229, 0.63))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        newProduct(x).label,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.68)),
                                      ),
                                    ),
                                    Material(
                                      color: const Color.fromRGBO(
                                          239, 243, 246, 0.48),
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        onTap: () => order
                                            .removeProduct(newProduct(x).id),
                                        borderRadius: BorderRadius.circular(10),
                                        child: CustomPaint(
                                          painter: CloseIcon(),
                                          size: const Size(25, 25),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        width: 50,
                                        padding: const EdgeInsets.all(2.5),
                                        margin:
                                            const EdgeInsets.only(right: 12.5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xffE5E5E5)),
                                        child:
                                            Image.asset(newProduct(x).image)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Rp ' +
                                                newProduct(x)
                                                    .price
                                                    .toString()
                                                    .substring(0, 2) +
                                                '.' +
                                                newProduct(x)
                                                    .price
                                                    .toString()
                                                    .substring(2, 5) +
                                                ',-',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.68)),
                                          ),
                                          Row(
                                            children: List.generate(
                                                5,
                                                (y) => Icon(
                                                      5 - y <
                                                              newProduct(x)
                                                                  .rating
                                                          ? Icons.star_border
                                                          : Icons.star,
                                                      color: 5 - y <
                                                              newProduct(x)
                                                                  .rating
                                                          ? const Color
                                                                  .fromRGBO(
                                                              0, 0, 0, 0.2)
                                                          : const Color(
                                                              0xffFCAF05),
                                                      size: 20,
                                                    )),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                        children: List.generate(
                                            3,
                                            (y) => GestureDetector(
                                                  onTap: () => y == 0
                                                      ? order.removeQuantity(
                                                          newProduct(x).id)
                                                      : y == 2
                                                          ? order.addQuantity(
                                                              newProduct(x).id)
                                                          : {},
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 0.5),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: y == 1
                                                            ? const Border()
                                                            : Border.all(
                                                                width: 2,
                                                                color: const Color(
                                                                    0xff5BB98B))),
                                                    child: Text(
                                                      [
                                                        '-',
                                                        '${ordered.orderList[x].quantity}',
                                                        '+'
                                                      ][y],
                                                      style: TextStyle(
                                                          fontWeight: y == 1
                                                              ? FontWeight
                                                                  .normal
                                                              : FontWeight
                                                                  .bold),
                                                    ),
                                                  ),
                                                )))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                    itemCount: ordered.orderList.length),

            //Tombol Melayang Checkout
            Consumer<OrderedData>(
              builder: (_, ordered, orderedChild) => AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: 0,
                right: 0,
                bottom: ordered.orderList.isEmpty ? -kToolbarHeight - 20 : 0,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.075,
                        vertical: 12.5),
                    height: kToolbarHeight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff1EA050)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(3, (x) {
                              String totalPrice = ordered.orderList.isEmpty
                                  ? '999999'
                                  : ordered.orderList
                                      .fold<int>(
                                          0,
                                          (p, e) =>
                                              p +
                                              (ordered.productList
                                                      .firstWhere((ee) =>
                                                          ee.id == e.productKey)
                                                      .price *
                                                  e.quantity))
                                      .toString();
                              return x == 1
                                  ? Container(
                                      height: 2,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      [
                                        'Total ${ordered.orderList.isEmpty ? '0' : ordered.orderList.fold<int>(0, (p, e) => p + e.quantity)} Item',
                                        '-',
                                        ordered.orderList.isEmpty
                                            ? '0'
                                            : 'Rp ${totalPrice.substring(0, totalPrice.length - 3)}.${totalPrice.substring(totalPrice.length - 3, totalPrice.length)}'
                                      ][x],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    );
                            }),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            order.checkOutProduct();
                            //Tampilkan Snackbar Saat 'Checkout' Diketuk
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Checkout Success',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Color(0xff1EA050),
                            ));
                          },
                          child: const Text(
                            'Checkout',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ],
        );
      }),
    );
  }
}

//Lambang Tutup 'X'
class CloseIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xffFF0000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    //Garis Atas Kiri ke Bawah Kanan
    canvas.drawPath(
        Path()
          ..moveTo(5, 5)
          ..lineTo(size.width - 5, size.height - 5),
        paint);

    //Garis Atas Kanan ke Bawah Kiri
    canvas.drawPath(
        Path()
          ..moveTo(size.width - 5, 5)
          ..lineTo(5, size.height - 5),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
