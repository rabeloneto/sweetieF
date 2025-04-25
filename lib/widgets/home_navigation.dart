import 'package:flutter/material.dart';
import '../pages/feed_page.dart';
import '../pages/planos_page.dart';
import '../pages/mensagens_page.dart';
import '../pages/editar_page.dart';
import '../pages/buscar_page.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _paginaAtual = 0;

  final List<Widget> _paginas = [
    const FeedPage(),
    const BuscarPage(),
    const EditarPage(),
    const MensagensPage(),
    const PlanosPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Editar'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mensagens'),
          BottomNavigationBarItem(icon: Icon(Icons.card_membership), label: 'Planos'),
        ],
      ),
    );
  }
}
