import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService();

  Future<void> initialize() async {
    final clientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];

    if (clientId == null) {
      throw Exception('GOOGLE_WEB_CLIENT_ID missing in .env');
    }

    await GoogleSignIn.instance.initialize(serverClientId: clientId);
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
        .authenticate();

    if (googleUser == null) {
      throw Exception('Google Sign-In cancelled by the user');
    }

    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
