import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
// Essa pagina está mockada, sera uma implementação futura que recebera os dados do banco do usario ques ta logado,
//A ideia é concluir ela depois que o sistema de login estiver funcionando
class MensagensPage extends StatefulWidget {
  const MensagensPage({super.key});

  @override
  State<MensagensPage> createState() => _MensagensPageState();
}

class _MensagensPageState extends State<MensagensPage> {
  final TextEditingController _mensagemController = TextEditingController();

  final List<Map<String, String>> listaUsuarios = [
    {'nome': 'Ana Confeiteira', 'email': 'ana@doces.com'},
    {'nome': 'João Bolo', 'email': 'joao@bolo.com'},
  ];

  final Map<String, List<Map<String, String>>> mensagensMock = {
    'Ana Confeiteira': [
      {'autor': 'Ana', 'conteudo': 'Olá! Gostaria de fazer um pedido.'},
      {'autor': 'Você', 'conteudo': 'Claro! Qual doce você quer?'},
    ],
    'João Bolo': [
      {'autor': 'João', 'conteudo': 'Você faz bolo de pote?'},
      {'autor': 'Você', 'conteudo': 'Faço sim! Tem preferência de sabor?'},
    ],
  };

  String? usuarioSelecionado;
  bool mostrandoConversa = false;

  void _enviarMensagem(String texto) {
    if (usuarioSelecionado == null || texto.isEmpty) return;
    setState(() {
      mensagensMock[usuarioSelecionado]!.add({
        'autor': 'Você',
        'conteudo': texto,
      });
      _mensagemController.clear();
    });
  }

  void _voltarParaLista() {
    setState(() {
      mostrandoConversa = false;
      usuarioSelecionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        tituloPagina: mostrandoConversa ? usuarioSelecionado ?? 'Conversa' : 'Mensagens',
        mostrarSeta: mostrandoConversa,
        aoClicarSeta: _voltarParaLista,
      ),
      body: mostrandoConversa ? _telaConversa() : _listaDeUsuarios(),
    );
  }

  Widget _listaDeUsuarios() => ListView.builder(
    itemCount: listaUsuarios.length,
    itemBuilder: (_, i) {
      final usuario = listaUsuarios[i];
      return ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(usuario['nome']!),
        subtitle: Text(usuario['email']!),
        trailing: const Text('ATIVO', style: TextStyle(color: Colors.pinkAccent)),
        onTap: () {
          setState(() {
            mostrandoConversa = true;
            usuarioSelecionado = usuario['nome'];
          });
        },
      );
    },
  );

  Widget _telaConversa() {
    final mensagens = mensagensMock[usuarioSelecionado] ?? [];
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mensagens.length,
            itemBuilder: (_, i) {
              final msg = mensagens[i];
              final enviadoPorMim = msg['autor'] == 'Você';

              return Align(
                alignment: enviadoPorMim ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: enviadoPorMim ? Colors.pinkAccent.withOpacity(0.8) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    msg['conteudo']!,
                    style: TextStyle(color: enviadoPorMim ? Colors.white : Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
        _campoEnvioMensagem(),
      ],
    );
  }

  Widget _campoEnvioMensagem() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    color: Colors.grey.shade100,
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _mensagemController,
            decoration: InputDecoration(
              hintText: 'Digite sua mensagem...',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.pinkAccent),
          onPressed: () {
            final texto = _mensagemController.text.trim();
            if (texto.isNotEmpty) _enviarMensagem(texto);
          },
        )
      ],
    ),
  );
}
