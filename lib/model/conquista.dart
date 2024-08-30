class Conquista {
  String image = "";
  String titulo = "";
  String descricao = "";
  int pontos = 0;

  Conquista({ required this.image, required this.titulo, required this.descricao, required this.pontos});
}
Future<List<Conquista>> loadConquistas() async {
  return [
    Conquista(
      image: "images/primeiro_passo.png",
      titulo: "Primeiro passo",
      descricao: "Você deu o primeiro passo na sua jornada. Continue aprendendo e acumulando pontos!",
      pontos: 10,
    ),
    Conquista(
      image: "images/iniciado.png",
      titulo: "Iniciado",
      descricao: "Você está no caminho certo. Continue respondendo perguntas para ganhar mais pontos!",
      pontos: 30,
    ),
    Conquista(
      image: "images/aprendiz_atento.png",
      titulo: "Aprendiz atento",
      descricao: "Sua dedicação está começando a dar frutos. Fique atento e continue progredindo!",
      pontos: 50,
    ),
    Conquista(
      image: "images/concentrado.png",
      titulo: "Concentrado",
      descricao: "Seu foco está te levando longe. Continue assim para alcançar mais conquistas!",
      pontos: 70,
    ),
    Conquista(
      image: "images/persistente.png",
      titulo: "Persistente",
      descricao: "Sua persistência está valendo a pena. Não desista e continue acumulando conhecimento!",
      pontos: 90,
    ),
    Conquista(
      image: "images/conhecedor.png",
      titulo: "Conhecedor",
      descricao: "Seu conhecimento está se expandindo. Parabéns por alcançar esta etapa!",
      pontos: 120,
    ),
    Conquista(
      image: "images/desbravador.png",
      titulo: "Desbravador",
      descricao: "Você está explorando novos horizontes e dominando o conteúdo. Continue avançando!",
      pontos: 150,
    ),
    Conquista(
      image: "images/expert.png",
      titulo: "Expert",
      descricao: "Você se tornou um expert no assunto. Sua jornada está quase no fim!",
      pontos: 180,
    ),
    Conquista(
      image: "images/mestre.png",
      titulo: "Mestre",
      descricao: "Você é um mestre no seu campo. Apenas mais um passo para se tornar uma lenda!",
      pontos: 230,
    ),
    Conquista(
      image: "images/lenda.png",
      titulo: "Lenda",
      descricao: "Parabéns! Você se tornou uma lenda. Seu conhecimento e dedicação são inspiradores!",
      pontos: 280,
    ),
  ];
}
