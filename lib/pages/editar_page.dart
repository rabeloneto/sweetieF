import 'package:flutter/material.dart';
// importa o banco de dados
import '../database/db_helper.dart';
// importa a app bar personalizada
import '../widgets/custom_app_bar.dart';

// cria a tela Editar
class EditarPage extends StatefulWidget {
  const EditarPage({super.key});

  @override
  State<EditarPage> createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {
  // Lista que vai guardar as lojas
  List<Map<String, dynamic>> lojas = [];

  // aqui salva os produtos de cada loja separadinho
  Map<int, List<Map<String, dynamic>>> produtosPorLoja = {};

  //controla se o formulario da loja ta aparecendo ou não
  bool mostrarFormularioLoja = false;

  // controladores pra pegar o que o usuario digita
  final _nomeCtrl = TextEditingController();
  final _localCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _longCtrl = TextEditingController();

  // id da loja
  int? lojaEditandoId;

  // controladores para os produtos
  final Map<int, Map<String, TextEditingController>> produtoCtrls = {};
  final Map<int, int?> produtoEditandoId = {};

  @override
  void initState() {
    super.initState();
    _carregarDados(); // chama pra puxar os dados do banco quando a tela abre
  }

  // carrega lojas e produtos do banco
  Future<void> _carregarDados() async {
    final db = await DBHelper.database;
    lojas = await db.query('lojas');
    produtosPorLoja.clear();

    for (var loja in lojas) {
      final lojaId = loja['id'];
      final produtos = await db.query('produtos', where: 'lojaId = ?', whereArgs: [lojaId]);
      produtosPorLoja[lojaId] = produtos;

      // cria os controladores para preencher depois
      produtoCtrls[lojaId] = {
        'nome': TextEditingController(),
        'descricao': TextEditingController(),
        'preco': TextEditingController(),
        'imagens': TextEditingController(),
      };
      produtoEditandoId[lojaId] = null;
    }

    setState(() {}); // atualiza a tela
  }

  // preenche o formulario com os dados da loja
  void _preencherFormularioLoja(Map<String, dynamic> loja) {
    lojaEditandoId = loja['id'];
    _nomeCtrl.text = loja['nome'];
    _localCtrl.text = loja['localizacao'];
    _imgCtrl.text = loja['imagem'];
    _telCtrl.text = loja['telefone'] ?? '';
    _latCtrl.text = loja['latitude'].toString();
    _longCtrl.text = loja['longitude'].toString();
    setState(() => mostrarFormularioLoja = true);
  }

  // salva uma nova loja ou atualiza uma loja ja criada
  Future<void> _salvarLoja() async {
    try {
      final db = await DBHelper.database;
      final dados = {
        'nome': _nomeCtrl.text,
        'localizacao': _localCtrl.text,
        'imagem': _imgCtrl.text,
        'telefone': _telCtrl.text,
        'latitude': double.tryParse(_latCtrl.text),
        'longitude': double.tryParse(_longCtrl.text),
      };

      if (lojaEditandoId == null) {
        await db.insert('lojas', dados); // cria nova loja
      } else {
        await db.update('lojas', dados, where: 'id = ?', whereArgs: [lojaEditandoId]); // atualiza loja existente
      }

      _limparFormularioLoja();
      await _carregarDados();
    } catch (e) {
      print('Erro ao salvar loja: $e');
    }
  }

  // limpa o formulario de loja
  void _limparFormularioLoja() {
    lojaEditandoId = null;
    mostrarFormularioLoja = false;
    _nomeCtrl.clear();
    _localCtrl.clear();
    _imgCtrl.clear();
    _telCtrl.clear();
    _latCtrl.clear();
    _longCtrl.clear();
  }

  // deleta a loja
  Future<void> _deletarLoja(int id) async {
    final db = await DBHelper.database;
    await db.delete('produtos', where: 'lojaId = ?', whereArgs: [id]);
    await db.delete('lojas', where: 'id = ?', whereArgs: [id]);
    await _carregarDados();
  }

  // salva ou edita um produto novo
  Future<void> _salvarProduto(int lojaId) async {
    final db = await DBHelper.database;
    final ctrls = produtoCtrls[lojaId]!;

    final dados = {
      'lojaId': lojaId,
      'nome': ctrls['nome']!.text,
      'descricao': ctrls['descricao']!.text,
      'preco': double.tryParse(ctrls['preco']!.text),
      'imagens': ctrls['imagens']!.text,
    };

    final editId = produtoEditandoId[lojaId];
    if (editId == null) {
      await db.insert('produtos', dados);
    } else {
      await db.update('produtos', dados, where: 'id = ?', whereArgs: [editId]);
    }

    // limpa os campos dos produtos
    ctrls.forEach((_, c) => c.clear());
    produtoEditandoId[lojaId] = null;

    await _carregarDados();
  }

  // deleta um produto do banco
  Future<void> _deletarProduto(int id) async {
    final db = await DBHelper.database;
    await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
    await _carregarDados();
  }

  // preenche o formulario pra editar o produto
  void _editarProduto(Map<String, dynamic> produto, int lojaId) {
    final ctrls = produtoCtrls[lojaId]!;
    ctrls['nome']!.text = produto['nome'];
    ctrls['descricao']!.text = produto['descricao'];
    ctrls['preco']!.text = produto['preco'].toString();
    ctrls['imagens']!.text = produto['imagens'] ?? '';
    produtoEditandoId[lojaId] = produto['id'];
    setState(() {});
  }

  // aqui começa o layout da página
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(tituloPagina: 'Editar'), // nossa app bar personalizada
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              // botão pra mostrar ou esconder o formulario de loja
              onPressed: () => setState(() => mostrarFormularioLoja = !mostrarFormularioLoja),
              child: Text(mostrarFormularioLoja ? 'Cancelar' : 'Nova Loja'),
            ),
            if (mostrarFormularioLoja)
              Card(
                // formulario para adicionar/editar loja
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(controller: _nomeCtrl, decoration: const InputDecoration(labelText: 'Nome')),
                      TextFormField(controller: _localCtrl, decoration: const InputDecoration(labelText: 'Localização')),
                      TextFormField(controller: _telCtrl, decoration: const InputDecoration(labelText: 'Telefone')),
                      TextFormField(controller: _imgCtrl, decoration: const InputDecoration(labelText: 'Imagem (URL)')),
                      TextFormField(controller: _latCtrl, decoration: const InputDecoration(labelText: 'Latitude')),
                      TextFormField(controller: _longCtrl, decoration: const InputDecoration(labelText: 'Longitude')),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _salvarLoja,
                        child: Text(lojaEditandoId == null ? 'Cadastrar' : 'Salvar Alterações'),
                      ),
                    ],
                  ),
                ),
              ),
            const Divider(),
            // aqui ele lista todas as lojas
            ...lojas.map((loja) {
              final id = loja['id'];
              final produtos = produtosPorLoja[id] ?? [];
              final ctrls = produtoCtrls[id]!;

              return Card(
                color: Colors.grey.shade100,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(loja['nome'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(loja['localizacao']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _preencherFormularioLoja(loja)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => _deletarLoja(id)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // campos pra adicionar novo produto
                      TextFormField(controller: ctrls['nome'], decoration: const InputDecoration(labelText: 'Nome do Produto')),
                      TextFormField(controller: ctrls['descricao'], decoration: const InputDecoration(labelText: 'Descrição')),
                      TextFormField(controller: ctrls['preco'], decoration: const InputDecoration(labelText: 'Preço')),
                      TextFormField(controller: ctrls['imagens'], decoration: const InputDecoration(labelText: 'Imagens (URLs separados por vírgula)')),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _salvarProduto(id),
                        child: Text(produtoEditandoId[id] == null ? 'Adicionar Produto' : 'Salvar Produto'),
                      ),
                      const SizedBox(height: 8),
                      // lista todos os produtos da loja
                      ...produtos.map((p) => ListTile(
                        title: Text(p['nome']),
                        subtitle: Text(p['descricao']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _editarProduto(p, id)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => _deletarProduto(p['id'])),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
