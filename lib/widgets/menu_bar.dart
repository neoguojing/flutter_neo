import 'package:flutter/material.dart';
import 'package:flutter_neo/features/home/ui/home_page.dart';
import 'package:flutter_neo/features/diversified_investment/ui/diversified_investment_page.dart';
import 'package:flutter_neo/features/fixed_investment/ui/fixed_investment_page.dart';
import 'package:flutter_neo/features/profile/ui/profile_page.dart';
import 'package:flutter_neo/features/settings/ui/settings_page.dart';

class AppMenuBar extends StatelessWidget {
  const AppMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMenuItem(context, '首页', Icons.home, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }),
          PopupMenuButton<String>(
            tooltip: '投资',
            child: const Row(
              children: [
                Icon(Icons.account_balance_wallet, size: 20),
                SizedBox(width: 8),
                Text('投资'),
              ],
            ),
            onSelected: (String result) {
              switch (result) {
                case '分散投资':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiversifiedInvestmentPage()),
                  );
                  break;
                case '定投计划':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FixedInvestmentPage()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: '分散投资',
                child: Text('分散投资'),
              ),
              const PopupMenuItem(
                value: '定投计划',
                child: Text('定投计划'),
              ),
            ],
          ),
          _buildMenuItem(context, '个人中心', Icons.person, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }),
          _buildMenuItem(context, '设置', Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
