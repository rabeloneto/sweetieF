import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class CarrosselItem {
  final Color background;
  final IconData icon;
  final String texto;

  CarrosselItem({
    required this.background,
    required this.icon,
    required this.texto,
  });
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _carrossel1 = 0;
  int _carrossel2 = 0;
  int _carrossel3 = 0;
  int _carrossel4 = 0;
  int _carrossel5 = 0;

  final List<CarrosselItem> _netDanger = [
    CarrosselItem(background: Colors.orange.shade200, icon: Icons.ad_units_outlined, texto: 'Perigos de Compras Online'),
    CarrosselItem(background: Colors.orange, icon: Icons.ad_units_outlined, texto: 'Informações de como nao cair em esquemas'),
    CarrosselItem(background: Colors.orange.shade400, icon: Icons.ad_units_outlined, texto: 'Como deve ser a abordagem online'),
    CarrosselItem(background: Colors.orange.shade500, icon: Icons.ad_units_outlined, texto: 'Cuidado com seus dados'),
  ];

  final List<CarrosselItem> _osMelhores = [
    CarrosselItem(background: Colors.blue.shade100, icon: Icons.star, texto: 'Fulano'),
    CarrosselItem(background: Colors.blue.shade200, icon: Icons.star, texto: 'Cicrano'),
    CarrosselItem(background: Colors.blue.shade300, icon: Icons.star, texto: 'Zé'),
    CarrosselItem(background: Colors.blue.shade400, icon: Icons.star, texto: 'Cicraninho'),
  ];

  final List<CarrosselItem> _novos = [
    CarrosselItem(background: Colors.green.shade100, icon: Icons.arrow_circle_up, texto: 'Enzo'),
    CarrosselItem(background: Colors.green.shade200, icon: Icons.arrow_circle_up, texto: 'Valentina'),
    CarrosselItem(background: Colors.green.shade300, icon: Icons.arrow_circle_up, texto: 'Noah'),
    CarrosselItem(background: Colors.green.shade400, icon: Icons.arrow_circle_up, texto: 'New'),
  ];

  final List<CarrosselItem> _confia = [
    CarrosselItem(background: Colors.purple.shade100, icon: Icons.safety_check, texto: 'José'),
    CarrosselItem(background: Colors.purple.shade200, icon: Icons.safety_check, texto: 'João'),
    CarrosselItem(background: Colors.purple.shade300, icon: Icons.safety_check, texto: 'Maria'),
    CarrosselItem(background: Colors.purple.shade400, icon: Icons.safety_check, texto: 'Zé'),
  ];

  final List<CarrosselItem> _events = [
    CarrosselItem(background: Colors.red.shade100, icon: Icons.event, texto: 'Kit Festa'),
    CarrosselItem(background: Colors.red.shade200, icon: Icons.event, texto: 'Cestas Promocionais'),
    CarrosselItem(background: Colors.red.shade300, icon: Icons.event, texto: 'Presentes Personalizados'),
    CarrosselItem(background: Colors.red.shade400, icon: Icons.event, texto: 'Combos Familiares'),
  ];

  void _trocar1() => setState(() => _carrossel1 = (_carrossel1 + 1) % _netDanger.length);
  void _trocar2() => setState(() => _carrossel2 = (_carrossel2 + 1) % _osMelhores.length);
  void _trocar3() => setState(() => _carrossel3 = (_carrossel3 + 1) % _novos.length);
  void _trocar4() => setState(() => _carrossel4 = (_carrossel4 + 1) % _confia.length);
  void _trocar5() => setState(() => _carrossel5 = (_carrossel5 + 1) % _events.length);

  Widget _carrossel({
    required VoidCallback onTap,
    required CarrosselItem item,
    required int ativo,
    required int totalPaginas,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: item.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 48, color: Colors.white),
                const SizedBox(height: 8),
                Text(item.texto, style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            Positioned(
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPaginas, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ativo == i
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(tituloPagina: 'Página Inicial'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.pinkAccent),
                  SizedBox(width: 4),
                  Text('Paraíba', style: TextStyle(color: Colors.pinkAccent)),
                ],
              ),
            ),

            _carrossel(onTap: _trocar1, item: _netDanger[_carrossel1], ativo: _carrossel1, totalPaginas: _netDanger.length),
            _carrossel(onTap: _trocar2, item:  _osMelhores[_carrossel2], ativo: _carrossel2, totalPaginas: _osMelhores.length),
            _carrossel(onTap: _trocar3, item: _novos[_carrossel3], ativo: _carrossel3, totalPaginas: _novos.length),
            _carrossel(onTap: _trocar4, item:  _confia[_carrossel4], ativo: _carrossel4, totalPaginas: _confia.length),
            _carrossel(onTap: _trocar5, item:  _events[_carrossel5], ativo: _carrossel5, totalPaginas: _events.length),
          ],
        ),
      ),

    );
  }
}
