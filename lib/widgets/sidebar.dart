import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 70,
      child: Container(
        margin: const EdgeInsets.only(top: kToolbarHeight), // Start below AppBar
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[200]!, Colors.grey[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildMenuItem(
              context,
              icon: Icons.home,
              tooltip: 'Dashboard',
              route: '/dashboard',
            ),
            _buildMenuItemWithChildren(
              context,
              icon: MdiIcons.cog,
              tooltip: 'System Management',
              children: [
                // {'title': 'Branches', 'route': '/branches'},
                {'title': 'Departments', 'route': '/departments'},
              ],
            ),
            _buildMenuItemWithChildren(
              context,
              icon: MdiIcons.truck,
              tooltip: 'Courier Management',
              children: [
                // {'title': 'Parcel Items', 'route': '/parcels'},
                {'title': 'Vehicles', 'route': '/vehicles'},
              ],
            ),
            const Spacer(),
            _buildCloseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon, required String tooltip, required String route}) {
    return Tooltip(
      message: tooltip,
      textStyle: const TextStyle(
        fontSize: 14,
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5F368D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: IconButton(
          icon: Icon(icon, color: const Color(0xFF5F368D), size: 28),
          tooltip: tooltip,
          onPressed: () {
            Navigator.pushReplacementNamed(context, route); // Use pushReplacementNamed for Dashboard
          },
        ),
      ),
    );
  }

  Widget _buildMenuItemWithChildren(BuildContext context,
      {required IconData icon,
      required String tooltip,
      required List<Map<String, String>> children}) {
    return Tooltip(
      message: tooltip,
      textStyle: const TextStyle(
        fontSize: 14,
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5F368D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(icon, color: const Color(0xFF5F368D), size: 28),
        onSelected: (route) {
          Navigator.pushNamed(context, route);
        },
        itemBuilder: (context) => children
            .map(
              (child) => PopupMenuItem<String>(
                value: child['route'],
                child: Text(
                  child['title']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    color: Color(0xFF5F368D),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Tooltip(
      message: 'Close Sidebar',
      textStyle: const TextStyle(
        fontSize: 14,
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5F368D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF5F368D), size: 28),
          onPressed: () {
            Scaffold.of(context).closeDrawer();
          },
        ),
      ),
    );
  }
}