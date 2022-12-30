import 'package:docs/controller/comm.dart';
import 'package:docs/models/doc.model.dart';
import 'package:docs/models/error.model.dart';

import 'package:docs/pages/doclist.dart';
import 'package:docs/pages/preview.dart';
import 'package:docs/repository/auth_repository.dart';
import 'package:docs/repository/doc_repo.dart';
import 'package:docs/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    void createDoc(WidgetRef ref, BuildContext context) async {
      Navigator.pop(context);
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

    void singOut(WidgetRef ref) {
      ref.read(authRepositoryProvider).singOut();
      ref.read(userProvider.notifier).update((state) => null);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FloatingActionButton(
          child: const Icon(Icons.menu),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: Colors.white,
              builder: (BuildContext context) {
                return Container(
                    margin: const EdgeInsets.all(5.0),
                    height: 300,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                height: 70,
                                width: 70,
                                child: Image.asset('assets/logo22.png')),
                            const Text(
                              "GDocs",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                        ListTile(
                          onTap: () => createDoc(ref, context),
                          leading: const Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                          title: const Text('Create New Document'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            CommUtil.share(
                                'check out my website https://gdocs.gktwinapp.com');
                          },
                          leading: const Icon(Icons.share, color: Colors.blue),
                          title: const Text('Share'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            singOut(ref);
                          },
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.blue,
                          ),
                          title: const Text('Logout'),
                        )
                      ],
                    ));
              },
            );
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: FutureBuilder<ErrorModel?>(
                    future: ref
                        .watch(docRepositoryProvider)
                        .getMyDocs(ref.watch(userProvider)!.token),
                    builder: (context, snapshot) {
                      return DocList();
                    })),
            if (width > 900)
              const SizedBox(
                width: 20,
              ),
            if (width > 1000)
              Expanded(
                flex: 3,
                child: FutureBuilder<ErrorModel?>(
                    future: ref
                        .watch(docRepositoryProvider)
                        .getMyDocs(ref.watch(userProvider)!.token),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loader();
                      }
                      if (snapshot.data!.data.length == 0) {
                        return const DocView(
                          id: '',
                          isData: false,
                        );
                      }
                      DocumentModel documentModel = snapshot.data!.data[0];
                      return DocView(
                        id: documentModel.id,
                        isData: true,
                      );
                    }),
              ),
          ],
        ),
      ),
    );
  }
}
