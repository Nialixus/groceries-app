import 'package:flutter/material.dart';
import 'package:klikdaily_test/data/product.dart';
import 'package:klikdaily_test/main.dart';
import 'package:provider/provider.dart';

//Halaman Index 0
class Home extends StatelessWidget {
  const Home({Key? key, required this.data, required this.order})
      : super(key: key);

  final dynamic data; //Profile Data
  final OrderedData order; //State Cart

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    double padding = MediaQuery.of(context).size.width * 0.075;

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => ProductList(),
          builder: (categoryContext, child) => CustomScrollView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            slivers: [
              //Judul Kepala 'Find Fresh Groceries'
              SliverAppBar(
                  toolbarHeight: kToolbarHeight * 2,
                  backgroundColor: Colors.white,
                  flexibleSpace: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text.rich(TextSpan(
                              children: List.generate(
                                  2,
                                  (x) => TextSpan(
                                      text: ['Find ', 'Fresh Groceries'][x],
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: [
                                          const Color(0xfffcaf05),
                                          const Color(0xff1ea050)
                                        ][x],
                                      ))))),
                        ),

                        //Avatar Kepala
                        Container(
                          width: 50,
                          height: 50,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            color: Color(0xff1EA050),
                            shape: BoxShape.circle,
                          ),
                          child: FutureBuilder(
                              builder: (context, snapshot) => snapshot.hasData
                                  ? Image.network(
                                      (snapshot.data as List)[0]['picture']
                                          ['thumbnail'],
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(),
                              future: data),
                        )
                      ],
                    ),
                  )),

              //Kolom Pencarian
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xffFFFFFF),
                toolbarHeight: kToolbarHeight * 2 + 40,
                flexibleSpace: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: kToolbarHeight,
                        child: Consumer<ProductList>(
                          builder: (_, category, categoryChild) => Focus(
                              child: categoryChild!,
                              onFocusChange: (focus) =>
                                  category.changeFocus(focus)),
                          child: TextField(
                              controller: controller,
                              cursorColor: const Color(0xff1ea050),
                              onChanged: (search) => Provider.of<ProductList>(
                                      categoryContext,
                                      listen: false)
                                  .changeSearch(search),
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Search Groceries',
                                  hintStyle: const TextStyle(
                                      color: Color(0xffC3BFBF),
                                      fontWeight: FontWeight.bold),
                                  prefixIcon: const CustomPaint(
                                    size: Size(20, 20),
                                    painter: SearchIcon(),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                      minHeight: 40, minWidth: 40),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      controller.clear();
                                      Provider.of<ProductList>(categoryContext,
                                              listen: false)
                                          .changeSearch('');
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Consumer<ProductList>(
                                        builder: (_, category, categoryChild) =>
                                            category.focus == true
                                                ? const Icon(
                                                    Icons.clear,
                                                    color: Colors.red,
                                                  )
                                                : const SizedBox()),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                      minHeight: 40, minWidth: 40),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: Color(0xff1ea050))),
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Color(0xffE5E5E5),
                                          width: 1.0)))),
                        ),
                      ),

                      //Label Kategori
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 30,
                        child: const Text(
                          'Categories',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 0, 0, 0.68)),
                        ),
                      ),

                      //Daftar Kategori
                      SizedBox(
                        height: kToolbarHeight,
                        child: Row(
                          children: List.generate(
                              3,
                              (x) => Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: x == 2 ? 0 : 5,
                                          left: x == 0 ? 0 : 5),
                                      child: Consumer<ProductList>(
                                        builder: (_, category, categoryChild) =>
                                            Material(
                                                color: [
                                                          ProductCategory.apple,
                                                          ProductCategory
                                                              .orange,
                                                          ProductCategory.banana
                                                        ][x] ==
                                                        category.category
                                                    ? const Color(0xff1EA050)
                                                    : const Color(0xffE5E5E5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: categoryChild),
                                        child: InkWell(
                                          onTap: () => Provider.of<ProductList>(
                                                  categoryContext,
                                                  listen: false)
                                              .changeCategory([
                                            ProductCategory.apple,
                                            ProductCategory.orange,
                                            ProductCategory.banana
                                          ][x]),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Consumer<ProductList>(
                                                  builder: (_, category,
                                                          categoryChild) =>
                                                      Text(
                                                        [
                                                          'Apple',
                                                          'Orange',
                                                          'Banana'
                                                        ][x],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: [
                                                                      ProductCategory
                                                                          .apple,
                                                                      ProductCategory
                                                                          .orange,
                                                                      ProductCategory
                                                                          .banana
                                                                    ][x] ==
                                                                    category
                                                                        .category
                                                                ? Colors.white
                                                                : const Color(
                                                                    0xffA09B9B),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))),
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //Daftar Produk Per Kategori
              Consumer<ProductList>(builder: (_, category, categoryChild) {
                List<Product> daftarProduk = order.productList
                    .where((e) =>
                        e.category == category.category &&
                        e.label
                            .toLowerCase()
                            .contains(category.search.toLowerCase()))
                    .toList();

                return daftarProduk.isEmpty
                    ?
                    //Tampilkan Kasus Produk Kosong
                    const SliverFillRemaining(
                        child: Center(
                            child: Text(
                          'Product Not Found',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                          ),
                        )),
                      )
                    :
                    //Tampilkan Daftar Produk
                    SliverList(
                        delegate: SliverChildListDelegate(List.generate(
                            daftarProduk.length,
                            (x) => Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: padding),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.5, vertical: 12.5),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border: Border.all(
                                          width: 1,
                                          color: const Color.fromRGBO(
                                              229, 229, 229, 0.63))),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        margin:
                                            const EdgeInsets.only(right: 12.5),
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            color: Color.fromRGBO(
                                                229, 229, 229, 0.63)),
                                        child:
                                            Image.asset(daftarProduk[x].image),
                                      ),
                                      Expanded(
                                          child: SizedBox(
                                        height: 80,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              daftarProduk[x].label,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.68)),
                                            ),
                                            Text(
                                              'Rp ${daftarProduk[x].price.toString().substring(0, 2) + '.' + daftarProduk[x].price.toString().substring(2, 5)}/kg',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff7d7777)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                  5,
                                                  (y) => Icon(
                                                        5 - y <
                                                                daftarProduk[x]
                                                                    .rating
                                                            ? Icons.star_border
                                                            : Icons.star,
                                                        color: 5 - y <
                                                                daftarProduk[x]
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
                                      )),
                                      Material(
                                        color: const Color(0xff1EA050),
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          onTap: () => order
                                              .buyProduct(daftarProduk[x].id),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.5,
                                                vertical: 7.5),
                                            child: Text(
                                              'Buy',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                          ..add(const SizedBox(
                            height: 10,
                          ))));
              })
            ],
          ),
        ),
      ),
    );
  }
}

//Lambang Cari
class SearchIcon extends CustomPainter {
  const SearchIcon({Key? key});

  @override
  void paint(Canvas canvas, Size size) {
    Paint stroke = Paint()
      ..color = const Color(0xff1EA050)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    //Foreground Slash
    canvas.drawPath(
        Path()
          ..moveTo(size.width / 2, size.height / 2)
          ..lineTo(size.width / 2 + 10, size.height / 2 + 10),
        stroke);

    //Background Circle
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        7.5,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color(0xffffffff));

    //Foreground Circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 7.5, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

//State Baca Kategori dan Cari Produk dari Daftar Produk
class ProductList with ChangeNotifier {
  ProductCategory category = ProductCategory.apple;

  //Panggil Tombol Pilihan Kategori
  void changeCategory(ProductCategory newCategory) {
    category = newCategory;
    notifyListeners();
  }

  //Cari Produk dari Daftar Kategori
  String search = '';
  void changeSearch(String newSearch) {
    search = newSearch;
    notifyListeners();
  }

  //Deteksi Kefocusan Kolom Pencarian
  bool focus = false;
  void changeFocus(bool newFocus) {
    focus = newFocus;
    notifyListeners();
  }
}
