import 'package:agendacontatos/methods_db.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

// Obter todos os dados da DataBase
  void _refreshData() async {
    final data = await SQLMethod.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

// Adicionar dados
  Future<void> _addData() async {
    await SQLMethod.createData(
        _nomeController.text, _telefoneController.text, _emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        "Contato Criado!",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ));
    _refreshData();
  }

// Atualizar dados
  Future<void> _updateData(int id) async {
    await SQLMethod.updateData(id, _nomeController.text,
        _telefoneController.text, _emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        "Contato Atualizado!",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ));
    _refreshData();
  }

// Deletar dados
  void _deleteData(int id) async {
    await SQLMethod.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        "Contato Deletado!",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ));
    _refreshData();
  }

// Caixa de dialogo confirmando exclusão de dados
  void _dialogDeleteData(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "Você tem certeza que deseja excluir esse contato?",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteData(id);
              },
              child: const Text(
                "Excluir",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Controladores de texto/input do usuário
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _registerVerification() async {
    if (_formKey.currentState!.validate()) ;
  }

  void showBottomSheetVisualization(int? id) async {
    if (id == null) {
      _nomeController.clear();
      _telefoneController.clear();
      _emailController.clear();
    } else {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _nomeController.text = existingData['nome'];
      _telefoneController.text = existingData['telefone'];
      _emailController.text = existingData['email'];
    }

    // Visualizar informações de contato ao clicar sobre box
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "INFORMAÇÕES DE CONTATO",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Campos de entradas de Textos com vínculo ao controller/controlador
            // Nome
            const SizedBox(height: 25),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
                hintText: "Digite nome do contato (*)",
              ),
              readOnly: true,
            ),

            // Telefone
            const SizedBox(height: 25),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "Telefone",
                border: OutlineInputBorder(),
                hintText: "Digite o telefone do contato (*)",
              ),
              readOnly: true,
            ),

            // Email
            const SizedBox(height: 25),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "Email",
                border: OutlineInputBorder(),
                hintText: "Digite email do contato",
              ),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheet(int? id) async {
    if (id == null) {
      _nomeController.clear();
      _telefoneController.clear();
      _emailController.clear();
    } else {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _nomeController.text = existingData['nome'];
      _telefoneController.text = existingData['telefone'];
      _emailController.text = existingData['email'];
    }
  
    showModalBottomSheet(
        elevation: 5,
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "CADASTRO DE CONTATO",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // Campos de entradas de Textos com vínculo ao controller/controlador
                    // Nome
                    const SizedBox(height: 25),
                    TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: "Nome",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                          hintText: "Digite nome do contato (*)",
                        ),

                        // Valida se campo está preenchido
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "O nome é obrigatório";
                          }
                          return null;
                        }),

                    // Telefone
                    SizedBox(height: 25),
                    TextFormField(
                        controller: _telefoneController,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Telefone",
                          border: OutlineInputBorder(),
                          hintText: "Digite o telefone do contato (*)",
                        ),
                        keyboardType: TextInputType.phone, 
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "O número é obrigatório";
                          }
                          return null;
                        }),

                    // Email
                    const SizedBox(height: 25),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        hintText: "Digite email do contato",
                      ),
                    ),

                    // Salvar Contato
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_nomeController.text.isEmpty ||
                              _telefoneController.text.isEmpty) {
                            return _registerVerification();
                          } else {
                            if (id == null) {
                              await _addData();
                            }
                            if (id != null) {
                              await _updateData(id);
                            }
                          }
                          _nomeController.clear();
                          _telefoneController.clear();
                          _emailController.clear();

                          Navigator.of(context).pop();
                          print("Salvar Contato");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              id == null ? "Salvar Contato" : "Salvar Contato",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

          void showEditBottomSheet(int? id) async {
              if (id == null) {
                _nomeController.clear();
                _telefoneController.clear();
                _emailController.clear();
              } else {
                final existingData =
                    _allData.firstWhere((element) => element['id'] == id);
                _nomeController.text = existingData['nome'];
                _telefoneController.text = existingData['telefone'];
                _emailController.text = existingData['email'];
              }
            
              showModalBottomSheet(
                  elevation: 5,
                  isScrollControlled: true,
                  context: context,
                  builder: (_) => Container(
                        padding: EdgeInsets.only(
                          top: 30,
                          left: 15,
                          right: 15,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "EDITAR CONTATO",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              // Campos de entradas de Textos com vínculo ao controller/controlador
                              // Nome
                              const SizedBox(height: 25),
                              TextFormField(
                                  controller: _nomeController,
                                  decoration: const InputDecoration(
                                    labelText: "Nome",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(),
                                    hintText: "Digite nome do contato (*)",
                                  ),

                                  // Valida se campo está preenchido
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "O nome é obrigatório";
                                    }
                                    return null;
                                  }),

                              // Telefone
                              SizedBox(height: 25),
                              TextFormField(
                                  controller: _telefoneController,
                                  decoration: const InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: "Telefone",
                                    border: OutlineInputBorder(),
                                    hintText: "Digite o telefone do contato (*)",
                                  ),
                                  keyboardType: TextInputType.phone, 
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "O número é obrigatório";
                                    }
                                    return null;
                                  }),

                              // Email
                              const SizedBox(height: 25),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "Email",
                                  border: OutlineInputBorder(),
                                  hintText: "Digite email do contato",
                                ),
                              ),

                              // Salvar Contato
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_nomeController.text.isEmpty ||
                                        _telefoneController.text.isEmpty) {
                                      return _registerVerification();
                                    } else {
                                      if (id == null) {
                                        await _addData();
                                      }
                                      if (id != null) {
                                        await _updateData(id);
                                      }
                                    }
                                    _nomeController.clear();
                                    _telefoneController.clear();
                                    _emailController.clear();

                                    Navigator.of(context).pop();
                                    print("Salvar Edição");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                        id == null ? "Salvar Edição" : "Salvar Edição",
                                        style: const TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
            }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 154, 154),
      appBar: AppBar(
        title: const Text(
          "AGENDA DE CONTATOS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          // Box do Contato
          : ListView.builder(
              itemCount: _allData.length,
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(5),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      _allData[index]['nome'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    _allData[index]['telefone'],
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // botão de editar
                      IconButton(
                        onPressed: () {
                          showEditBottomSheet(_allData[index]['id']);
                        },
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                      ),
                      // botão de deletar
                      IconButton(
                        onPressed: () {
                          _dialogDeleteData(_allData[index]['id']);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    showBottomSheetVisualization(_allData[index]['id']);
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: const Icon(Icons.person_add,
            size: 50, color: Color.fromARGB(255, 78, 0, 0)),
      ),
    );
  }
}
