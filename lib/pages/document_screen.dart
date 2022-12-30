import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:html' as html;
import 'package:docs/controller/comm.dart';
import 'package:docs/models/doc.model.dart';
import 'package:docs/models/error.model.dart';
import 'package:docs/repository/auth_repository.dart';
import 'package:docs/repository/doc_repo.dart';
import 'package:docs/repository/sharedrepo.dart';
import 'package:docs/repository/socket_repo.dart';
import 'package:docs/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:routemaster/routemaster.dart';

class DocumentPage extends ConsumerStatefulWidget {
  final String id;
  const DocumentPage({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentPageState();
}

class _DocumentPageState extends ConsumerState<DocumentPage> {
  quill.QuillController? _controller;
  final FocusNode editorFocusNode = FocusNode();
  ErrorModel? data;
  ErrorModel? errorModel;
  SocketRepo socketRepo = SocketRepo();
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document');

  void updateTitle(WidgetRef ref, String title) {
    ref.read(docRepositoryProvider).updateDocTitile(
        token: ref.read(userProvider)!.token, docId: widget.id, title: title);
  }

  @override
  void initState() {
    super.initState();
    socketRepo.joinRoom(widget.id);
    fetchDcoData();
    socketRepo.changeListener((data) => {
          _controller?.compose(
            quill.Delta.fromJson(data['delta']),
            _controller?.selection ?? const TextSelection.collapsed(offset: 0),
            quill.ChangeSource.REMOTE,
          ),
        });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepo.autoSave(<String, dynamic>{
        'docId': widget.id,
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });
  }

  fetchDcoData() async {
    errorModel = await ref
        .read(docRepositoryProvider)
        .getMyDocByID(token: ref.read(userProvider)!.token, id: widget.id);
    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      _controller = quill.QuillController(
        document: errorModel!.data.contents.isEmpty
            ? quill.Document()
            : quill.Document.fromDelta(
                quill.Delta.fromJson(
                  errorModel!.data.contents,
                ),
              ),
        selection: const TextSelection.collapsed(offset: 0),
      );

      setState(() {});
    }

    _controller!.document.changes.listen((event) {
      if (event.item3 == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {
          'delta': event.item2,
          'room': widget.id,
        };
        socketRepo.tryping(map);
      }
    });
    data = await ref
        .watch(authRepositoryProvider)
        .getAllEmail(ref.read(userProvider)!.token);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: Loader()),
      );
    }
    if (!(errorModel!.data.uid == ref.read(userProvider)!.uid ||
        errorModel!.data.sharedUser.contains(ref.read(userProvider)!.email))) {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/accdid.png')),
            ),
            const Text(
              'You don\'t have access for this document',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Document Name - ${errorModel!.data.title}',
                style: const TextStyle(fontSize: 15, color: Colors.black38),
              ),
            ),
          ],
        )),
      );
    }
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          // leading: const SizedBox(),
          actions: [
            if (width > 1000)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    final text = _controller!.document.toPlainText();

                    final blob = html.Blob([text]);
                    final url = html.Url.createObjectUrlFromBlob(blob);
                    final anchor =
                        html.document.createElement('a') as html.AnchorElement
                          ..href = url
                          ..style.display = 'none'
                          ..download = errorModel!.data.title + '.txt';
                    html.document.body!.children.add(anchor);

                    anchor.click();

                    html.document.body!.children.remove(anchor);
                    html.Url.revokeObjectUrl(url);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download TXT'),
                ),
              ),
            if (width <= 1000)
              Padding(
                padding:
                    const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                child: InkWell(
                  onTap: () {
                    final text = _controller!.document.toPlainText();

                    final blob = html.Blob([text]);
                    final url = html.Url.createObjectUrlFromBlob(blob);
                    final anchor =
                        html.document.createElement('a') as html.AnchorElement
                          ..href = url
                          ..style.display = 'none'
                          ..download = errorModel!.data.title + '.txt';
                    html.document.body!.children.add(anchor);

                    anchor.click();

                    html.document.body!.children.remove(anchor);
                    html.Url.revokeObjectUrl(url);
                  },
                  child: Container(
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.green,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            if (width <= 1000)
              Padding(
                padding:
                    const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                child: InkWell(
                  onTap: () {
                    try {
                      ShareRepo().modalBottomSheetMenu(
                        context: context,
                        documentModel: errorModel!.data,
                        emails: data!.data['email'] ?? [],
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            //   ),
            // ClipOval(
            //     child: IconButton(
            //         onPressed: () {}, icon: const Icon(Icons.download))),
            if (width > 1000)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    try {
                      ShareRepo().modalBottomSheetMenu(
                        context: context,
                        documentModel: errorModel!.data,
                        emails: data!.data['email'] ?? [],
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString(),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.red,
            //     ),
            //     onPressed: () async {
            //       ref.read(docRepositoryProvider).deleteDocById(
            //           token: ref.read(userProvider)!.token,
            //           id: errorModel!.data.id);
            //       Routemaster.of(context).pop(true);
            //     },
            //     icon: const Icon(Icons.delete),
            //     label: const Text('Delete'),
            //   ),
            // ),
          ],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Routemaster.of(context).replace('/');
                  },
                  child: const Icon(
                    FontAwesomeIcons.dochub,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.blue,
                      )),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) => updateTitle(
                      ref,
                      value,
                    ),
                  ),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
              color: Colors.grey.shade500,
              width: 0.1,
            ))),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              quill.QuillToolbar.basic(controller: _controller!),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Card(
                    elevation: 1,
                    child: SizedBox(
                      width: 1200,
                      //height: 2000,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: quill.QuillEditor(
                          controller: _controller!,
                          scrollable: true,
                          scrollController: ScrollController(),
                          focusNode: editorFocusNode,
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          autoFocus: true,
                          readOnly: false,
                          // onImagePaste: (imageBytes) async {
                          //   return await imageBytes.toString();
                          // },
                          onLaunchUrl: (value) => CommUtil.openUrl(value),
                          floatingCursorDisabled: false,
                          enableInteractiveSelection: true,
                          expands: true,
                          enableSelectionToolbar: true,
                          paintCursorAboveText: true,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
