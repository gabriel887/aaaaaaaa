import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;

List<Musica>? todasMusicas;
AudioPlayer player = AudioPlayer();
User? usuarioLogado;

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho Honorato',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const Scaffold(
          body: SafeArea(
            child: TelaLogin(),
          )
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaPrincipal(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
    );
  }
}

User? pegaUsuario(String? login, String? senha){
  User? retorno = null;
  Future.delayed(Duration.zero, () async {
    var url = Uri.https('muzzik.000webhostapp.com', '/usuario/listarUsuario.php', {'busca': ' '});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      if(response.body != "\"\""){
        List jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
        List<User> usuarios =[];
        usuarios =jsonResponse.cast<User>();
        retorno = usuarios.first;
      }
      else{
        retorno = null;
      }
    } else {
      retorno = null;
    }
  });
  return retorno;
}

class TelaPrincipal extends StatefulWidget {
  TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int currentPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color.fromARGB(255, 0, 27, 60),
        title: const Text("Muzzik", style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Color.fromARGB(255, 0, 27, 60),
        indicatorColor: Colors.greenAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.folder),
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_copy),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
          color: Color.fromARGB(255, 0, 48, 124),
          alignment: Alignment.topLeft,
          child: Column(children: [
            DivMusicaListagem(
                musica: Musica(
                    "assets/imagens/musica.jpg",
                    "Carve your name",
                    "Artista: Mother Mother",
                    "musics/Oleander_Mother_Mother.mp3",
                    false, player)),
            DivMusicaListagem(
                musica: Musica(
                    "assets/imagens/musica2.jpg",
                    "Oleander",
                    "Artista: Mother Mother",
                    "musics/Carve_A_Name_mother_mother.mp3",
                    false, player)),
            DivMusicaListagem(
                musica: Musica(
                    "assets/imagens/musica.jpg",
                    "Kryptonite",
                    "Artista: 3 doors down",
                    "musics/Oleander_Mother_Mother.mp3",
                    false, player)),
            DivMusicaListagem(
                musica: Musica(
                    "assets/imagens/musica2.jpg",
                    "Under my skin",
                    "Artista: Jukebox the gost",
                    "musics/Carve_A_Name_mother_mother.mp3",
                    false, player)),
          ]),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text('Page 2'),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text('Page3'),
        ),
      ][currentPageIndex],
    );
  }
}


class DivMusicaListagem extends StatefulWidget {
  DivMusicaListagem({super.key, required this.musica});

  final Musica musica;
  @override
  State<DivMusicaListagem> createState() => _DivMusicaListagem();
}

class _DivMusicaListagem extends State<DivMusicaListagem>{
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DivMusica(musica: widget.musica)),
          );
        },
        child: Column(children: [
          Row(children: [
              Image(
                image: AssetImage(widget.musica.coverMusic),
                width: 48,
                height: 48,
                repeat: ImageRepeat.noRepeat,
                alignment: Alignment.center,
                matchTextDirection: true,
              ),
              Container(width: (width * 0.5),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical:5.0),
                          child: Text(widget.musica.nameMusic, style: TextStyle(color: Colors.white))),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Text(widget.musica.textMusic, style: TextStyle(color: Colors.white))),
                    ],
                  )
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Future.delayed(Duration.zero, () async {
                          if (widget.musica.tocandoMusica!) {
                            await widget.musica.player.play(AssetSource(
                                widget.musica.urlMusic));
                          } else {
                            await widget.musica.player.pause();
                          }
                        });
                        widget.musica.tocandoMusica =
                        !widget.musica.tocandoMusica;
                      });
                    },
                    icon: Icon(
                      // <-- Icon
                      widget.musica.tocandoMusica
                          ? Icons.pause_circle_filled_outlined
                          : Icons.play_circle_fill_outlined,
                      size: 26.0,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ],
          )
        ]));
  }
}

class DivMusica extends StatefulWidget {
  DivMusica({super.key, required this.musica});


  Musica musica;
  @override
  State<DivMusica> createState() => _DivMusica();
}

class _DivMusica extends State<DivMusica> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 48, 124),
        title: const Text("Muzzik", style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Color.fromARGB(255, 0, 27, 60),
        indicatorColor: Colors.greenAccent,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.folder),
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_copy),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color.fromARGB(255, 0, 48, 124),
        padding: const EdgeInsets.only(top: 90.0),
        child: Column(children: [
          Container(
              width: 250.0,
              height: 250.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(widget.musica.coverMusic)))),
          Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Text(
                widget.musica.nameMusic,
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      // <-- Icon
                      Icons.arrow_back_ios_new_outlined,
                      size: 48.0,
                      color: Colors.greenAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Future.delayed(Duration.zero, () async {
                          if (widget.musica.tocandoMusica) {
                            await widget.musica.player.play(AssetSource(
                                widget.musica.urlMusic));
                          } else {
                            await widget.musica.player.pause();
                          }
                        });
                        widget.musica.tocandoMusica =
                            !widget.musica.tocandoMusica;
                      });
                    },
                    icon: Icon(
                      // <-- Icon
                      widget.musica.tocandoMusica
                          ? Icons.pause_circle_filled_outlined
                          : Icons.play_circle_fill_outlined,
                      size: 86.0,
                      color: Colors.greenAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      // <-- Icon
                      Icons.arrow_forward_ios_outlined,
                      size: 48.0,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? login, senha;
  Widget? msgErro;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
          alignment: Alignment.center,
          color: Color.fromARGB(255, 0, 48, 124),
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 150.0),
                  ),
                  const Image(
                    image: AssetImage("assets/imagens/logo.png"),
                    width: 250,
                    height: 250,
                    repeat: ImageRepeat.noRepeat,
                    alignment: Alignment.center,
                    matchTextDirection: true,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Informe o login',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite o login';
                      } else {
                        login = value;
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Informe a senha',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite a senha.';
                      } else {
                        senha = value;
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: msgErro,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          User? retorno = pegaUsuario(login, senha);
                          if (retorno != null) {
                            usuarioLogado = retorno;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TelaPrincipal()
                              ),
                            );
                          }
                          else {
                            setState(() {
                              msgErro = const Text(
                                  "Login ou senha errados, por favor, verifique!",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold));
                            });
                          }
                        }
                      },
                      child: const Text('Logar'),
                    ),
                  ),
                ]),
          )),
    );
  }
}


//<editor-fold desc="Classe do banco">
class User {
  late int idUser;
  late String nameUser;
  late int loginUser;
  late int passwordUser;

  User(this.idUser,this.nameUser,this.loginUser,this.passwordUser);

  User.fromJson(Map<String, dynamic> data) {
    this.idUser = data['idUser'];
    this.nameUser = data['nameUser'];
    this.loginUser = data['loginUser'];
    this.passwordUser = data['passwordUser'];
  }

}

class Musica {
  final String coverMusic;
  final String nameMusic;
  final String textMusic;
  final String urlMusic;
  bool tocandoMusica;
  AudioPlayer player;

  Musica(this.coverMusic, this.nameMusic, this.textMusic,
      this.urlMusic, this.tocandoMusica, this.player);
  Musica.doBanco(this.coverMusic, this.nameMusic, this.textMusic,
      this.urlMusic, this.player, [this.tocandoMusica = false] );
}
//</editor-fold>


//<editor-fold desc="Funções do banco">

//</editor-fold>
