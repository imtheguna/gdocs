import 'package:docs/models/constants.dart';
import 'package:docs/models/doc.model.dart';
import 'package:docs/models/error.model.dart';
import 'package:docs/models/peviewmodel.dart';
import 'package:docs/repository/auth_repository.dart';
import 'package:docs/repository/doc_repo.dart';
import 'package:docs/widgets/loader.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class DocList extends ConsumerStatefulWidget {
  DocList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocListState();
}

class _DocListState extends ConsumerState<DocList> {
  final f = DateFormat('yyyy-MM-dd hh:mm');
  Future<void> navigatetoDoc(BuildContext context, String docId) async {
    Routemaster.of(context).push('/document/$docId');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //print(width);
    ref.watch(docRepositoryProvider).getMyDocs(ref.watch(userProvider)!.token);
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 254, 162, 23),
              Colors.orangeAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp), // color: Colors.orangeAccent,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (ref.read(userProvider)!.profilePic != '')
                    SizedBox(
                      height: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: ExtendedImage.network(
                          ref.read(userProvider)!.profilePic.trim(),
                          enableLoadState: true,
                          fit: BoxFit.contain,
                          cache: true,
                          borderRadius: BorderRadius.circular(10.0),
                          loadStateChanged: (ExtendedImageState state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.failed:
                                state.reLoadImage();
                                return const SizedBox(
                                    height: 50,
                                    width: 70,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ));

                              case LoadState.loading:
                                return const SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ));

                              case LoadState.completed:
                                if (state.wasSynchronouslyLoaded) {
                                  return state.completedWidget;
                                }
                            }
                            // return SizedBox(
                            //   height: 40,
                            //   width: 40,
                            //   child: Image(
                            //       image: NetworkImage(ref
                            //           .read(userProvider)!
                            //           .profilePic
                            //           .trim())),
                            // );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.read(userProvider)!.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            ref.read(userProvider)!.email,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 10,
              top: 10,
              bottom: 10,
            ),
            child: Text(
              'Documents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            //  maxHeight: 450,
            // constraints: const BoxConstraints(maxHeight: 300, minHeight: 100.0),
            child: SizedBox(
              width: double.infinity,
              // height: double.infinity,
              //height: 490,
              child: FutureBuilder<ErrorModel?>(
                future: ref
                    .watch(docRepositoryProvider)
                    .getMyDocs(ref.watch(userProvider)!.token),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  if (snapshot.data!.data.length == 0) {
                    return Center(
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
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: ((context, index) {
                      DocumentModel documentModel = snapshot.data!.data[index];
                      return InkWell(
                        onTap: () {
                          if (width > 800) {
                            ref
                                .watch(counterProvider.notifier)
                                .increment(documentModel.id);
                          } else {
                            navigatetoDoc(
                              context,
                              documentModel.id,
                            );
                          }
                        },
                        onDoubleTap: () => navigatetoDoc(
                          context,
                          documentModel.id,
                        ),
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.only(
                            left: 6,
                            right: 6,
                            bottom: 10,
                            top: 10,
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(left: 2, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  documentModel.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  (f.format(documentModel.createdAt))
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black38,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     print('k');
                          //   },
                          //   child: Positioned(
                          //     right: 0,
                          //     child: Container(
                          //       height: 40,
                          //       width: 40,
                          //       decoration: const BoxDecoration(
                          //           color: Color.fromARGB(255, 250, 204, 134),
                          //           borderRadius: BorderRadius.all(
                          //               Radius.circular(10))),
                          //     ),
                          //   ),
                          // ),
                        )),
                      );
                    }),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
