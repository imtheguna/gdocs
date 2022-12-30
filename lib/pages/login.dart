import 'package:docs/controller/comm.dart';
import 'package:docs/models/error.model.dart';
import 'package:docs/pages/home_page.dart';
import 'package:docs/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> signinWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessage = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final ErrorModel errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace('/');
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 70, 131, 235),
                    Color.fromARGB(255, 151, 180, 252),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
          child: Center(
            child: Card(
              child: Container(
                height: 450,
                width: 450,
                child: Column(
                  children: [
                    SizedBox(
                        height: 170,
                        width: 170,
                        child: Image.asset(
                          'assets/logo22.png',
                        )),
                    Text(
                      'G Docs',
                      style: GoogleFonts.tangerine(
                        fontSize: 40,
                      ), //tangerine(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => signinWithGoogle(ref, context),
                      icon: const Icon(Icons.login),
                      label: const Padding(
                        padding: EdgeInsets.only(
                            left: 5, top: 12, bottom: 12, right: 8),
                        child: Text('Sign in with Google'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        width > 900
                            ? 'This project is open source, so if you\'re interested, you can help shape the future.'
                            : 'This project is open source, so if you\'re interested,\n                  You can help shape the future.',
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Project Created & Maintained By',
                      style: TextStyle(color: Colors.black45),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const Text(
                      'Gunanithi C S',
                      style: TextStyle(color: Colors.black45),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => CommUtil.openUrl(
                                'https://www.linkedin.com/in/imtheguna/'),
                            child: const FaIcon(
                              FontAwesomeIcons.linkedinIn,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () => CommUtil.openUrl(
                                'https://github.com/imtheguna'),
                            child: const FaIcon(
                              FontAwesomeIcons.github,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () => CommUtil.openUrl(
                                'https://twitter.com/imtheguna'),
                            child: const FaIcon(
                              FontAwesomeIcons.twitter,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () => CommUtil.openUrl(
                                'https://medium.com/@csguna2000'),
                            child: const FaIcon(
                              FontAwesomeIcons.medium,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
