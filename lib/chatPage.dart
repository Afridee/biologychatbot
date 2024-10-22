import 'package:biologychatbot/constants/constants.dart';
import 'package:biologychatbot/services/chatService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'services/authentication.dart';

class ChatScreen extends StatelessWidget {

  final authService = Get.put(AuthService());
  final chatService = Get.put(ChatService());
  final TextEditingController typed = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthService>(builder: (as){
      return Scaffold(
        appBar: AppBar(
          title: Text('Hi, ${as.firebaseAuth.currentUser!.displayName}', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF1E454F),
          actions: [
            IconButton(onPressed: (){
               authService.signOut();
            }, icon: Icon(Icons.logout_outlined, color: bright_green))
          ],// Deep Blue Green
        ),
        body: SafeArea(child:
        Container(
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: GetBuilder<ChatService>(
              builder: (cs){
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: cs.messages.length+1,
                            itemBuilder: (context,index){
                              return  index==cs.messages.length? cs.isLoading ? Align(
                                alignment : Alignment.centerLeft,
                                child: Container(
                                  width: 100,
                                  child: Lottie.asset(
                                  'assets/animations/typing.json',
                                  fit: BoxFit.cover,
                                  ),
                                ),
                              ) : null : TextBubble(text: cs.messages[index].text, isMe: cs.messages[index].isMe);
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: typed,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFF1E454F), // Deep Blue Green
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: Color(0xFF40C07C)), // Soft Green
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: Color(0xFF4EF28F)), // Bright Green
                            onPressed: () {
                              chatService.addToMessages(message: typed.text, isMe: true);
                              chatService.ask(question: typed.text);
                              typed.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        )),
      );
    });
  }
}

class TextBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  TextBubble({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: !isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: !isMe ? Color(0xFF4EF28F) : Color(0xFF1E454F), // Bright Green for me, Deep Blue Green for others
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isMe ? Radius.circular(20) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: !isMe? dark_navy : bright_green),
        ),
      ),
    );
  }
}