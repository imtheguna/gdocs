// import 'package:dropdown_search2/dropdown_search2.dart';
import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:docs/repository/auth_repository.dart';
import 'package:docs/repository/doc_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docs/models/doc.model.dart';

class ShareRepo {
  void modalBottomSheetMenu({
    required BuildContext context,
    required DocumentModel documentModel,
    required List emails,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (builder) {
        return Container(
          height: 500,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: SelectUsrt(
            srcContext: context,
            emails: emails,
            documentModel: documentModel,
          ),
        );
      },
    );
  }
  // static showBottomSheet({
  //   required BuildContext context,
  //   required DocumentModel documentModel,
  //   required List emails,
  // }) {
  //   return showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15.0),
  //     ),
  //     backgroundColor: Colors.white,
  //     builder: (_) {
  //       return Container(
  //         height: 500,
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(15.0),
  //             topRight: Radius.circular(15.0),
  //           ),
  //         ),
  //         child: SelectUsrt(
  //           srcContext: context,
  //           emails: emails,
  //           documentModel: documentModel,
  //         ),
  //       );
  //     },
  //   );
  // }
}

class SelectUsrt extends ConsumerStatefulWidget {
  final BuildContext srcContext;
  final DocumentModel documentModel;
  final List emails;

  const SelectUsrt(
      {required this.srcContext,
      required this.documentModel,
      required this.emails,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectUsrtState();
}

class _SelectUsrtState extends ConsumerState<SelectUsrt> {
  final TextEditingController editingController = TextEditingController();
  //final List selectedEmails = [];

  List<dynamic> selectedValue = [];
  updatemails(List emails) {
    ref.read(docRepositoryProvider).updateSharedList(
        token: ref.read(userProvider)!.token,
        docId: widget.documentModel.id,
        emails: emails);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.documentModel.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: IconButton(
                    onPressed: () => Navigator.of(widget.srcContext).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomSearchableDropDown(
              //  menuMode: true,
              searchBarHeight: 70,
              showLabelInMenu: true,
              items: widget.emails,
              labelStyle: const TextStyle(fontSize: 15),
              label: 'Select Email',
              multiSelectTag: 'Email',
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              multiSelect: true,
              menuHeight: 100,
              prefixIcon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.search),
              ),
              dropDownMenuItems: widget.emails,
              onChanged: (value) {
                if (value != null) {
                  selectedValue = jsonDecode(value);
                  setState(() {});
                } else {
                  selectedValue.clear();
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20, bottom: 20),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      updatemails(widget.emails);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.orangeAccent,
                          content: Text(
                              'Your Document mark as Public, Anyone can access now and and link Copied to ClipBoard'),
                        ),
                      );
                      Clipboard.setData(ClipboardData(
                          text:
                              'https://gdocs.gktwinapp.com//document/${widget.documentModel.id}'));
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    icon: const Icon(Icons.select_all),
                    label: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Mark as Public Document'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      updatemails(selectedValue);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                              'Document Shared and link Copied to ClipBoard'),
                        ),
                      );
                      Clipboard.setData(ClipboardData(
                          text:
                              'http://gdocs.gktwinapp.com/document/${widget.documentModel.id}'));
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.email_rounded),
                    label: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Share',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
