import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:klikdaily_test/data/order.dart';
import 'package:klikdaily_test/data/product.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:klikdaily_test/page/cart.dart';
import 'package:klikdaily_test/page/home.dart';
import 'package:klikdaily_test/page/profile.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MaterialApp(
      title: 'KlikDaily Assesment Test',
      color: Color(0xff1EA050),
      home: PageContainer()));
}

//Ambil API dan Terjemahkan
getData() async {
  Response response = await get(Uri.parse("https://randomuser.me/api"));
  return jsonDecode(response.body)['results'];
}

//Laman Penampung ~ Pageview
class PageContainer extends StatefulWidget {
  const PageContainer({Key? key}) : super(key: key);

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  dynamic profileData;
  @override
  void initState() {
    //Ambil Data sebagai final agar tidak berubah-ubah per sesi
    profileData = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();

    return ChangeNotifierProvider(
      create: (context) => OrderedData(storage: Storage()),
      builder: (orderContext, orderChild) {
        OrderedData orderFunction =
            Provider.of<OrderedData>(orderContext, listen: false);

        return FutureBuilder(
            //Memanggil Fungsi Baca Daftar Produk Dilanjutkan Dengan Baca Daftar Cart
            future: Future.value(Storage()
                .loadProductFile()
                .then((value) => orderFunction.loadProductList(value))
                .then((value) => Storage()
                    .readFile()
                    .then((value) => orderFunction.loadOrderList(value)))),
            builder: (futureContext, snapshot) => ChangeNotifierProvider(
                  create: (context) => Tab(),
                  builder: (tabContext, tabChild) => Scaffold(
                      backgroundColor: Colors.white,
                      body: PageView.builder(
                        itemBuilder: (context, page) => [
                          Home(
                            data: profileData,
                            order: orderFunction,
                          ),
                          Cart(
                            order: orderFunction,
                          ),
                          Profile(
                            data: profileData,
                          )
                        ][page],
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        controller: controller,
                        onPageChanged: (page) =>
                            //Deteksi Indeks Halaman dan teruskan ke Notifier
                            Provider.of<Tab>(tabContext, listen: false)
                                .changePage(page),
                      ),
                      bottomNavigationBar: Container(
                        height: kToolbarHeight,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(299, 299, 299, 0.15),
                                  offset: Offset(0, -1))
                            ],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            //Tombol Navigasi
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: List.generate(
                                  3,
                                  (button) => Expanded(
                                        child: Tooltip(
                                          message: [
                                            'Home',
                                            'Cart',
                                            'Profile'
                                          ][button],
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {
                                                controller.jumpToPage(button);
                                                Provider.of<Tab>(tabContext,
                                                        listen: false)
                                                    .changePage(button);
                                              },
                                              borderRadius: BorderRadius.only(
                                                  topLeft: button == 0
                                                      ? const Radius.circular(
                                                          10)
                                                      : Radius.zero,
                                                  topRight: button == 2
                                                      ? const Radius.circular(
                                                          10)
                                                      : Radius.zero),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/${[
                                                        'home',
                                                        'cart',
                                                        'profile'
                                                      ][button]}.png',
                                                      width: 20,
                                                      height: 20),
                                                  Text(
                                                    [
                                                      'Home',
                                                      'Cart',
                                                      'Profile'
                                                    ][button],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                            ),

                            //Bubble Notification Menampilkan Jumlah Keseluruhan Barang yang dipesan
                            Positioned(
                              top: 5,
                              child: Consumer<OrderedData>(
                                builder: (_, ordered, orderedChild) => ordered
                                            .orderList
                                            .fold(
                                                0,
                                                (p, e) =>
                                                    (p as int) + e.quantity) <=
                                        0
                                    ? const SizedBox()
                                    : Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        padding: const EdgeInsets.all(3.5),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                        child: Text(
                                          ordered.orderList
                                              .fold<int>(
                                                  0, (p, e) => p + e.quantity)
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                              ),
                            ),

                            //Animasi Garis Bawah Penanda Indeks Halaman
                            Consumer<Tab>(
                              builder: (_, tab, tabChild) => AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  bottom: 7.5,
                                  left: MediaQuery.of(context).size.width /
                                      3 *
                                      tab.page,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: tabChild!),
                              child: Center(
                                child: Container(
                                    height: 4,
                                    width: 40,
                                    color: const Color(0xff5BB98B)),
                              ),
                            )
                          ],
                        ),
                      )),
                ));
      },
    );
  }
}

//Pengelola Indeks Laman Pageview
class Tab with ChangeNotifier {
  int page = 0;

  void changePage(int laman) {
    page = laman;
    notifyListeners();
  }
}

//Class untuk menyimpan data cart dan daftar produk
class Storage {
  //Baca Jalur Daftar Cart
  Future<File> get storedFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/storedFile.txt');
  }

  //Memuat Daftar Cart
  Future<List<Order>> readFile() async {
    try {
      final file = await storedFile;
      final content = await file.readAsString();
      return List<Order>.from(
          jsonDecode(content).map((e) => Order.fromJson(e)));
    } catch (e) {
      return [];
    }
  }

  //Mengubah Daftar Cart
  Future<File> writeFile(List<Order> isi) async {
    final file = await storedFile;
    return file.writeAsString(jsonEncode(isi.map((e) => e.toJson()).toList()));
  }

  //Baca jalur Daftar Produk
  Future<File> get productFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/productFile.txt').create(recursive: true);
  }

  //Memuat Daftar Produk
  Future<List<Product>> loadProductFile() async {
    try {
      final file = await productFile;
      final content = await file.readAsString();
      return List<Product>.from(
          jsonDecode(content).map((e) => Product.fromJson(e)));
    } catch (e) {
      Uuid rootId = const Uuid();
      List<Product> defaultProductList = List.generate(
          12,
          (x) => Product(
              id: rootId.v4(),
              category: x >= 0 && x <= 3
                  ? ProductCategory.apple
                  : x > 3 && x < 8
                      ? ProductCategory.banana
                      : ProductCategory.orange,
              label:
                  'Sweet ${x >= 0 && x <= 3 ? 'Apple' : x > 3 && x < 8 ? 'Banana' : 'Orange'} ${[
                'Indonesia',
                'Canada',
                'Japan',
                'India',
                'Korea',
                'Italia'
              ][x < 6 ? x : x - 6]}',
              image:
                  'assets/${x >= 0 && x <= 3 ? 'apple' : x > 3 && x < 8 ? 'banana' : 'orange'}.png',
              price: [30000, 25000, 20000, 15000, 10000][Random().nextInt(5)],
              rating: Random().nextInt(6)));

      setProductFile(defaultProductList);
      return defaultProductList;
    }
  }

  //Membuat Daftar Produk
  Future<File> setProductFile(List<Product> isi) async {
    final file = await productFile;
    return file.writeAsString(jsonEncode(isi.map((e) => e.toJson()).toList()));
  }
}

//Pengelola State Cart
class OrderedData with ChangeNotifier {
  OrderedData({required this.storage});
  final Storage storage;

  List<Order> orderList = [];
  late List<Product> productList = [];

  //Atur Daftar Produk
  void loadProductList(List<Product> newProductList) {
    productList = newProductList;
    notifyListeners();
  }

  //Atur Daftar Cart
  void loadOrderList(List<Order> newOrderList) {
    orderList = newOrderList;
    notifyListeners();
  }

  //Panggilan Tombol "Buy"
  void buyProduct(String productKey) {
    orderList.any((e) => e.productKey == productKey)
        ? orderList.firstWhere((e) => e.productKey == productKey).quantity += 1
        : orderList.add(Order(productKey: productKey, quantity: 1));
    storage.writeFile(orderList);
    notifyListeners();
  }

  //Panggilan Tombol '+'
  void addQuantity(String productKey) {
    orderList.firstWhere((e) => e.productKey == productKey).quantity += 1;
    storage.writeFile(orderList);
    notifyListeners();
  }

  //Panggilan Tombol '-'
  void removeQuantity(String productKey) {
    orderList.firstWhere((e) => e.productKey == productKey).quantity == 1
        ? orderList.removeWhere((e) => e.productKey == productKey)
        : orderList.firstWhere((e) => e.productKey == productKey).quantity -= 1;
    storage.writeFile(orderList);
    notifyListeners();
  }

  //Panggilan Tombol 'X'
  void removeProduct(String productKey) {
    orderList.removeWhere((e) => e.productKey == productKey);
    storage.writeFile(orderList);
    notifyListeners();
  }

  //Panggilan Tombol 'Checkout'
  void checkOutProduct() {
    orderList.clear();
    storage.writeFile(orderList);
    notifyListeners();
  }
}
