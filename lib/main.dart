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
          _selectedMedia = comics;
          break;
        case 4:
          _selectedMedia = albums;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            icon: Icon(Icons.local_movies),
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
            title: Text('Comics'),
            icon: Icon(Icons.filter_outlined),
          ),
          BottomNavigationBarItem(
            title: Text('Albums'),
            icon: Icon(Icons.my_library_music),
          ),
        ],
      ),
    );
  }

  Widget _buildListMedia(List<MediaModel> list){
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index){
        return ListTile(
          leading: Image(
            image: NetworkImage(list[index].imageUrl),
          ),
          title: Text(list[index].title),
        );
      }
    );
  }
}

//MEDIA MODEL

class MediaModel {
  String imageUrl;
  String title;
  String description;

  // Constructor
  MediaModel({this.imageUrl, this.title, this.description});
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
];

final comics = [
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
];