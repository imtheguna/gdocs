import 'dart:async';
import 'package:docs/models/error.model.dart';
import 'package:docs/models/peviewmodel.dart';
import 'package:docs/repository/auth_repository.dart';
import 'package:docs/repository/doc_repo.dart';
import 'package:docs/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class DocView extends ConsumerStatefulWidget {
  final String id;
  final bool isData;
  const DocView({
    super.key,
    required this.id,
    required this.isData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocViewState();
}

class _DocViewState extends ConsumerState<DocView> {
  quill.QuillController? _controller;
  final f = DateFormat('yyyy-MM-dd hh:mm');
  final FocusNode editorFocusNode = FocusNode();
  ErrorModel? errorModel;
  String docId = '';
  @override
  void initState() {
    super.initState();
    docId = widget.id;
    fetchDcoData();
  }

  void singOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).singOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDoc(WidgetRef ref, BuildContext context) async {
    String token = ref.read(userProvider)!.token;

    final navigator = Routemaster.of(context);
    final sMessage = ScaffoldMessenger.of(context);

    final errorModel =
        await ref.read(docRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      sMessage.showSnackBar(
        SnackBar(
          content: Text(
            errorModel.error!,
          ),
        ),
      );
    }
  }

  fetchDcoData() async {
    errorModel = await ref
        .read(docRepositoryProvider)
        .getMyDocByID(token: ref.read(userProvider)!.token, id: docId);

    if (errorModel!.data != null) {
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
  }

  Future<String> getCurrentDoc() async {
    return ref.watch(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 15, right: 20, bottom: 15),
      //color: Colors.red,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 80,
            //color: Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (errorModel != null && errorModel!.data != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Document Name - ${errorModel!.data.title}'),
                        Text(
                            'Created At - ${(f.format(errorModel!.data.createdAt)).toString()}'),
                        if (errorModel!.data.sharedUser.length != 0)
                          const Text('Shared')
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: ElevatedButton.icon(
                          onPressed: () => singOut(ref),
                          icon: const Icon(
                            Icons.logout,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          label: const Padding(
                            padding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 4, right: 4),
                            child: Text('LogOut'),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: ElevatedButton.icon(
                          onPressed: () => createDoc(ref, context),
                          icon: const Icon(
                            Icons.add,
                          ),
                          label: const Padding(
                            padding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 4, right: 4),
                            child: Text('Create New Document'),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.isData && errorModel != null)
            FutureBuilder<String?>(
                future: getCurrentDoc(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }

                  if (snapshot.data != docId) {
                    docId = snapshot.data!;
                    fetchDcoData();
                  }
                  if (_controller == null) {
                    return const Loader();
                  }
                  try {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Card(
                          elevation: 4,
                          child: SizedBox(
                            width: 1200,
                            //height: 2000,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: quill.QuillEditor(
                                controller: _controller!,
                                scrollable: true,
                                scrollController: ScrollController(),
                                focusNode: editorFocusNode,
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                autoFocus: false,
                                readOnly: true,
                                expands: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } catch (e) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.history,
                              color: Colors.black12,
                              size: 150,
                            ),
                            Text(
                              'No document created!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black38,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
          if (!widget.isData)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.history,
                      color: Colors.black12,
                      size: 150,
                    ),
                    Text(
                      'No document created!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black38,
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
