import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String webClientId2 =
      '419762667916-4arr4bhdn84i934or8iq7vqpv73hrl0n.apps.googleusercontent.com';
  final String webClientId1 =
      '419762667916-ubqsqe2cgf589j62qen3juelsoutor30.apps.googleusercontent.com';
  //final FacebookAuth _facebookAuth = FacebookAuth.instance;

  /* AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignin,
    FacebookAuth? facebookAuth,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _facebookAuth = facebookAuth ?? FacebookAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();*/

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(
      uid: user.uid,
      photoUrl: user.photoURL,
      displayName: user.displayName,
    );
  }

  Stream<UserModel?> get onAuthStateChanged {
    return _firebaseAuth.idTokenChanges().map(_userFromFirebase);
  }

  Future<UserModel?> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<UserModel?> signInWithGoogle() async {
    final googleSignIn = kIsWeb
        ? GoogleSignIn(
            clientId: webClientId1,
          )
        : GoogleSignIn(
            // scopes: [
            //   'email',
            //   'profile',
            // ],
            serverClientId: '',
            // clientId: kIsWeb ? webClientId : clientId,
          );
    GoogleSignInAccount? googleAccount = kIsWeb
        ? await googleSignIn.signInSilently()
        : await googleSignIn.signIn();
    if (kIsWeb && googleAccount == null) {
      googleAccount = await (googleSignIn.signIn());
    }
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (kIsWeb ||
          (googleAuth.accessToken != null && googleAuth.idToken != null)) {
        final authResult = await _firebaseAuth.signInWithCredential(
          kIsWeb
              ? GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                )
              : GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken,
                ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  /*
  Future<UserModel?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }
  */

  /*
  Future<UserModel?> signInWithFacebook() async {
    final LoginResult result = await _facebookAuth.login();
    if (result.status == LoginStatus.success) {
      // Create a credential from the access token
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      // Once signed in, return the UserCredential
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return _userFromFirebase(authResult.user);
    }
    return null;
  }
  */

  Future<UserModel?> signInWithPhoneNumber(String phoneno, String code) async {
    ConfirmationResult confirmationResult =
        await _firebaseAuth.signInWithPhoneNumber(
      phoneno,
    );
    UserCredential userCredential = await confirmationResult.confirm(code);
    return _userFromFirebase(userCredential.user);
  }

  Future<ConfirmationResult> signInWithPhoneNumber2(String string) async {
    ConfirmationResult confirmationResult =
        await _firebaseAuth.signInWithPhoneNumber(
      string,
    );

    return confirmationResult;
  }

  Future<UserModel?> signInWithOTPCode(
      ConfirmationResult confirmationResult, String code) async {
    UserCredential userCredential = await confirmationResult.confirm(code);
    return _userFromFirebase(userCredential.user);
  }

  Future<UserModel?> signInWithOTP(String smsCode, String verId) async {
    AuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<UserModel?> currentUser() async {
    // ignore: await_only_futures
    final user = await _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }
}
