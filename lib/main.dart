
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  List<MediaModel> filteredList = new List<MediaModel>();
  bool isSearching = false;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
      isSearching = false;

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

  void _onTapLike(MediaModel media){
    setState(() {
      media.like = !media.like;
      media.like ? likes.add(media) : likes.remove(media);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching ? Text(widget.title) : TextField(
          onChanged: (text) {
            text = text.toLowerCase();
            setState(() {
              _selectedMedia = filteredList.where((element) => element.title.toLowerCase().contains(text)).toList();
            });
          },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: "Recherche...",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        actions: <Widget>[isSearching
            ? IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  this.isSearching = false;
                });
              },
            )
            : IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  this.isSearching = true;
                  filteredList = _selectedMedia;
                });
              },
            ),
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
          trailing: IconButton(
            icon: Icon(list[index].like ? Icons.favorite : Icons.favorite_border, color: list[index].like ? Colors.red : null, size: 30),
            onPressed: (){_onTapLike(list[index]);},
          ),

          onTap: (){detailedTitle(list[index]);},
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
            body: ListView(
              children: [
                Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Image(image: NetworkImage(media.imageUrl)),
                        ),
                        Container(height: 200, child: VerticalDivider(color: Colors.blueGrey, thickness: 2)),
                        Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text("TITLE", style: TextStyle(color: Colors.grey, fontSize: 20)),
                          Container(
                            width: 100,
                            child: Text(media.title, textAlign: TextAlign.center),
                          ),
                            Text("Rating", style: TextStyle(color: Colors.amber, fontSize: 15)),
                            RatingBar.builder(
                                initialRating: media.rate,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 5.0,
                                  ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                  media.rate = rating;
                                  },
                            ),
                          IconButton(
                            icon: Icon(media.like ? Icons.favorite : Icons.favorite_border, color: media.like ? Colors.red : null,),
                            onPressed: (){_onTapLike(media);},

                          ),
                        ],
                        ),
                      ],
                    ),
                    Container(height: 20, child: Divider(color: Colors.blueGrey, thickness: 3)),
                    Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("AUTHOR", style: TextStyle(color: Colors.grey, fontSize: 25)),
                        Text(media.description),
                        Container(height: 50, child: Divider(color: Colors.blueGrey, thickness: 1)),
                        Text("ABOUT", style: TextStyle(color: Colors.grey, fontSize: 20)),
                        Text(media.synopsis),
                      ],
                    ),
                  ],
                ),
              ],
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
            margin: const EdgeInsets.only(top: 12),
            child: Text(
              label1,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
          Icon(icon2, color: color),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Text(
              label2,
              style: TextStyle(
                fontSize: 10,
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
              child: Column(
                children: [
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
  String synopsis;
  bool like;
  double rate;

  // Constructor
  MediaModel({this.imageUrl, this.title, this.description, this.synopsis}){like = false;rate = 0;}
  bool contains(text){
    return (text==this.title);
  }
}

final series = [
  MediaModel(
    imageUrl:
    'https://m.media-amazon.com/images/M/MV5BNzRlNGUzMmEtYTg0Ni00N2U2LTg4YWEtNDdlNmMwYjBlZDQ0XkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_FMjpg_UY864_.jpg',
    title: 'Lupin',
    description: "George Kay",
    synopsis: "Il y a 25 ans, la vie du jeune Assane Diop est bouleversée lorsque son père meurt après avoir été accusé d'un crime qu'il n'a pas commis. Aujourd’hui, Assane va s'inspirer de son héros, Arsène Lupin - Gentleman Cambrioleur, pour le venger…",
  ),
  MediaModel(
    imageUrl:
    'https://ec56229aec51f1baff1d-185c3068e22352c56024573e929788ff.ssl.cf1.rackcdn.com/attachments/large/4/1/3/006854413.jpg',
    title: 'Stranger Things',
    description: "Les frères Duffer",
    synopsis: "A Hawkins, en 1983 dans l'Indiana. Lorsque Will Byers disparaît de son domicile, ses amis se lancent dans une recherche semée d'embûches pour le retrouver. Dans leur quête de réponses, les garçons rencontrent une étrange jeune fille en fuite.",
  ),
  MediaModel(
    imageUrl:
    'https://m.media-amazon.com/images/M/MV5BNGEyOGJiNWEtMTgwMi00ODU4LTlkMjItZWI4NjFmMzgxZGY2XkEyXkFqcGdeQXVyNjcyNjcyMzQ@._V1_FMjpg_UX675_.jpg',
    title: 'The Boys',
    description: "Eric Kripke",
    synopsis: "Dans un monde fictif où les super-héros se sont laissés corrompre par la célébrité et la gloire et ont peu à peu révélé la part sombre de leur personnalité, une équipe de justiciers qui se fait appeler'The Boys' décide de passer à l'action et d'abattre ces super-héros autrefois appréciés de tous.",
  ),
  MediaModel(
    imageUrl:
    'https://media.senscritique.com/media/000018935876/source_big/La_Casa_de_Papel.jpg',
    title: 'La Casa de Papel',
    description: "Alex Pina",
    synopsis: "Huit voleurs font une prise d'otages dans la Maison royale de la Monnaie d'Espagne, tandis qu'un génie du crime manipule la police pour mettre son plan à exécution.",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img5.acsta.net/pictures/19/06/18/12/11/3956503.jpg',
    title: 'Breaking Bad',
    description: "Vince Gilligan",
    synopsis: "Walter « Walt » White est professeur de chimie dans un lycée, et vit avec son fils handicapé moteur et sa femme enceinte à Albuquerque, au Nouveau-Mexique. Le lendemain, après avoir fêté ses 50 ans, on lui diagnostique un cancer du poumon en phase terminale avec une espérance de vie estimée à deux ans. Tout s'effondre pour lui ! Il décide alors de mettre en place un laboratoire et un trafic de méthamphétamine pour assurer un avenir financier confortable à sa famille après sa mort, en s'associant à Jesse Pinkman, un de ses anciens élèves devenu petit trafiquant.",
  ),
  MediaModel(
    imageUrl:
    'https://upload.wikimedia.org/wikipedia/en/1/12/The_Queen%27s_Gambit_%28miniseries%29.png',
    title: 'Queens Gambit',
    description: "Scott Franck et Allan Scott",
    synopsis: "Cette fiction suit Elisabeth Harmon, une prodige des échecs orpheline, de huit à vingt-deux ans, dans sa quête pour devenir la meilleure joueuse d'échecs du monde, tout en luttant contre des problèmes émotionnels et une dépendance aux drogues et à l'alcool. L'histoire commence au milieu des années 1950 et se poursuit dans les années 19601.",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/91e5V4wK46L._AC_SL1500_.jpg',
    title: 'Vikings',
    description: "Michael Hirst",
    synopsis: "Les exploits d'un groupe de Vikings mené par Ragnar Lothbrok, l'un des vikings les plus populaires de son époque et au destin semi-légendaire, sont narrés par la série. Ragnar serait d'origine norvégienne et suédoise, selon les sources. Il est supposé avoir unifié les clans vikings en un royaume aux frontières indéterminées à la fin du viiie siècle (le roi Ecbert mentionne avoir vécu à la cour du roi Charlemagne, sacré empereur en l'an 800). Mais il est surtout connu pour avoir été le promoteur des tout premiers raids vikings en terres chrétiennes, qu'elles soient saxonnes, franques ou celtiques.\n Simple fermier, homme lige du jarl Haraldson, il se rebelle contre les choix stratégiques de son suzerain. Au lieu d'attaquer les païens slaves et baltes de la Baltique, il décide de se lancer dans l'attaque des riches terres de l'Ouest, là où les monastères regorgent de trésors qui n'attendent que d'être pillés par des guerriers ambitieux.\n Clandestinement, Ragnar va monter sa propre expédition et sa réussite changera le destin des Vikings comme celui des royaumes chrétiens du sud, que le simple nom de « Vikings » terrorisera pendant plus de deux siècles.",
  ),
  MediaModel(
    imageUrl:
    'http://www.ecran-et-toile.com/uploads/5/5/8/7/55875205/peaky-blinders-4_orig.jpg',
    title: 'Peaky Blinders',
    description: "Steven Knight",
    synopsis: "En 1919, à Birmingham, soldats, révolutionnaires politiques et criminels combattent pour se faire une place dans le paysage industriel de l'après-Guerre. Le Parlement s'attend à une violente révolte, et Winston Churchill mobilise des forces spéciales pour contenir les menaces. La famille Shelby compte parmi les membres les plus redoutables. Surnommés les''Peaky Blinders'' par rapport à leur utilisation de lames de rasoir cachées dans leurs casquettes, ils tirent principalement leur argent de paris et de vol. Tommy Shelby, le plus dangereux de tous, va devoir faire face à l'arrivée de Campbell, un impitoyable chef de la police qui a pour mission de nettoyer la ville. Ne doit-il pas se méfier tout autant de la ravissante Grace Burgess ? Fraîchement installée dans le voisinage, celle-ci semble cacher un mystérieux passé et un dangereux secret.",
  ),
  MediaModel(
    imageUrl:
    'https://m.media-amazon.com/images/M/MV5BMTY5ODk1NzUyMl5BMl5BanBnXkFtZTgwMjUyNzEyMTE@._V1_.jpg',
    title: 'Attack On Titan',
    description: "Hajime Isayma",
    synopsis: "Dans un monde ravagé par des titans mangeurs d’homme depuis plus d’un siècle, les rares survivants de l’Humanité n’ont d’autre choix pour survivre que de se barricader dans une cité-forteresse. Le jeune Eren, témoin de la mort de sa mère dévorée par un titan, n’a qu’un rêve : entrer dans le corps d’élite chargé de découvrir l’origine des Titans et les annihiler jusqu’au dernier…",
  ),
  MediaModel(
    imageUrl:
    'https://www.micromania.fr/dw/image/v2/BCRB_PRD/on/demandware.static/-/Sites-masterCatalog_Micromania/default/dwa2be0622/images/high-res/visuels%20produits%20news/106257.jpg?sw=480&sh=480&sm=fit',
    title: 'My Hero Academia',
    description: "Kōhei Horikoshi",
    synopsis: "Dans un monde où 80 % de la population mondiale possède des super-pouvoirs, ici nommés « Alters » (個性, Kosei?), n'importe qui peut devenir un héros ou, s'il le souhaite, un criminel. Le manga suit les aventures de Izuku Midoriya « Deku », l'un des rares humains ne possédant pas d'Alter, qui rêve pourtant de rejoindre la filière super-héroïque de la grande académie Yuei (勇井高校, Yūei Kōkō?) et de devenir un jour un des plus grands héros de son époque, à l'image de son héros, All Might. Un jour, il a la chance de rencontrer son idole et celui-ci va lui donner une chose dont il ne croyait jamais pouvoir bénéficier.",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img6.acsta.net/pictures/19/08/07/10/08/2485376.jpg',
    title: 'Naruto Shippuden',
    description: "Masashi Kishimoto",
    synopsis: "Naruto est de retour !! Après deux ans et demi d'entraînement avec Jiraya, il retrouve ses camarades de l'Académie des ninja ainsi que ses professeurs de Konoha. Tous ont évolué, y compris les ninjas du village de Suna. Seul Kakashi, semble être resté fidèle à lui-même ! Hélas, les retrouvailles sont de courte durée. Gaara, devenu depuis peu Kazekage de son village, est menacé. Tout porte à croire que l'Akatsuki soit à l'origine de l'attaque.",
  ),
];

final movies = [
  MediaModel(
    imageUrl:'https://m.media-amazon.com/images/M/MV5BMzUzNDM2NzM2MV5BMl5BanBnXkFtZTgwNTM3NTg4OTE@._V1_.jpg',
    title: 'La La Land',
    description: "Damien Chazelle",
    synopsis: "Au coeur de Los Angeles, une actrice en devenir prénommée Mia sert des cafés entre des auditions. De son côté, Sebastian, passionné de jazz, joue du piano dans des clubs miteux pour assurer sa subsistance. Tous deux sont bien loin de la vie rêvée à laquelle ils aspirent, mais ils développent des sentiments amoureux l'un pour l'autre.",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img4.acsta.net/pictures/17/06/30/16/06/184359.jpg',
    title: '120 Battements par Minutes',
    description: "Robin Campillo",
    synopsis: "Au début des années 1990, le sida se propage depuis près de dix ans. Les militants d'Act Up-Paris s’activent pour lutter contre l'indifférence générale. Au cours des « R.H. » (réunions hebdomadaires menées par deux médiateurs se chargeant de donner les tours de paroles) se décident les actions pour que soient mises en œuvre les trithérapies pour les malades atteints du sida, spécialement les « zaps » (irruption au siège du laboratoire pharmaceutique Melton Pharm, aspersions de faux-sang, notamment contre le directeur de l'Agence française de lutte contre le sida), les die-in, les distributions de préservatifs et de brochures d'information dans les lycées, les tracts dont chaque slogan provocateur est débattu et approuvé par l’assemblée. Les scènes militantes alternent avec les scènes de fête dans lesquelles les militants dansent au son de la house, leur énergie sur la piste faisant s'élever au-dessus d'eux la poussière qui se transforme « en molécules et virus se multipliant et se contaminant ».\n L'histoire débute au sein d'Act up autour de 19925 lorsque Nathan, un nouveau militant, y rencontre Sean Dalmazo, et est bouleversé par la radicalité de ce dernier, séropositif et qui consume ses dernières forces dans l'action. Sean est en conflit avec Thibault, médiateur des « R.H. » qui privilégie l'expertise et la discussion avec les autorités et les laboratoires, à l'instar d'AIDES. Nathan tombe amoureux de Sean et se lance dans les actions coups de poing d'Act up. Leur histoire d'amour est interrompue en 1995 par la mort de Sean : affaibli par la maladie, hospitalisé puis ramené dans le nouvel appartement que Nathan voulait pour eux, il est soigné par son amant et sa mère. Sean choisit d'être euthanasié par Nathan. Respectant la volonté de Sean, ses amis militants jettent ses cendres sur les petits-fours d'un banquet des assureurs.",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img2.acsta.net/c_310_420/pictures/17/05/30/14/36/446691.jpg',
    title: 'Baby Driver',
    description: "Edgar Wright",
    synopsis: "Chauffeur pour des braqueurs de banque, Baby a un truc pour être le meilleur dans sa partie : il roule au rythme de sa propre playlist. Lorsqu'il rencontre la fille de ses rêves, Baby cherche à mettre fin à ses activités criminelles pour revenir dans le droit chemin. Il est forcé de travailler pour un grand patron du crime et le braquage tourne mal. Désormais, sa liberté, son avenir avec la fille qu'il aime et sa vie sont en jeu.",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img3.acsta.net/medias/nmedia/18/85/31/58/20042068.jpg',
    title: 'AVENGERS',
    description: "Joss Whedon",
    synopsis: "Nick Fury, le directeur du S.H.I.E.L.D., l'organisation qui préserve la paix dans le monde, veut former une équipe d'irréductibles pour empêcher la destruction du monde. Iron Man, Hulk, Thor, Captain America, Hawkeye et Black Widow répondent présents. La nouvelle équipe, baptisée Avengers, a beau sembler soudée, il reste encore à ses illustres membres à apprendre à travailler ensemble.",
  ),
  MediaModel(
    imageUrl:
    'https://www.avoir-alire.com/IMG/arton1021.jpg',
    title: 'The Elephant Man',
    description: "David Lynch",
    synopsis: "Londres, 1884. Un homme-éléphant est exhibé dans une baraque de fête foraine. Intrigué par ses effrayantes difformités, Frederick Treves, un jeune chirurgien, parvient, moyennant finances, à l'arracher à son manager Bytes et le conduit au London Hospital pour l'examiner en détail. Découvrant peu à peu qu'il s'agit d'un être sensible et intelligent, le jeune médecin décide de l'emmener chez lui et de le présenter à sa femme.",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/51VNG7R87NL._AC_SY445_.jpg',
    title: 'Fight Club',
    description: "David Fincher",
    synopsis: "Jack est un jeune expert en assurance insomniaque, désillusionné par sa vie personnelle et professionnelle. Lorsque son médecin lui conseille de suivre une thérapie afin de relativiser son mal-être, il rencontre dans un groupe d'entraide Marla avec qui il parvient à trouver un équilibre.",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/81nwnHTcV2L._AC_SY445_.jpg',
    title: 'The Shining',
    description: "Stanley Kubrick",
    synopsis: "Jack Torrance, gardien d'un hôtel fermé l'hiver, sa femme et son fils Danny s'apprêtent à vivre de longs mois de solitude. Danny, qui possède un don de médium, le Shining, est effrayé à l'idée d'habiter ce lieu, théâtre marqué par de terribles évènements passés...",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img4.acsta.net/pictures/14/10/09/10/20/418344.jpg',
    title: 'Annabelle',
    description: "John R. Leonetti",
    synopsis: "Été 1969, John et Mia, qui attendent leur premier enfant, viennent d'emménager dans une maison à Santa Monica. John, qui ne sait comment choyer son épouse, lui a offert une poupée ancienne. La nuit suivante, ils sont sauvagement attaqués par un couple lié à une secte satanique. La police leur porte secours rapidement, abattant l'homme tandis que sa compagne se tranche la gorge, laissant couler quelques gouttes de sang dans l'oeil de la poupée.",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/81%2BNup8-8NL._AC_SL1500_.jpg',
    title: 'Avengers Endgame',
    description: "Anthony et Joe Russo",
    synopsis: "Le Titan Thanos, ayant réussi à s'approprier les six Pierres d'Infinité et à les réunir sur le Gantelet doré, a pu réaliser son objectif de pulvériser la moitié de la population de l'Univers. Cinq ans plus tard, Scott Lang, alias Ant-Man, parvient à s'échapper de la dimension subatomique où il était coincé. Il propose aux Avengers une solution pour faire revenir à la vie tous les êtres disparus, dont leurs alliés et coéquipiers : récupérer les Pierres d'Infinité dans le passé.",
  ),
  MediaModel(
    imageUrl:
    'https://images-na.ssl-images-amazon.com/images/I/812uG5uFZhL.jpg',
    title: 'Mon voisin Totoro',
    description: "Hayao Miyazaki",
    synopsis: "Deux petites filles, Mei, 4 ans, et Satsuki, 10 ans, s'installent dans une grande maison à la campagne avec leur père pour se rapprocher de l'hôpital où séjourne leur mère. Elles découvrent la nature tout autour de la maison et, surtout, l'existence de créatures merveilleuses, les Totoros, avec qui elles deviennent très amies.",
  ),
  MediaModel(
    imageUrl:
    'https://fr.web.img6.acsta.net/medias/nmedia/18/35/48/22/18399898.jpg',
    title: 'Le château ambulant',
    description: "Hayao Miyazaki",
    synopsis: "Sophie. Âgée de 18 ans, Sophie travaille dans une boutique de chapeaux. Après sa rencontre avec Hauru, la sorcière des landes la transforme en vieille dame de 90 ans. Elle décide donc de se faire embaucher comme femme de ménage dans le château ambulant et retrouvera peu à peu son véritable âge au cours du film.",
  ),
  MediaModel(
    imageUrl:
    'https://www.glenat.com/sites/default/files/images/livres/couv/9782344030974-001-T.jpeg',
    title: 'Princesse Mononoke',
    description: "Hayao Miyazaki",
    synopsis: "Ashitaka, un jeune guerrier japonais, affronte un sanglier géant et furieux qui attaque son village. Il tue la bête, mais se retrouve atteint par un mal mystérieux. Sur le conseil des sages, il part vers l'Ouest, à la recherche de ce qui a transformé l'animal en démon. Au cours de son périple, il rencontre San, une jeune fille qui vit avec les loups. Ashitaka apprend que les humains sont à l'origine de tous ces maux, car ils détruisent la forêt, qu'ils exploitent pour alimenter leurs forges.",
  ),
];

final albums = [
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/715LZJ5qX0L._SL1200_.jpg',
    title: 'OK Computer',
    description: "Radiohead",
    synopsis: "Album de Rock Britanique",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/81qd7axW5TL._SL1500_.jpg',
    title: "<|°_°|>",
    description: "Caravan Palace",
    synopsis: "Album de Musique électronique française",
  ),
  MediaModel(
    imageUrl:'https://img.discogs.com/hDJgRO0UG_MjHb40wqtehx6K6fc=/fit-in/600x591/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-1787995-1329647708.jpeg.jpg',
    title: 'Wolfgang Amadeus Phoenix',
    description: "Phoenix",
    synopsis: "Album de Rock français",
  ),
  MediaModel(
    imageUrl:'https://images.genius.com/6fd31c8993a97f5851e5f9cfc7cbe5e8.1000x1000x1.jpg',
    title: 'QALF',
    description: "Damso",
    synopsis: "Album de Rap français, de Variété française",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/71zqQLosx6L._SL1400_.jpg',
    title: 'Trinity',
    description: "Laylow",
    synopsis: "Album de Rap français, de Pop français",
  ),
  MediaModel(
    imageUrl:'https://www.abcdrduson.com/wp-content/uploads/2020/12/67e772f270eeff5f4af6e39cf7ecd2c1.1000x1000x1.jpg',
    title: 'LMF',
    description: "Freeze Corleone",
    synopsis: "Album de Rap français",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/71lqI%2BMuHGL._SL1200_.jpg',
    title: 'ASTROWORLD',
    description: "Travis Scott",
    synopsis: "Album de Rap américain",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/51kxhu%2BRm5L._SL1200_.jpg',
    title: 'Ipséité',
    description: "Damso",
    synopsis: "Album de Rap français",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/81jqRIm2UtL._SL1500_.jpg',
    title: 'JACKBOYS',
    description: "Jackboys",
    synopsis: "Album de Rap américain",
  ),
  MediaModel(
    imageUrl:'https://images-na.ssl-images-amazon.com/images/I/713R6331nOL._SY355_.jpg',
    title: 'Positions',
    description: "Ariana Grande",
    synopsis: "Album de Pop Américaine",
  ),
  MediaModel(
    imageUrl:'https://static.fnac-static.com/multimedia/Images/FR/NR/57/a9/c9/13216087/1540-1/tsp20210122100243/140-BPM-2.jpg',
    title: '140 BPM 2',
    description: "Hamza",
    synopsis: "Album de Rap français",
  ),
];

final books = [
  MediaModel(
    imageUrl:'https://actualitte.com/uploads/images/75488198_14658327-b77d7f85-dc55-40c8-8529-d9da74987834.jpg',
    title: 'Sharko',
    description: "Franck Thilliez",
    synopsis: "Lucie Henebelle et Franck Sharko, unis dans la vie et par leur métier de flic, sont parents de deux petits garçons. Lucie tue un homme en dehors de toute procédure légale, et pour la protéger, son compagnon Franck maquille la scène de crime.\n Leur métier les conduit à être affectés à l'enquête, et il leur est bien difficile de sauver leur intégrité et le fragile édifice qu’ils s’étaient efforcés de bâtir",
  ),
  MediaModel(
    imageUrl:'https://fetv.cia-france.com/image/2016/7/19/jpg_190x300_l_ecume_gallimard_300.jpg%28mediaclass-base-media-preview.6c55b7f9d7072a9aa50507b4f1ace9e2a15d3b23%29.jpg',
    title: "L'écume des jours",
    description: "Boris Vian",
    synopsis: "Colin coule des jours heureux dans son magnifique appartement. Nicolas, son avocat et maître à penser, lui mitonne de bons petits plats ; son ami Chick, inconditionnel du philosophe Jean-Sol Partre, lui rend de sympathiques visites. Ils dégustent ensemble de savoureux cocktails harmoniques imaginés par Colin. Les moyens de Colin lui permettent en plus de se payer le luxe de ne pas travailler.",
  ),
  MediaModel(
    imageUrl:'https://static.fnac-static.com/multimedia/Images/FR/NR/ab/4b/a8/11029419/1507-1/tsp20190321143217/Iggy-Salvador.jpg',
    title: 'Iggy Salvador',
    description: "Antoine Zebra",
    synopsis: "«La première fois que je l'ai vu, il était à poil, perché sur sa table de DJ, torse nu et pantalon baissé, les bras levés en signe de victoire, visiblement ravi d'arborer fi èrement sa ti ge devant 5000 personnes. Mon voisin était hilare. Il le trouvait sûrement ridicule, à juste ti tre. Moi aussi, j'aurais dû, mais non, au contraire, je lui trouvais même une certaine classe. Oser faire ça sur la grande scène, avant l'arrivée d'Iggy Pop, le roi du déballage de paquet, putain quel cran !»",
  ),
  MediaModel(
    imageUrl: 'https://www.lemagducine.fr/wp-content/uploads/2020/04/V-pour-Vendetta-critique-bd.jpg',
    title: 'V Pour Vandetta',
    description: "Alan Moore",
    synopsis: "V pour Vendetta se passe dans l'Angleterre fasciste de l'après-guerre nucléaire, où apparaît un justicier implacable signant ses actes de la lettre V. Obsédé par le souvenir d'une culture désormais interdite et disparue, cruel et terriblement intelligent, V s'attaque aux plus forts symboles de la dictature, animé par un immense désir de vengeance et une indicible haine. La police du Commandeur est sommée de mettre fin ses agissements au plus vite...",
  ),
  MediaModel(
    imageUrl: 'https://images-na.ssl-images-amazon.com/images/I/718E5icuODL.jpg',
    title: 'Watchmen',
    description: "Alan Moore ",
    synopsis: "Aventure à la fois complexe et mystérieuse sur plusieurs niveaux, Watchmen - Les Gardiens - se passe dans une Amérique alternative de 1985 où les super-héros font partie du quotidien et où l'Horloge de l'Apocalypse -symbole de la tension entre les Etats-Unis et l'Union Soviétique- indique en permanence minuit moins cinq.",
  ),
  MediaModel(
    imageUrl: 'https://images-na.ssl-images-amazon.com/images/I/61118x3OEKL.jpg',
    title: 'Tintin au pays des Soviets',
    description: "Hergé",
    synopsis: "Tintin se rend donc au pays des soviets, mais nombre d'individus semblent se liguer contre lui pour l'empêcher d'y arriver, afin qu'il ne raconte pas ce qui s'y passe... Il échappe une première fois à la mort à cause d'une bombe qu'un dangereux individu à posé dans le train... Mais ce n'est pas terminé...",
  ),
];

final likes = new List<MediaModel>();