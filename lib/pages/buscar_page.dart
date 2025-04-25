// ARQUIVO: buscar_page.dart (ATUALIZADO COM CARROSSEL ESTILO FEED)
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../database/db_helper.dart';
import '../widgets/custom_app_bar.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  GoogleMapController? _mapController;
  Set<Marker> _marcadores = {};
  final TextEditingController _buscaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarLojas();
  }

  Future<void> _carregarLojas() async {
    final db = await DBHelper.database;
    final resultado = await db.query('lojas');
    final BitmapDescriptor pinCustom = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);

    final novosMarcadores = resultado.map((loja) {
      final lat = loja['latitude'] as double?;
      final lng = loja['longitude'] as double?;
      final nome = loja['nome'] as String? ?? '';

      if (lat != null && lng != null) {
        return Marker(
          markerId: MarkerId(loja['id'].toString()),
          position: LatLng(lat, lng),
          icon: pinCustom,
          infoWindow: InfoWindow(title: nome),
          onTap: () => _mostrarDetalhesLoja(loja),
        );
      } else {
        return null;
      }
    }).whereType<Marker>().toSet();

    if (!context.mounted) return;
    setState(() {
      _marcadores = novosMarcadores;
    });
  }

  void _mostrarDetalhesLoja(Map<String, dynamic> loja) async {
    final db = await DBHelper.database;
    final produtos = await db.query('produtos', where: 'lojaId = ?', whereArgs: [loja['id']]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text(loja['nome']?.toString() ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(height: 8),
                Text("📍 ${loja['localizacao']?.toString() ?? ''}"),
                Text("📞 ${loja['telefone']?.toString() ?? ''}"),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(loja['imagem']?.toString() ?? '', height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),
                const Text("Produtos:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...produtos.map((p) {
                  final imagensRaw = p['imagens'];
                  final imagens = imagensRaw is String
                      ? imagensRaw.split(',').map((url) => url.trim()).where((e) => e.isNotEmpty).toList()
                      : <String>[];

                  return _carrosselProduto(imagens, p);
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _carrosselProduto(List<String> imagens, Map<String, dynamic> produto) {
    int currentIndex = 0;
    PageController controller = PageController();

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Column(
          children: [
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: controller,
                itemCount: imagens.length,
                onPageChanged: (index) => setModalState(() => currentIndex = index),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(imagens[index], width: double.infinity, height: 220, fit: BoxFit.cover),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(produto['nome']?.toString() ?? '', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(produto['descricao']?.toString() ?? '', style: const TextStyle(color: Colors.white)),
                            Text("R\$ ${produto['preco']?.toString() ?? '0.00'}", style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(imagens.length, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == i ? Colors.pinkAccent : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Future<void> _irParaLocal() async {
    final texto = _buscaCtrl.text;
    if (texto.isEmpty || _mapController == null) return;

    try {
      List<Location> locations = await locationFromAddress(texto);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(loc.latitude, loc.longitude)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Local não encontrado")));
      }
    } catch (e) {
      print("Erro ao buscar localização: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao buscar localização")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(tituloPagina: 'Buscar'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buscaCtrl,
                    decoration: InputDecoration(
                      hintText: 'Buscar localização',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.my_location, color: Colors.pinkAccent),
                  onPressed: _irParaLocal,
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-7.1195, -34.845),
                zoom: 13,
              ),
              markers: _marcadores,
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),
        ],
      ),
    );
  }
}
