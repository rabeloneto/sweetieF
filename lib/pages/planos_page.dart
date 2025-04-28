import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
//está pagina tambem ainda nao está comcluida, a ideia é terminar o sistema de login primeiro para depois finalizala
class PlanosPage extends StatefulWidget {
  const PlanosPage({super.key});

  @override
  State<PlanosPage> createState() => _PlanosPageState();
}

class _PlanosPageState extends State<PlanosPage> {
  int _selecionado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(tituloPagina: 'Planos'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha a opção ideal e encontre mais clientes!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agora mesmo\nFaça seu anúncio ficar mais visível.\nAumente as chances de vender mais rápido.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            _planoCard(
              index: 0,
              title: 'Plano Gratuito',
              preco: 'R\$ 0,00',
              descricao: '• Anúncio padrão.',
              cor: Colors.green,
            ),

            _planoCard(
              index: 1,
              title: 'Renovação Prata',
              preco: '3x R\$5,33\nR\$ 15,99 à vista',
              descricao: '3 voltas ao topo durante 7 dias\n7 dias com selo destaque',
              cor: Colors.blueGrey,
            ),

            Stack(
              children: [
                _planoCard(
                  index: 2,
                  title: 'Renovação Ouro',
                  preco: '3x R\$7,33\nR\$ 21,99 à vista',
                  descricao: '5 voltas ao topo durante 7 dias\n7 dias na Galeria',
                  cor: Colors.yellow.shade700,
                ),
                const Positioned(
                  top: 60,
                  right: 12,
                  child: Chip(
                    backgroundColor: Color(0xFFEDE7F6),
                    label: Text('Recomendado',
                        style: TextStyle(color: Colors.pinkAccent, fontSize: 12)),
                  ),
                )
              ],
            ),],
        ),
      ),
    );
  }

  Widget _planoCard({
    required int index,
    required String title,
    required String preco,
    required String descricao,
    required Color cor,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selecionado = index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selecionado == index
                ? Colors.pinkAccent
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio(
              value: index,
              groupValue: _selecionado,
              activeColor: Colors.pinkAccent,
              onChanged: (value) {
                setState(() => _selecionado = index);
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(preco, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(descricao,
                      style:
                      const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: cor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
