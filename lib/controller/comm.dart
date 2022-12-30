import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CommUtil {
  static openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  static share(String text) async {
    Share.share(text);
  }
}


// lass CreateDiaryScreen extends StatefulWidget {
// const CreateDiaryScreen({Key? key}) : super(key: key);

// @override
// State<CreateDiaryScreen> createState() => _CreateDiaryScreenState();
// }

// class _CreateDiaryScreenState extends State<CreateDiaryScreen> {
// bool isDaySelected = false;
// QuillController quillController = QuillController.basic();
// String imageUrl = '';
// int imagesCount = 0;
// final FocusNode _focusNode = FocusNode();
// TextEditingController titleController = TextEditingController();
// final ScrollController _scrollController = ScrollController();
// final _formKey = GlobalKey<FormState>();

// DateTime _focusedDay = DateTime.now();

// DateTime? _selectedDay;

// late CalendarFormatChangedCubit calendarFormatChangedCubit;

// Future<String> _onImagePickCallback(File file) async {
//  String url =
//     await context.read<UploadImageCubit>().uploadDiaryImageToFirebase(file);
// //print('image callback url :$url');
// //
// // final appDocDir = await getApplicationDocumentsDirectory();
// // final copiedFile =
// //     await file.copy('${appDocDir.path}/${Path.basename(file.path)}');
// // return copiedFile.path.toString();
//  return url;
// }

// createDiary() {
//  Document document = quillController.document;
//  var json = jsonEncode(quillController.document.toDelta().toJson());
//  print(
//      'Plain text: ${quillController.document.toPlainText().replaceAll(RegExp(r'[￼ \n]'), '   
// ').trim()}');

// if (_formKey.currentState!.validate()) {
//   ///second check whether user enter some data or not in quill editor.
//   if (quillController.document.toPlainText().length > 1) {
//     if (isDaySelected) {
//       BlocProvider.of<CreateDiaryCubit>(context).uploadDiary(
//         diaryTitle: titleController.text,
//         diaryText: quillController.document
//             .toPlainText()
//             .replaceAll(RegExp(r'[￼]'), ' ')

//             /// to remove ￼ and \n from string.
//             .trim(),
//         diaryImage: imageUrl,
//         diaryFullDocument: quillController.document,
//         diarySelectedDate: _selectedDay ?? DateTime.now(),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select date'),
//         ),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Please enter description'),
//       ),
//     );
//    }
//   }
// }

// Widget _customEmbedBuilder(BuildContext context, Embed embed, bool boooll) {
//  switch (embed.value.type) {
//   case BlockEmbed.imageType:
//     return _buildImage(context, embed);
//   case BlockEmbed.horizontalRuleType:
//     return const Divider();
//   default:
//     throw UnimplementedError(
//         'Embed "${embed.value.type}" is not supported.');
//   }
//  }

// Widget _buildImage(BuildContext context, Embed embed) {
//   final imageUrl = embed.value.data;
//   return Container(
//   height: 160.sp,
//   width: 1.sw,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(8.sp),
//   ),
//   child: imageUrl.startsWith('http')
//       ? ClipRRect(
//           borderRadius: BorderRadius.circular(12.sp),
//           child: CachedNetworkImage(
//             imageUrl: imageUrl,
//             imageBuilder: (context, imageProvider) => Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             placeholder: (context, url) => Center(
//               child: SizedBox(
//                 height: 50.sp,
//                 width: 50.sp,
//                 child: const CircularProgressIndicator(
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             ),
//             errorWidget: (context, url, error) => const Icon(Icons.error),
//           ),
//         )
//       : imageUrl.toString().isEmpty
//           ? const SizedBox()
//           : isBase64(imageUrl)
//               ? ClipRRect(
//                   borderRadius: BorderRadius.circular(12.sp),
//                   child: Image.memory(
//                     base64.decode(imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 )
//               : Stack(
//                   children: [
//                     SizedBox(
//                       width: 1.sw,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12.sp),
//                         child: Image.file(
//                           File(imageUrl),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       right: 10.sp,
//                       top: 5.sp,
//                       child: Container(
//                         width: 21.58.sp,
//                         height: 21.58.sp,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.black.withOpacity(0.1),
//                         ),
//                         child: Center(
//                           child: InkWell(
//                               onTap: () {
//                                 print('tapped');
//                               },
//                               child: Icon(
//                                 Icons.close,
//                                 size: 16.sp,
//                               )),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//    );
//   }

// @override
//   void initState() {
//   print('init called');
//   // TODO: implement initState
//   super.initState();
//   calendarFormatChangedCubit =
//      BlocProvider.of<CalendarFormatChangedCubit>(context);
//   _focusNode.addListener(() {
//   if (_focusNode.hasFocus) {
//     ///when focus then change calendar format to week
//     calendarFormatChangedCubit.onCalendarFormatChanged(CalendarFormat.week);
//    }
//  });
//  }

//  @override
//  void dispose() {
//  super.dispose();
//  calendarFormatChangedCubit.resetCalendarStates();
//  }

//  showDiaryPostDiscardDialog(BuildContext context) {
//   showDialog(
//   context: context,
//   builder: (context) => AlertDialog(
//       title: const Text('Discard Diary?'),
//       content: const Text('If you go back, you will lose your diary post.'),
//       actions: <Widget>[
//         TextButton(
//             child: const Text(
//               'Yes',
//               style: TextStyle(color: AppColors.primaryColor),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             }),
//         TextButton(
//             child: const Text('No',
//                 style: TextStyle(color: AppColors.primaryColor)),
//             onPressed: () => Navigator.of(context).pop(false)),
//        ]),
//   );
//  }

//  @override
//  Widget build(BuildContext context) {
//  return WillPopScope(
//   onWillPop: () async {
//     if (quillController.document.toPlainText().length > 1 ||
//         _formKey.currentState!.validate()) {
//       /// if condition passed, mean that user typed something into textfield and also written 
//  some description
//       /// and show alert dialog of diary discard alert.
//       showDiaryPostDiscardDialog(context);
//       return false;
//     } else {
//       Navigator.of(context).pop(true);
//       return true;
//     }
//   },
//   child: Scaffold(
//     resizeToAvoidBottomInset: true,
//     backgroundColor: const Color(0xffFCFEFF),
//     appBar: CustomAppBar(
//         appBarTitle: 'Add diary',
//         diaryAppBar: true,
//         onTickPressed: createDiary),
//     body: MultiBlocListener(
//       listeners: [
//         BlocListener<CreateDiaryCubit, CreateDiaryState>(
//           listener: (context, state) {
//             if (state is DiarySubmitionSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Diary created successfully'),
//                   duration: Duration(milliseconds: 1500),
//                 ),
//               );
//               Navigator.pop(context);
//               titleController.clear();
//               quillController.clear();
//             }
//             if (state is DiarySubmitionNoInternetError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content:
//                       Text('No internet, please connect your internet'),
//                   duration: Duration(milliseconds: 1500),
//                 ),
//               );
//             }
//             if (state is DiarySubmitionFailed) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Could not create diary, please try again'),
//                   duration: Duration(milliseconds: 1500),
//                 ),
//               );
//             }
//             if (state is DiarySubmitionError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('An error occured while uploading diary'),
//                   duration: Duration(milliseconds: 1500),
//                 ),
//               );
//             }
//           },
//         ),
//         BlocListener<CalendarDaySelectedCubit, CalendarDaySelectedState>(
//           listener: (context, state) {
//             if (state is CalendarDaySelected) {
//               isDaySelected = state.isDaySelected;
//               _focusedDay = state.focusDay;
//               _selectedDay = state.selectedDay;
//             }
//           },
//         ),
//         BlocListener<UploadImageCubit, UploadImageState>(
//           listener: (context, state) {
//             if (state is UploadingImage) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: SizedBox(
//                       height: 25.sp, child: SnackBarUploadingWidget()),
//                 ),
//               );
//             }
//           },
//         ),
//         BlocListener<UploadImageCubit, UploadImageState>(
//           listener: (context, state) {
//             if (state is UploadedImage) {
//               ///this is to check as to only first image url upload to firestore document, so 
//   we create counter image check.
//               imagesCount++;
//               if (imagesCount == 1) {
//                 imageUrl = state.url;
//               }
//             }
//             if (state is UploadingImageFiled) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Error occur'),
//                 ),
//               );
//             }
//           },
//         ),
//       ],
//       child: Column(
//         children: [
//           Expanded(
//             flex: 20,
//             child: Column(
//               children: [
//                 ///calendar, title and description
//                 Align(
//                   alignment: Alignment.topCenter,
//                   child: Container(
//                     width: 340.sp,
//                     // height: 360 + 15.sp,
//                     margin: EdgeInsets.symmetric(
//                         horizontal: 16.sp, vertical: 0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.0.r),
//                       color: AppColors.backgroundColor,
//                     ),
//                     child: Stack(
//                       children: [
//                         DiaryCalendarWidget(),

//                         ///calendar pin
//                         Positioned(
//                           top: 12.sp,
//                           left: 1.sw / 2 - 80.sp,
//                           child: const CalendarPins(),
//                         ),

//                         ///calendar pin
//                         Positioned(
//                           top: 12.sp,
//                           left: 1.sw / 2 + 40.sp,
//                           child: const CalendarPins(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 ///title textField
//                 Container(
//                   margin:
//                       EdgeInsets.symmetric(horizontal: 16.sp, vertical: 0),
//                   child: Form(
//                     key: _formKey,
//                     child: CustomTextField(
//                       validator: (titleText) {
//                         RegExp titleRegExp = RegExp(r"^[a-zA-Z0-9]+//$");
//                         if (titleText!.isEmpty) {
//                           return 'Enter Title.';
//                         } else if (titleText.length < 20) {
//                           return 'Title should be more than 15 characters';
//                         } else {
//                           final title = titleText;
//                         }
//                         return null;
//                       },
//                       controller: titleController,
//                       keyboardType: TextInputType.text,
//                       textHeight: 20.sp,
//                     ),
//                   ),
//                 ),

//                 ///text customization section
//                 Expanded(
//                   flex: 10,
//                   child: Container(
//                     padding: EdgeInsets.only(left: 16.sp, right: 16.sp),
//                     child: BlocBuilder<CreateDiaryCubit, CreateDiaryState>(
//                       builder: (context, state) {
//                         if (state is DiarySubmitting) {
//                           return const CircularProgressIndicator(
//                             color: AppColors.primaryColor,
//                           );
//                         } else {
//                           return Scrollbar(
//                             controller: _scrollController,
//                             isAlwaysShown: true,
//                             child: QuillEditor(
//                                 scrollController: _scrollController,
//                                 paintCursorAboveText: true,
//                                 embedBuilder: _customEmbedBuilder,
//                                 scrollPhysics:
//                                     const ClampingScrollPhysics(),
//                                 customStyleBuilder: (dynamic) {
//                                   return GoogleFonts.poppins(
//                                     fontSize: 14.sp,
//                                     color: const Color(0xff969798),
//                                   );
//                                 },
//                                 controller: quillController,
//                                 scrollable: true,
//                                 focusNode: _focusNode,
//                                 autoFocus: false,
//                                 readOnly: false,
//                                 placeholder:
//                                     'Your diary description here...',
//                                 expands: false,
//                                 padding:
//                                     EdgeInsets.symmetric(horizontal: 8.sp),
//                                 customStyles: DefaultStyles(
//                                   paragraph: DefaultTextBlockStyle(
//                                       GoogleFonts.poppins(
//                                         fontSize: 14.sp,
//                                         color: Colors.black,
//                                         height: 1.15,
//                                         fontWeight: FontWeight.w300,
//                                       ),
//                                       const Tuple2(16, 0),
//                                       const Tuple2(0, 0),
//                                       null),
//                                   h1: DefaultTextBlockStyle(
//                                       GoogleFonts.poppins(
//                                         fontSize: 32.sp,
//                                         color: Colors.black,
//                                         height: 1.15,
//                                         fontWeight: FontWeight.w300,
//                                       ),
//                                       const Tuple2(16, 0),
//                                       const Tuple2(0, 0),
//                                       null),
//                                   sizeSmall: const TextStyle(fontSize: 9),
//                                 )),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 width: 1.sw,
//                 padding:
//                     EdgeInsets.symmetric(horizontal: 4.sp, vertical: 5.sp),
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       offset: Offset(0, 3.0),
//                       blurRadius: 16.0,
//                     ),
//                   ],
//                 ),
//                 child: QuillToolbar.basic(
//                   multiRowsDisplay: false,
//                   toolbarIconSize: 24.sp,
//                   controller: quillController,
//                   onImagePickCallback: _onImagePickCallback,
//                   iconTheme: const QuillIconTheme(
//                       iconUnselectedFillColor: Colors.white,
//                       iconUnselectedColor: AppColors.grey,
//                       iconSelectedFillColor: AppColors.primaryColor),
//                   showVideoButton: false,
//                   mediaPickSettingSelector: _selectMediaPickSetting,
//                   showAlignmentButtons: true,
//                   showHistory: false,
//                   showItalicButton: false,
//                   showStrikeThrough: false,
//                   showCodeBlock: false,
//                   showInlineCode: false,
//                   showIndent: false,
//                   showUnderLineButton: false,
//                   showCameraButton: true,
//                   showJustifyAlignment: false,
//                   showListNumbers: false,
//                   showDividers: false,
//                   showClearFormat: false,
//                   showHeaderStyle: false,
//                   showLeftAlignment: false,
//                   showCenterAlignment: false,
//                   showRightAlignment: false,
//                   showQuote: true,
//                   showLink: false,
//                   showListCheck: false,
//                   showSmallButton: true,
//                  ),
//               ),
//             ),
//           ),
//         ],
//         ),
//       ),
//     ),
//    );
//  }

//  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) =>
//   showDialog<MediaPickSetting>(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       contentPadding: EdgeInsets.zero,
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           TextButton.icon(
//             icon: Icon(
//               DiaryIcons.image_gallery,
//               color: AppColors.primaryColor,
//               size: 18.sp,
//             ),
//             label: Text(
//               'Gallery',
//               style: GoogleFonts.poppins(color: AppColors.primaryColor),
//             ),
//             onPressed: () => Navigator.pop(ctx, MediaPickSetting.Gallery),
//           ),
//           TextButton.icon(
//             icon: const Icon(Icons.link, color: AppColors.primaryColor),
//             label: Text(
//               '  Link  ',
//               style: GoogleFonts.poppins(color: AppColors.primaryColor),
//             ),
//             onPressed: () => Navigator.pop(ctx, MediaPickSetting.Link),
//           )
//         ],
//       ),
//      ),
//     );
//  }