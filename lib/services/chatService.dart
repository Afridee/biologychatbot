import 'dart:convert';
import 'dart:io';
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
  bool isLoading = false;
  List<Message> messages = [];

   addToMessages({required String message, required bool isMe}){
     messages.add(Message(text: message, isMe: isMe));
     update();
   }

   ask({required String question}) async{
     isLoading = true;
     update();

     dio.options.followRedirects = true;
     try {
       client.Response res = await dio.post(
         "http://localhost:3000/generate",
         data: {
           "prompt": "Please answer this biology question: $question"
         },
       );
       addToMessages(message: res.data["generated_text"].toString(), isMe: false);
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