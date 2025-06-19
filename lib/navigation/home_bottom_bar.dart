import 'package:flutter/material.dart';
import 'package:trabalhos_academicos/model/universitario.dart';
import 'package:trabalhos_academicos/screens/api/api_screen.dart';
import 'package:trabalhos_academicos/screens/local/local_screen.dart';

class HomeBottomNavScreen extends StatefulWidget {
  final Universitario universitario; 

  const HomeBottomNavScreen({super.key, required this.universitario});

  @override
  State<HomeBottomNavScreen> createState() => _HomeBottomNavScreenState();
}

class _HomeBottomNavScreenState extends State<HomeBottomNavScreen> {
  int _paginaAtual = 0;
  late List<Widget> _telas;

  @override
  void initState() {
    super.initState();

    _telas = [
      ApiScreen(universitario: widget.universitario),
      const LocalScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: (index) {
          setState(() => _paginaAtual = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Via API',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Local (SQLite)',
          ),
        ],
      ),
    );
  }
}
