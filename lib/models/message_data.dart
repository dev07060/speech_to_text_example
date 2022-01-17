
class ChatMessageModel {
  final String message;
  final String bot;
  final int id;
  final String dist;

  const ChatMessageModel({
    this.message,
    this.bot,
    this.id,
    this.dist
  });

  factory ChatMessageModel.turnSnapshotIntoListRecord(Map data) {
    return ChatMessageModel(
      message: data['message'],
      bot: data['bot'],
      id: data['id'],
      dist: data['dist'],
    );
  }

  List<Object> get props => [
    message,bot,id,dist
  ];
}
