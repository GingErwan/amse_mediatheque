import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mediatheque',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home:
        MyHomePage(title: 'Mediatheque'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<MediaModel> _selectedMedia = movies;


  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;

      switch(index){
        case 0:
          _selectedMedia = movies;
          break;
        case 1:
          _selectedMedia = books;
          break;
        case 2:
          _selectedMedia = series;
          break;
        case 3:
          _selectedMedia = albums;
          break;
        case 4:
          _selectedMedia = likes;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.contact_support_outlined),
              onPressed: aboutApp,
          ),
        ],
      ),
      body: Center(
        child: _buildListMedia(_selectedMedia),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        iconSize: 20.0,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            title: Text('Movies'),
            icon: Icon(Icons.local_movies_outlined),
          ),
          BottomNavigationBarItem(
            title: Text('Books'),
            icon: Icon(Icons.book_outlined),
          ),
          BottomNavigationBarItem(
            title: Text('Series'),
            icon: Icon(Icons.live_tv),
          ),
          BottomNavigationBarItem(
            title: Text('Albums'),
            icon: Icon(Icons.my_library_music_outlined),
          ),
          BottomNavigationBarItem(
            title: Text('Likes'),
            icon: Icon(Icons.favorite_outline_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildListMedia(List<MediaModel> list){
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.blueGrey,
      ),
      itemCount: list.length,
      itemBuilder: (context, index){
        return ListTile(
          leading: Image(
            image: NetworkImage(list[index].imageUrl),
          ),
          title: Text(list[index].title),
          trailing: Icon(
            list[index].like ? Icons.favorite : Icons.favorite_border,
            color: list[index].like ? Colors.red : null,
          ),
          onTap: (){detailedTitle(list[index]);},
          onLongPress: (){
            setState(() {
              list[index].like = !list[index].like;
              list[index].like ? likes.add(list[index]) : likes.remove(list[index]);
            });
          },
        );
      }
    );
  }

  void detailedTitle(MediaModel media){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          return Scaffold(
            appBar: AppBar(
              title: Text('Detailed Title'),
            ),
          );
        },
      ),
    );
  }

  void aboutApp(){
    Column _buildIconColumn(Color color, IconData icon1, String label1, IconData icon2, String label2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon1, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label1,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
          Icon(icon2, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){

          return Scaffold(
            appBar: AppBar(
              title: Text('About app'),
            ),
            body: Center(
                    /*1*/
                    child: Column(

                      children: [
                        /*2*/
                        Container(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text(
                            'Thank you for Using this app!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),

                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'This App was created by:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Ranto RABESANDRATANA'),
                              Text('Erwan MERLY'),
                            ],
                          ),
                          ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildIconColumn(Colors.purple, Icons.call, '+33695572996', Icons.mail, 'ranto.rabesandratana@etu.imt-lille-douai.fr'),
                              _buildIconColumn(Colors.purple, Icons.call, '+33634437414', Icons.mail, 'erwan.merly@etu.imt-lille-douai.fr'),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}


//MEDIA MODEL
class MediaModel {
  String imageUrl;
  String title;
  String description;
  bool like;

  // Constructor
  MediaModel({this.imageUrl, this.title, this.description}){like = false;}
}

final series = [
  MediaModel(
    imageUrl:
    'https://m.media-amazon.com/images/M/MV5BNzRlNGUzMmEtYTg0Ni00N2U2LTg4YWEtNDdlNmMwYjBlZDQ0XkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_FMjpg_UY864_.jpg',
    title: 'Lupin',
    description: "Série Netflix ...",
  ),
  MediaModel(
    imageUrl:
    'https://upload.wikimedia.org/wikipedia/fr/6/67/StrangerThingslogo.png',
    title: 'Stranger Things',
    description: "Série Netflix ...",
  ),
  MediaModel(
    imageUrl:
    'https://m.media-amazon.com/images/M/MV5BNGEyOGJiNWEtMTgwMi00ODU4LTlkMjItZWI4NjFmMzgxZGY2XkEyXkFqcGdeQXVyNjcyNjcyMzQ@._V1_FMjpg_UX675_.jpg',
    title: 'The Boys',
    description: "Série Amazon ...",
  ),
  MediaModel(
    imageUrl:
    'https://www.mondedesgrandesecoles.fr/wp-content/uploads/la-casa-de-papel-2.jpg',
    title: 'La Casa de Papel',
    description: "Série Netflix ...",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img5.acsta.net/pictures/19/06/18/12/11/3956503.jpg',
    title: 'Breaking Bad',
    description: "Série",
  ),
  MediaModel(
    imageUrl:
    'https://upload.wikimedia.org/wikipedia/en/1/12/The_Queen%27s_Gambit_%28miniseries%29.png',
    title: 'Queens Gambit',
    description: "Série Netflix ...",
  ),
  MediaModel(
    imageUrl:
    'https://www.lepoint.fr/images/2020/04/18/20259720lpw-20259783-article-jpg_7055451_1250x625.jpg',
    title: 'Vikings',
    description: "Série Netflix ...",
  ),
  MediaModel(
    imageUrl:
    'https://thumbs-prod.si-cdn.com/NtBcZJ-E5dwxqmZQKfXOkkkt3ck=/fit-in/1600x0/filters:focal(634x85:635x86)/https://public-media.si-cdn.com/filer/7b/ba/7bba298e-7e2e-44f0-adb9-b47dfdc1e240/p05m69vt.jpg',
    title: 'Peaky Blinders',
    description: "Série Netflix ...",
  ),
  MediaModel(
    imageUrl:
    'http://www.fulguropop.com/wp-content/uploads/2020/11/Titan-2.jpg',
    title: 'Attack On Titan',
    description: "Anime avec des titans",
  ),
  MediaModel(
    imageUrl:
    'https://www.micromania.fr/dw/image/v2/BCRB_PRD/on/demandware.static/-/Sites-masterCatalog_Micromania/default/dwa2be0622/images/high-res/visuels%20produits%20news/106257.jpg?sw=480&sh=480&sm=fit',
    title: 'My Hero Academia',
    description: "Anime avec des jeunes apprentis héros",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/81g1x5bk2zL.jpg',
    title: 'Naruto Shippuden',
    description: "Anime de Ninjas",
  ),
];

final movies = [
  MediaModel(
    imageUrl:'https://m.media-amazon.com/images/M/MV5BMzUzNDM2NzM2MV5BMl5BanBnXkFtZTgwNTM3NTg4OTE@._V1_.jpg',
    title: 'La La Land',
    description: "Film de Damien Chazelle",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img4.acsta.net/pictures/17/06/30/16/06/184359.jpg',
    title: '120 Battements par Minutes',
    description: "Film de Robin Campillo",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img2.acsta.net/c_310_420/pictures/17/05/30/14/36/446691.jpg',
    title: 'Baby Driver',
    description: "Film de Edgar Wright",
  ),
  MediaModel(
    imageUrl:
    'https://image.api.playstation.com/vulcan/img/cfn/11307RSOY0YPjr2OSOyHwixkMPLtwugfbK0qJ59Su4vVYEnYgoTQKZ2nVrUr9RAo8--DOk45lw0-7rUo2O5hJVg4Te4gV6RE.png',
    title: 'AVENGERS',
    description: "Film de Joss Whedon",
  ),
  MediaModel(
    imageUrl:
    'https://www.avoir-alire.com/IMG/arton1021.jpg',
    title: 'The Elephant Man',
    description: "Film de David Lynch",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/51VNG7R87NL._AC_SY445_.jpg',
    title: 'Fight Club',
    description: "Film de David Fincher",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/81nwnHTcV2L._AC_SY445_.jpg',
    title: 'The Shining',
    description: "Film de Stanley Kubrick",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img4.acsta.net/pictures/14/10/09/10/20/418344.jpg',
    title: 'Annabelle',
    description: "Film de John R. Leonetti",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/81%2BNup8-8NL._AC_SL1500_.jpg',
    title: 'Avengers Endgame',
    description: "Film de Anthony et Joe Russo",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/812uG5uFZhL.jpg',
    title: 'Mon voisin Totoro',
    description: "Film de Hayao Miyazaki",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img6.acsta.net/medias/nmedia/18/35/48/22/18399898.jpg',
    title: 'Le château ambulant',
    description: "Film de Hayao Miyazaki",
  ),
  MediaModel(
    imageUrl:
    'https://www.glenat.com/sites/default/files/images/livres/couv/9782344030974-001-T.jpeg',
    title: 'Princesse Mononoke',
    description: "Film de Hayao Miyazaki",
  ),
];

final albums = [
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/715LZJ5qX0L._SL1200_.jpg',
    title: 'OK Computer',
    description: "Album de Radiohead",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/81qd7axW5TL._SL1500_.jpg',
    title: "<|°_°|>",
    description: "Album de Caravan Palace",
  ),
  MediaModel(
    imageUrl:'https://img.discogs.com/hDJgRO0UG_MjHb40wqtehx6K6fc=/fit-in/600x591/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-1787995-1329647708.jpeg.jpg',
    title: 'Wolfgang Amadeus Phoenix',
    description: "Album de Phoenix",
  ),
  MediaModel(
    imageUrl:'https://images.genius.com/6fd31c8993a97f5851e5f9cfc7cbe5e8.1000x1000x1.jpg',
    title: 'QALF',
    description: "Album de Damso",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/71zqQLosx6L._SL1400_.jpg',
    title: 'Trinity',
    description: "Album de Laylow",
  ),
  MediaModel(
    imageUrl:'https://www.abcdrduson.com/wp-content/uploads/2020/12/67e772f270eeff5f4af6e39cf7ecd2c1.1000x1000x1.jpg',
    title: 'LMF',
    description: "Album de Freeze Corleone",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/71lqI%2BMuHGL._SL1200_.jpg',
    title: 'ASTROWORLD',
    description: "Album de Travis Scott",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/51kxhu%2BRm5L._SL1200_.jpg',
    title: 'Ipséité',
    description: "Album de Damso",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/81jqRIm2UtL._SL1500_.jpg',
    title: 'JACKBOYS',
    description: "Album des Jackboys",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/713R6331nOL._SY355_.jpg',
    title: 'Positions',
    description: "Album d'Ariana Grande",
  ),
  MediaModel(
    imageUrl:'https://static.fnac-static.com/multimedia/Images/FR/NR/57/a9/c9/13216087/1540-1/tsp20210122100243/140-BPM-2.jpg',
    title: '140 BPM 2',
    description: "Album d'Hamza",
  ),
];

final books = [
  MediaModel(
    imageUrl:'https://actualitte.com/uploads/images/75488198_14658327-b77d7f85-dc55-40c8-8529-d9da74987834.jpg',
    title: 'Sharko',
    description: "Livre de Franck Thilliez",
  ),
  MediaModel(
    imageUrl:'https://fetv.cia-france.com/image/2016/7/19/jpg_190x300_l_ecume_gallimard_300.jpg%28mediaclass-base-media-preview.6c55b7f9d7072a9aa50507b4f1ace9e2a15d3b23%29.jpg',
    title: "L'écume des jours",
    description: "Livre de Boris Vian",
  ),
  MediaModel(
    imageUrl:'https://static.fnac-static.com/multimedia/Images/FR/NR/ab/4b/a8/11029419/1507-1/tsp20190321143217/Iggy-Salvador.jpg',
    title: 'Iggy Salvador',
    description: "Film de Antoine Zebra",
  ),
  MediaModel(
    imageUrl: 'https://www.lemagducine.fr/wp-content/uploads/2020/04/V-pour-Vendetta-critique-bd.jpg',
    title: 'V Pour Vandtta',
    description: "Ecrit par Alan Moore pour DC Comics, V Pour Vandetta...",
  ),
  MediaModel(
    imageUrl: 'https://images-na.ssl-images-amazon.com/images/I/718E5icuODL.jpg',
    title: 'Watchmen',
    description: "Ecrit par Alan Moore pour DC Comincs, Watchment...",
  ),
  MediaModel(
    imageUrl: 'https://images-na.ssl-images-amazon.com/images/I/61118x3OEKL.jpg',
    title: 'Tintin au pays des Soviets',
    description: "Ecrit par Hergé, il s'agit du premier tome de la série Tintin....",
  ),
];

final likes = new List<MediaModel>();