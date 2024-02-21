import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:shiriki/models/user_model.dart';
import 'package:shiriki/pages/fullmap_page.dart';
import 'package:shiriki/services/auth_service.dart';

import '../constants/colors.dart';
import '../pages/home_page.dart';

enum EmailSignInFormType { signIn, register }

class LoginMobileLayout extends StatefulWidget {
  const LoginMobileLayout({super.key});

  @override
  State<LoginMobileLayout> createState() => _LoginMobileLayoutState();
}

class _LoginMobileLayoutState extends State<LoginMobileLayout> {
  final _auth = AuthService();
  EmailSignInFormType _formType = EmailSignInFormType.register;
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  late GoogleMapController mapController;
  late String _mapStyle;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString('assets/style/map_style_dark.txt').then((string) {
        _mapStyle = string;
      });
    });
  }

  final LatLng _center =
      const LatLng(-1.2921, 36.8219); // const LatLng(-33.86, 151.20);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  void _toogleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    final form = _formKey.currentState!;
    form.reset();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      form.reset();
      return true;
    }
    return false;
  }

  Future<UserModel?> _logInEmail() async {
    try {
      if ((_formType == EmailSignInFormType.signIn) &&
          (_validateAndSaveForm())) {
        final user = await _logIn();
        debugPrint('log in');
        return user;
      } else if (_validateAndSaveForm()) {
        final user = await _register();
        debugPrint('register');
        return user;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<UserModel> _register() async {
    final user =
        await _auth.createUserWithEmailAndPassword(_email!, _password!);
    return user!;
  }

  Future<UserModel> _logIn() async {
    final user = await _auth.signInWithEmailAndPassword(_email!, _password!);
    return user!;
  }

  Future<UserModel> _loginGoogle() async {
    final user = await _auth.signInWithGoogle();
    return user!;
  }

  @override
  Widget build(BuildContext context) {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Log in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Log in';
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          PointerInterceptor(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
          ),
          PointerInterceptor(
            child: Center(
              child: Container(
                width: size.width / 3,
                height: size.height - 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: kwhite25525525505,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Shiriki App',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: kblue9813424010,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Plan and execute water supply projects',
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          height: 1.56,
                          color: kblackgrey79797907,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final user = await _loginGoogle();
                        /*
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullMapPage(
                                //   user: user,
                                ),
                          ),
                        );
                        */
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(248, 45),
                        side: const BorderSide(
                          width: 2,
                          color: kblackgrey79797910,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/new.png',
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Sign in with Google",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                height: 1.56,
                                color: kblackgrey79797910,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 99,
                          height: 2,
                          child: Divider(
                            height: 1,
                            color: kblackgrey79797903,
                          ),
                        ),
                        const SizedBox(
                          width: 17,
                        ),
                        Text(
                          'or',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: kblackgrey79797910,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 17,
                        ),
                        const SizedBox(
                          width: 99,
                          height: 2,
                          child: Divider(
                            height: 1,
                            color: kblackgrey79797903,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 248,
                      child: _buildForm(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        final user = await _logInEmail();
                        /*
                        if (user != null) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                user: user,
                              ),
                            ),
                          );
                        }
                        */
                      },
                      color: kblue9813424010,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      height: 55,
                      minWidth: 248,
                      child: Text(
                        primaryText,
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: kwhite25525525510,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        _toogleFormType();
                      },
                      child: Text(
                        secondaryText,
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: kblue9813424010,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      Text(
        'Email',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: kblackgrey48484810,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email';
          }
          return null;
        },
        initialValue: '',
        onSaved: (value) => _email = value!.trim(),
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: kblackgrey62606310,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Image.asset(
            'assets/images/user1.png',
          ),
          fillColor: kwhite25525525510,
          label: Text(
            ' Email ',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: kblackgrey62606310,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          filled: true,
          hintText: '',
          labelStyle: const TextStyle(
            color: kblackgrey62606310,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusColor: const Color.fromRGBO(243, 242, 242, 1),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintStyle: GoogleFonts.dmSans(
            textStyle: const TextStyle(
              color: kblackgrey62606310,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        maxLines: 1,
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        height: 30,
      ),
      Text(
        'Password',
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            color: kblackgrey48484810,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password';
          }
          return null;
        },
        initialValue: '',
        onSaved: (value) => _password = value!.trim(),
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            color: kblackgrey62606310,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        decoration: InputDecoration(
          prefixIcon: Image.asset(
            'assets/images/padlock.png',
          ),
          fillColor: kwhite25525525510,
          filled: true,
          label: Text(
            ' Password ',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: kblackgrey62606310,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          hintText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusColor: const Color.fromRGBO(243, 242, 242, 1),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kblackgrey79797910, width: 0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintStyle: GoogleFonts.dmSans(
            textStyle: const TextStyle(
              color: kblackgrey62606310,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        maxLines: 1,
        textAlign: TextAlign.start,
      ),
    ];
  }
}
