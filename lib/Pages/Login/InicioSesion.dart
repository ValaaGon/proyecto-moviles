import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> inicioSesion() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? authentication =
      await googleUser!.authentication;
  final credentials = GoogleAuthProvider.credential(
    accessToken: authentication?.accessToken,
    idToken: authentication?.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credentials);
}
