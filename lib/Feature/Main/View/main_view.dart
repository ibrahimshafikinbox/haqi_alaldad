import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:store_mangment/Core/Localizations/app_localizatios.dart';
import 'package:store_mangment/Feature/Home/View/home_view.dart';
import 'package:store_mangment/Feature/Main/Cubit/maion_cubit.dart';
import 'package:store_mangment/Feature/Orders/View/orders_view.dart';
import 'package:store_mangment/Feature/customers/view/customer_list.dart';
import 'package:store_mangment/Feature/resources/colors/colors.dart';
import 'package:store_mangment/Feature/settings/settings_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<BottomNavCubit, int>(
          builder: (context, state) {
            return Center(child: _getPage(state));
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CurvedNavigationBar(
                  index: state,
                  height: 70.0,
                  items: <Widget>[
                    _buildNavItem(
                      Icons.home,
                      loc.translate('home'),
                      state == 0,
                    ),
                    _buildNavItem(
                      Icons.shopping_cart,
                      loc.translate('orders'),
                      state == 1,
                    ),
                    _buildNavItem(
                      Icons.people,
                      loc.translate('customers'),
                      state == 2,
                    ),
                    _buildNavItem(
                      Icons.settings,
                      loc.translate('settings'),
                      state == 3,
                    ),
                  ],
                  color: const Color.fromARGB(255, 238, 236, 236),
                  backgroundColor: AppColors.white,
                  buttonBackgroundColor: AppColors.white,
                  animationCurve: Curves.easeInSine,
                  animationDuration: const Duration(milliseconds: 350),
                  onTap: (index) {
                    context.read<BottomNavCubit>().updateIndex(index);
                  },
                  letIndexChange: (index) => true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Helper method to build navigation bar items dynamically
  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isSelected ? AppColors.black : Colors.black),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.black : Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return OrdersView();
      case 2:
        return CustomerListScreen();
      case 3:
        return const SettingsView();
      default:
        return const HomeView();
    }
  }
}
