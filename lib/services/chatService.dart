import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart' as client;
import 'package:package_info_plus/package_info_plus.dart';
import '../models/message.dart';

class ChatService extends GetxController {

  client.Dio dio = client.Dio();
  String baseUrlValue = "";
  bool isLoading = false;
  List<Message> messages = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

   addToMessages({required String message, required bool isMe, required String? img}){
     messages.add(Message(text: message, isMe: isMe, img: img));
     update();
   }

   createCaptionWithBlip({required File diagram, required String question}) async{

     isLoading = true;
     update();

     try{
       client.MultipartFile  mf =  client.MultipartFile.fromFileSync(diagram.path, filename: diagram.path.split('/').last);
       client.FormData formData2 = client.FormData();
       formData2.files.add(MapEntry("file", mf));

       /// Get the base url:
       DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore.collection('baseurl').doc('baseurl').get();
       baseUrlValue = documentSnapshot.data()?['baseurl'] ?? 'No data found';

       client.Response response = await dio
           .post("${baseUrlValue.trim()}/generate-caption",
           data: formData2);

       print("Generated caption from diagram by Blip:");
       print(response.data["caption"]);

       print("User's question");
       print(question);
       

       String generatedCaptionFromBlip = response.data["caption"].toString();

       askFlant5(question: "$generatedCaptionFromBlip.$question");
     }catch(e, stack){
       isLoading = false;
       print(stack);
     }

   }

   askFlant5({required String question}) async{
     isLoading = true;
     update();

     /// Get the base url:
     DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore.collection('baseurl').doc('baseurl').get();
     baseUrlValue = documentSnapshot.data()?['baseurl'] ?? 'No data found';

     dio.options.followRedirects = true;

     try {
       client.Response res = await dio.post(
         "${baseUrlValue.trim()}/generate",
         data: {
           "prompt": "Please answer this biology question: $question"
         },
       );
       addToMessages(message: res.data["generated_text"].toString(), isMe: false, img: null);
     } catch (e,stack) {
        if (kDebugMode) {
          print(e);
        }
        if (kDebugMode) {
          print(stack);
        }
     }

     isLoading = false;
     update();
   }

}