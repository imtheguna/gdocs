import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:docs/models/chatgptmodel.dart';
import 'package:docs/models/constants.dart';
import 'package:docs/pages/chatview.dart';
import 'package:docs/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRepo {
  void modalBottomSheetMenu({
    required BuildContext context,
    required double width,
  }) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
              left: width > 1000 ? 800 : 20, right: 20, bottom: 10),
          child: Card(
            child: Container(
                height: 600,
                child: ChatWindow(
                  ctx: context,
                  width: width,
                )),
          ),
        );
      },
    );
  }
}

class ChatWindow extends ConsumerStatefulWidget {
  final double width;
  final BuildContext ctx;

  const ChatWindow({super.key, required this.ctx, required this.width});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatWindowState();
}

class _ChatWindowState extends ConsumerState<ChatWindow> {
  @override
  final TextEditingController _controllerChatGPT = TextEditingController();
  ChatGPT? chatGPT;
  bool _isImageSearch = false;
  StreamSubscription? _subscription;
  bool _isTyping = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    chatGPT = ChatGPT.instance.builder(
      chatGPTAPI,
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    _subscription?.cancel();
    chatGPT!.genImgClose();
    _controllerChatGPT.dispose();
  }

  void _sendMessage({required bool isImageSearch}) {
    if (_controllerChatGPT.text.isEmpty) return;
    ChatGPTMsgModel message = ChatGPTMsgModel(
      data: _controllerChatGPT.text,
      user: ref.read(userProvider)!.name,
      isImage: false,
    );

    setState(() {
      chatlist.insert(0, message);
      _isTyping = true;
    });

    _controllerChatGPT.clear();

    if (isImageSearch) {
      final request = GenerateImage(message.data, 1, size: "256x256");
      int i = 0;
      _subscription = chatGPT!
          .generateImageStream(request)
          .asBroadcastStream()
          .listen((response) {
        if (i == 0) insertNewData(response.data!.last!.url!, isImage: true);
        i = i + 1;
      });
    } else {
      final request = CompleteReq(
          prompt: message.data, model: kTranslateModelV3, max_tokens: 200);
      int i = 0;
      _subscription = chatGPT!
          .onCompleteStream(request: request)
          .asBroadcastStream()
          .listen((response) {
        if (i == 0) insertNewData(response!.choices[0].text, isImage: false);
        i = i + 1;
      });
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatGPTMsgModel botMessage = ChatGPTMsgModel(
      data: response,
      user: "AI",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      chatlist.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (v) {
                _sendMessage(isImageSearch: false);
              },
              style: const TextStyle(
                  fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0)),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.7),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 241, 241, 241),
                  hintText: 'Question/description',
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.7),
                  )),
              controller: _controllerChatGPT,
            ),
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.orangeAccent,
                ),
                onPressed: () {
                  _sendMessage(isImageSearch: false);
                },
              ),
              TextButton(
                  onPressed: () {
                    _sendMessage(isImageSearch: true);
                  },
                  child: const Icon(Icons.image_search_rounded))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ask your Question',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: IconButton(
                    onPressed: () => Navigator.of(widget.ctx).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
              child: ListView.builder(
            reverse: true,
            itemCount: chatlist.length,
            itemBuilder: (context, index) {
              return ChatMessage(
                sender: chatlist[index].user,
                text: chatlist[index].data,
                isImage: chatlist[index].isImage,
              );
            },
          )),
          if (_isTyping) const Loading(),
          _buildTextComposer()
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LinearProgressIndicator(),
    );
  }
}
