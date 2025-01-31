import 'dart:io';

import 'package:biologychatbot/constants/constants.dart';
import 'package:biologychatbot/models/onnx.dart';
import 'package:biologychatbot/services/chatService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'services/authentication.dart';

class ChatScreen extends StatefulWidget {

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final authService = Get.put(AuthService());
  final chatService = Get.put(ChatService());
  final TextEditingController typed = TextEditingController();
  final picker = ImagePicker();
  File? uploadedDiagram;

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
                              ) : null : TextBubble(text: cs.messages[index].text, isMe: cs.messages[index].isMe, filePath: cs.messages[index].img);
                            }),
                      ),
                    ),
                    if(uploadedDiagram!=null)
                    Align(alignment: Alignment.bottomLeft, child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 8),
                      child: Container(width: 100, height: 100, child: ImageWithCrossButton(filePath: uploadedDiagram!.path, onRemove: () {
                        uploadedDiagram = null;
                        setState(() {});
                      }, )),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.photo_library, color: Color(0xFF4EF28F)), // Bright Green Icon
                            onPressed: () async {
                              try {
                                // Pick an image from the gallery
                                XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  uploadedDiagram = File(pickedImage.path);
                                  setState(() {});
                                  // Pass the picked image to your service for uploading or further processing
                                  //await chatService.createCaptionWithBlip(diagram: File(pickedImage.path));
                                  //Get.snackbar("Success", "Image uploaded successfully.");
                                } else {
                                  //Get.snackbar("No Image Selected", "Please select an image to upload.");
                                }
                              } catch (e) {
                                Get.snackbar("Error", "Failed to upload image: $e");
                              }
                            },
                          ),
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
                            onPressed: () async {
                              chatService.encode(question: typed.text);
                              // chatService.addToMessages(message: typed.text, isMe: true, img: uploadedDiagram!=null?  uploadedDiagram!.path : null);
                              //
                              // if(uploadedDiagram==null){
                              //   chatService.askFlant5(question: typed.text);
                              // }else{
                              //   chatService.createCaptionWithBlip(diagram: uploadedDiagram!, question: typed.text);
                              //   uploadedDiagram = null;
                              //   setState(() {});
                              // }
                              //
                              // typed.clear();
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
  final String? filePath;

  TextBubble({required this.text, required this.isMe, required this.filePath});

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
        child: Column(
          children: [
            if(filePath!=null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(width: 100, height: 100, child: Image.file(File(filePath.toString()))),
            ),
            Text(
              text,
              style: TextStyle(color: !isMe? dark_navy : bright_green),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageWithCrossButton extends StatelessWidget {
  final String filePath;
  final VoidCallback onRemove;

  const ImageWithCrossButton({
    Key? key,
    required this.filePath,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Display the image
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0), // Add rounded corners if desired
          child: Image.file(
            File(filePath),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        ),
        // Cross button at the corner
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.8),
              radius: 16,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
