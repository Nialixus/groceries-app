import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key, required this.data}) : super(key: key);
  final dynamic data; //Data Profile

  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.of(context).size.width * 0.075;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1EA050),
        flexibleSpace: SafeArea(
            child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: const Text(
            'Profile',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  //Background Profile
                  Column(
                    children: List.generate(
                        2,
                        (x) => Expanded(
                              child: Container(
                                  color: [
                                const Color.fromRGBO(239, 243, 246, 0.48),
                                Colors.white
                              ][x]),
                            )),
                  ),
                  //Avatar Profile
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        clipBehavior: Clip.hardEdge,
                        foregroundDecoration: BoxDecoration(
                            border: Border.all(width: 10, color: Colors.white),
                            shape: BoxShape.circle),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xff1EA050)),
                        child: FutureBuilder(
                            builder: (context, snapshot) => snapshot.hasData
                                ? Image.network(
                                    (snapshot.data as List)[0]['picture']
                                        ['large'],
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(),
                            future: data),
                      ),
                      FutureBuilder(
                          builder: (context, snapshot) => Text(
                              snapshot.hasData
                                  ? (snapshot.data as List)[0]['name']
                                          ['first'] +
                                      ' ' +
                                      (snapshot.data as List)[0]['name']['last']
                                  : 'Profile Name',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          future: data)
                    ],
                  )
                ],
              ),
            ),

            //Data Diri Profile Meliputi Username, Email, Phone, Address
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xffF7F9FB),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Column(
                children: List.generate(
                    4,
                    (x) => Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1, color: const Color(0xffEFF3F6))),
                          margin: EdgeInsets.only(
                              left: padding,
                              right: padding,
                              top: x == 0 ? padding : 12.5,
                              bottom: x == 3 ? padding : 0),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/${[
                                  'username',
                                  'email',
                                  'phone',
                                  'address'
                                ][x]}.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 12.5,
                              ),
                              Expanded(
                                  child: FutureBuilder(
                                      builder: (context, snapshot) => Text(
                                          snapshot.hasData
                                              ? [
                                                  (snapshot.data as List)[0]
                                                      ['login']['username'],
                                                  (snapshot.data as List)[0]
                                                      ['email'],
                                                  (snapshot.data as List)[0]
                                                      ['phone'],
                                                  (snapshot.data as List)[0]
                                                          ['location']['city'] +
                                                      '\n' +
                                                      (snapshot.data as List)[0]
                                                              ['location']
                                                          ['state'] +
                                                      ' -' +
                                                      (snapshot.data as List)[0]
                                                                  ['location']
                                                              ['postcode']
                                                          .toString(),
                                                ][x]
                                              : [
                                                  'Username',
                                                  'E-Mail',
                                                  'Phone',
                                                  'Address'
                                                ][x],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      future: data))
                            ],
                          ),
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
