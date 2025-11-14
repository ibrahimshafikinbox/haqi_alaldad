// import 'package:flutter/material.dart';
// import 'package:store_mangment/Feature/customer_section/Customer_cart/cart.dart';
// import 'package:store_mangment/Feature/customer_section/Customer_categories/View/customer_catregories.dart';
// import 'package:store_mangment/Feature/customer_section/cutomer_home/View/cutomer_home.dart';
// import 'package:store_mangment/Feature/settings/settings_view.dart';

// class CustomerMainView extends StatefulWidget {
//   const CustomerMainView({super.key});

//   @override
//   _CustomerMainViewState createState() => _CustomerMainViewState();
// }

// class _CustomerMainViewState extends State<CustomerMainView> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     CustomerHomeView(),
//     CustomerCategoriesView(),
//     CartScreen(),
//     const SettingsView(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
//             height: 70,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 5,
//                   spreadRadius: 1,
//                   offset: Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       Icons.home,
//                       color: _selectedIndex == 0 ? Colors.blue : Colors.black26,
//                     ),
//                     onPressed: () => _onItemTapped(0),
//                   ),
//                   // IconButton(
//                   //   icon: Icon(Icons.storefront,
//                   //       color:
//                   //           _selectedIndex == 1 ? Colors.blue : Colors.black26),
//                   //   onPressed: () => _onItemTapped(1),
//                   // ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.shopping_cart_checkout_outlined,
//                       color: _selectedIndex == 2 ? Colors.blue : Colors.black26,
//                     ),
//                     onPressed: () => _onItemTapped(2),
//                   ),
//                   IconButton(
//                     icon: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                         "https://cdn-front.freepik.com/images/ai/image-generator/gallery/pikaso-woman.webp",
//                       ),
//                       radius: 16,
//                     ),
//                     onPressed: () => _onItemTapped(3),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:store_mangment/Feature/customer_section/Customer_cart/cart.dart';
import 'package:store_mangment/Feature/customer_section/cutomer_home/View/cutomer_home.dart';
import 'package:store_mangment/Feature/offers/view/user_offers.dart';
import 'package:store_mangment/Feature/settings/settings_view.dart';

class CustomerMainView extends StatefulWidget {
  const CustomerMainView({super.key});

  @override
  _CustomerMainViewState createState() => _CustomerMainViewState();
}

class _CustomerMainViewState extends State<CustomerMainView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    CustomerHomeView(), // index 0: الرئيسية
    UserOffers(), // index 1: العروض
    CartScreen(), // index 2: السلة
    SettingsView(), // index 3: الإعدادات
  ];

  void _onItemTapped(int index) {
    // تحقق أمان: لا تسمح بفهرس خارج النطاق
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex], // ← الآن آمن: _selectedIndex دائمًا 0-3
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // فضاء متساوٍ بين 4 أزرار
                children: [
                  // الزر الأول: الرئيسية (index 0)
                  IconButton(
                    icon: Icon(
                      Icons.home_outlined,
                      color: _selectedIndex == 0
                          ? Colors.deepPurpleAccent
                          : Colors.black26,
                    ),
                    onPressed: () => _onItemTapped(0),
                  ),

                  // الزر الثاني: العروض (index 1)
                  IconButton(
                    icon: Icon(
                      Icons.local_offer_outlined,
                      color: _selectedIndex == 1
                          ? Colors.deepPurpleAccent
                          : Colors.black26,
                    ),
                    onPressed: () => _onItemTapped(1), // ← أصلح: كان 2، الآن 1
                  ),

                  // الزر الثالث: السلة (index 2)
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_checkout_outlined,
                      color: _selectedIndex == 2
                          ? Colors.deepPurpleAccent
                          : Colors.black26,
                    ),
                    onPressed: () => _onItemTapped(2), // ← أصلح: كان 3، الآن 2
                  ),

                  // الزر الرابع: الإعدادات (index 3)
                  IconButton(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: _selectedIndex == 3
                          ? Colors.deepPurpleAccent
                          : Colors.black26,
                    ),
                    onPressed: () => _onItemTapped(3), // ← أصلح: كان 4، الآن 3
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
