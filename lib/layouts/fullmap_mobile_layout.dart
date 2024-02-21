import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shiriki/constants/colors.dart';
import 'package:shiriki/providers.dart';

// 1. extend [ConsumerStatefulWidget]
class FullMapMobileLayout extends ConsumerStatefulWidget {
  const FullMapMobileLayout({super.key});

  @override
  ConsumerState<FullMapMobileLayout> createState() =>
      _FullMapMobileLayoutState();
}

// 2. extend [ConsumerState]
class _FullMapMobileLayoutState extends ConsumerState<FullMapMobileLayout> {
  late GoogleMapController mapController;
  late String _mapStyle;
  List<LatLng>? _pointLatLng;
  Marker? _start;
  Marker? _stop;
  Set<Polyline>? _polylineSet;
  List<LatLng>? _pointLatLngProposed;
  Marker? _startProposed;
  Marker? _stopProposed;
  Set<Polyline>? _polylineSetProposed;
  List<LatLng>? _pointLatLngMerged;
  Set<Polyline>? _polylineSetMerged;
  int _currentStep = 0;
  late bool isMainLine;
  late bool multipleMerged;

  String? _task;
  /*
  List<Step> _steps = [
    Step(
      title: Text('Create Main Pipes'),
      content: Text('Your content for creating main pipes goes here.'),
      isActive: true,
      state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
    ),
    const Step(
      title: Text('Create Connection Pipes'),
      content: Text('Your content for creating connection polyline goes here.'),
      isActive: false,
    ),
    const Step(
      title: Text('Complete Project Description'),
      content: Text(
          'Your content for completing the project description goes here.'),
      isActive: false,
    ),
  ];
 */
  //BitmapDescriptor? _pharmacyMarker;
  //BitmapDescriptor? _farPharmacyMarker;

  @override
  void initState() {
    super.initState();
    isMainLine = true;
    multipleMerged = false;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      //  _initialiseMarkerBitmap(context);
      rootBundle.loadString('assets/style/map_style.txt').then((string) {
        _mapStyle = string;
      });
    });
  }

  final LatLng _center =
      const LatLng(-1.2921, 36.8219); //const LatLng(-33.86, 151.20);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    final authhelper = ref.watch(authenticate);
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Stepper(
              onStepTapped: (int step) {
                setState(() {
                  _currentStep = step;
                  if (step == 0) {
                    isMainLine = true;
                  } else {
                    isMainLine = false;
                  }
                  debugPrint('step ${step + 1}');
                });
              },
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep == 0 && _currentStep < 2) {
                  setState(() {
                    _currentStep++;
                  });
                  debugPrint('step 1');
                } else if (_currentStep == 1 && _currentStep < 2) {
                  setState(() {
                    multipleMerged = false;
                    _startProposed = null;
                    _pointLatLngMerged = null;
                    //   _currentStep++;
                  });
                  debugPrint('step 2');
                } else {
                  debugPrint('step 3');
                  authhelper.signOut();
                  // authhelper.signOut();
                }
              },
              onStepCancel: () {
                if (_currentStep == 1 && _currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                  debugPrint('cancel step 2');
                } else if (_currentStep == 2 && _currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                  debugPrint('cancel step 3');
                } else {
                  debugPrint(' cancel step 1');
                }
              },
              steps: [
                Step(
                  title: Text('Create Main Pipes'),
                  content: SizedBox(
                    height: 150,
                    width: 300,
                    child: Image.asset(
                      'assets/images/mainpipeline.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  isActive: true,
                  state:
                      _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Create Connection Pipes'),
                  content: SizedBox(
                    height: 150,
                    width: 300,
                    child: Image.asset(
                      'assets/images/proposedpipeline.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  isActive: _currentStep >= 1,
                  state:
                      _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Complete Project Description'),
                  content: TextFormField(
                    maxLength: 500,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Description';
                      }
                      return null;
                    },
                    initialValue:
                        'The purpose of this project is to design a user-friendly and intuitive application that allows users to plan, create, manage and track their water supply projects efficiently.',
                    onSaved: (value) => _task = value!.trim(),
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        color: kblackgrey62606310,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    decoration: InputDecoration(
                      fillColor: kwhite25525525510,
                      filled: true,
                      hintText: '',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: kwhite21421421410, width: 1),
                        // borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: kwhite21421421410, width: 1),
                        // borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      focusColor: const Color.fromRGBO(243, 242, 242, 1),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: kwhite21421421410, width: 1),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      hintStyle: GoogleFonts.dmSans(
                        textStyle: const TextStyle(
                          color: kblackgrey62606310,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    maxLines: 10,
                    textAlign: TextAlign.start,
                  ),
                  isActive: _currentStep > 1,
                ),
              ],
              //_steps,
            ),
          ),
          Flexible(
            flex: 1,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              polylines:
                  isMainLine ? _polylineSet ?? {} : _polylineSetMerged ?? {},
              markers: {
                if (_start != null) _start!,
                if (_stop != null) _stop!,
                if (_startProposed != null) _startProposed!,
                if (_stopProposed != null) _stopProposed!,
              },
              onLongPress: isMainLine ? _addMainPipeLine : _addPropesedPipeLine,
            ),
          ),
        ],
      ),
    );
  }

  /*
  _initialiseMarkerBitmap(BuildContext context) async {
    await _bitmapDescriptorFromSvgAsset(
            context, 'assets/svg/ic_pharmacy_marker.svg', 45)
        .then((value) => _pharmacyMarker = value);
    await _bitmapDescriptorFromSvgAsset(
            context, 'assets/svg/ic_far_pharmacy_marker.svg', 45)
        .then((value) => _farPharmacyMarker = value);
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName, int width) async {
    // var svgString = await DefaultAssetBundle.of(context).loadString(assetName);
    final svgString =
        '<svg height="10" viewBox="0 0 10 10" width="10" xmlns="http://www.w3.org/2000/svg"><circle cx="5" cy="5" fill="#026b8f" r="5"/></svg>';
    final PictureInfo pictureInfo =
        await vg.loadPicture(SvgStringLoader(svgString), null);
    final ui.Image image = await pictureInfo.picture.toImage(505, 505);
    // .fromSvgString(svgString, "");
    //var picture = svgDrawableRoot.toPicture(
    //    size: Size(width.toDouble(), width.toDouble()));
    // var image = await picture.toImage(width, width);
    var bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  
  Future<Uint8List?> svgToByteData(String assetPath, Size size) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    //final svg = SvgBytesLoader(bytes);
    final DrawableRoot svgRoot = await svg.fromSvgBytes(bytes);
    final picture = svgRoot.toPicture(size: size);
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
  */

  void _addPropesedPipeLine(LatLng argument) {
    if (_startProposed == null) {
      String uniqueKey1 = DateTime.now().toIso8601String();
      //set origin
      debugPrint('start proposed marker');
      setState(() {
        _startProposed = Marker(
          markerId: MarkerId(uniqueKey1),
          infoWindow: const InfoWindow(title: 'origin proposed pipeline'),
          /*
          icon: kIsWeb
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
                */
          position: argument,
        );

        //Reset destination
        //_start = null;
        // _stop = null;
        // _pointLatLng = null;
      });
    } else if (_stopProposed == null ||
        (_startProposed != null && _stopProposed != null)) {
      String uniqueKey2 = DateTime.now().toIso8601String();
      debugPrint('endpoint proposed marker');
      setState(() {
        _stopProposed = Marker(
          markerId: MarkerId(uniqueKey2),
          infoWindow: const InfoWindow(title: 'proposed line endpoint'),
          /*
          icon: kIsWeb
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
                */
          position: argument,
        );
        if (_polylineSetMerged != null && multipleMerged == false) {
          // called when marking start of first proposed polyline
          final list = [_points(_startProposed!), _points(_stopProposed!)];
          _pointLatLngMerged ??= list;
          _polylineSetMerged!.add(_polyineProposed(list));
          multipleMerged = true;
        } else {
          //called when expanding proposed polyline
          final list = [_points(_stopProposed!)];
          _pointLatLngMerged!.addAll(list);
          _polylineSetMerged!.add(_polyineProposed(_pointLatLngMerged!));
        }

        if (_pointLatLngProposed != null && _polylineSetProposed != null) {
          _pointLatLngProposed!.addAll([_points(_stopProposed!)]);
          _polylineSetProposed!.add(_polyineProposed(_pointLatLngProposed!));
          // _polylineSetMerged!.add(_polyineProposed(_pointLatLngProposed!));
        } else {
          _pointLatLngProposed ??= [
            _points(_startProposed!),
            _points(_stopProposed!)
          ];
          _polylineSetProposed ??= {_polyineProposed(_pointLatLngProposed!)};
          // _polylineSetMerged ??= {_polyineProposed(_pointLatLngProposed!)};
        }
      });
    }
  }

  void _addMainPipeLine(LatLng argument) {
    if (_start == null) {
      String uniqueKey1 = DateTime.now().toIso8601String();
      debugPrint('start main marker');
      //set origin
      setState(() {
        _start = Marker(
          markerId: MarkerId(uniqueKey1),
          infoWindow: const InfoWindow(title: 'origin main pipeline'),
          icon: kIsWeb
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
          position: argument,
        );

        //Reset destination
        //_start = null;
        // _stop = null;
        // _pointLatLng = null;
      });
    } else if (_stop == null || (_start != null && _stop != null)) {
      String uniqueKey2 = DateTime.now().toIso8601String();
      debugPrint('endpoint main marker');
      setState(() {
        _stop = Marker(
          markerId: MarkerId(uniqueKey2),
          infoWindow: const InfoWindow(title: 'main pipeline endpoint'),
          icon: kIsWeb
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
          position: argument,
        );
        if (_pointLatLng != null && _polylineSet != null) {
          _pointLatLng!.addAll([_points(_stop!)]);
          _polylineSet!.add(_polyine(_pointLatLng!));
          _polylineSetMerged!.add(_polyine(_pointLatLng!));
        } else {
          _pointLatLng ??= [_points(_start!), _points(_stop!)];
          _polylineSet ??= {_polyine(_pointLatLng!)};
          _polylineSetMerged ??= {_polyine(_pointLatLng!)};
        }
      });
    }
  }

  LatLng _points(Marker marker) {
    final point = LatLng(marker.position.latitude, marker.position.longitude);
    return point;
  }

  Polyline _polyine(List<LatLng> list) {
    String uniqueKey3 = DateTime.now().toIso8601String();
    if (list.length > 2) {
      List<LatLng> lastTwoElements = list.sublist(list.length - 2);
      final polyline = Polyline(
        // onTap: () {},
        polylineId: PolylineId(uniqueKey3),
        color: Colors.red,
        width: 5,
        visible: true,
        geodesic: true,
        points: lastTwoElements
            .map(
              (e) => LatLng(e.latitude, e.longitude),
            )
            .toList(),
      );
      return polyline;
    } else {
      final polyline = Polyline(
        // onTap: () {},
        polylineId: PolylineId(uniqueKey3),
        color: Colors.red,
        width: 5,
        visible: true,
        geodesic: true,
        points: list
            .map(
              (e) => LatLng(e.latitude, e.longitude),
            )
            .toList(),
      );
      return polyline;
    }
  }

  Polyline _polyineProposed(List<LatLng> list) {
    String uniqueKey3 = DateTime.now().toIso8601String();
    if (list.length > 2) {
      List<LatLng> lastTwoElements = list.sublist(list.length - 2);
      final polyline = Polyline(
        // onTap: () {},
        polylineId: PolylineId(uniqueKey3),
        color: kgreen02075310,
        width: 5,
        visible: true,
        geodesic: true,
        points: lastTwoElements
            .map(
              (e) => LatLng(e.latitude, e.longitude),
            )
            .toList(),
      );
      return polyline;
    } else {
      final polyline = Polyline(
        // onTap: () {},
        polylineId: PolylineId(uniqueKey3),
        color: kgreen02075310,
        width: 5,
        visible: true,
        geodesic: true,
        points: list
            .map(
              (e) => LatLng(e.latitude, e.longitude),
            )
            .toList(),
      );
      return polyline;
    }
  }
}
