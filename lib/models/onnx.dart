import 'dart:math';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'dart:developer' as dev;

Map<String, dynamic> data = {"input_ids":[[863,1525,48,15651,822,10,363,19,46,2586,2358,58,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]],"attention_mask":[[1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]],"decoder_input_ids":[[0]]};

int argmax(List<double> array) {
  double maxValue = array.reduce(max);
  return array.indexOf(maxValue);
}

runStuff() async {
  final sessionOptions = OrtSessionOptions();
  const assetFileName = './models/flan-t5.onnx';
  final rawAssetFile = await rootBundle.load(assetFileName);
  final bytes = rawAssetFile.buffer.asUint8List();
  final session = OrtSession.fromBuffer(bytes, sessionOptions);

  List<List<int>> inputIds = data["input_ids"];
  List<List<int>> attentionMask = data["attention_mask"];
  List<List<int>> decoderInputIds = data["decoder_input_ids"];  // Typically starts with [0] for <BOS>

  OrtValueTensor inputIdsTensor = OrtValueTensor.createTensorWithDataList(inputIds, [1, inputIds[0].length]);
  OrtValueTensor attentionMaskTensor = OrtValueTensor.createTensorWithDataList(attentionMask, [1, attentionMask[0].length]);
  OrtValueTensor decoderInputIdsTensor = OrtValueTensor.createTensorWithDataList(decoderInputIds, [1, 1]);

  final runOptions = OrtRunOptions();
  bool shouldStop = false;
  int maxOutputLength = 32;
  int eosTokenId = 1; // You need to set this based on your model's vocabulary

  while (!shouldStop && decoderInputIds[0].length < maxOutputLength) {
    final outputs = await session.runAsync(runOptions, {
      'input_ids': inputIdsTensor,
      'attention_mask': attentionMaskTensor,
      'decoder_input_ids': decoderInputIdsTensor
    });

    int nextTokenId = 2; // assuming the output tensor structure and index outputs[0]

    if (nextTokenId == eosTokenId) {
      shouldStop = true;
    } else {
      decoderInputIds[0].add(nextTokenId); // Append the new token ID to your list

      // Release the old tensor to avoid memory leaks
      decoderInputIdsTensor.release();

      // Create a new tensor with the updated decoder input IDs
      decoderInputIdsTensor = OrtValueTensor.createTensorWithDataList(decoderInputIds, [1, decoderInputIds[0].length]);
    }
  }

  inputIdsTensor.release();
  attentionMaskTensor.release();
  decoderInputIdsTensor.release();
  runOptions.release();

  // Cleanup the session and environment
  session.release();
  OrtEnv.instance.release();

  return decoderInputIds;  // This would typically be your function's output
}


