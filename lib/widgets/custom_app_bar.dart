import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String tituloPagina;
  final bool mostrarSeta;
  final VoidCallback? aoClicarSeta;

  const CustomAppBar({
    super.key,
    required this.tituloPagina,
    this.mostrarSeta = false,
    this.aoClicarSeta,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pinkAccent,
      elevation: 0,
      leading: mostrarSeta
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: aoClicarSeta,
      )
          : null,
      title: Text(
        tituloPagina,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}