import 'dart:io';

import 'package:face_smile_detection/utils/z_colors.dart';
import 'package:face_smile_detection/view/detailsView.dart';
import 'package:face_smile_detection/viewmodel/home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  File? _pickedImageFile;
  List<Face>? _faces;
  final options = FaceDetectorOptions();
  final HomePageViewModel _homePageViewModel = HomePageViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Developed by",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Text(
                  "Zakaria Rebouhi",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      color: ZColors.grey),
                ),
              ],
            ),
          ),
          const Divider(),
          Card(
            color: ZColors.primary,
            child: ListTile(
              onTap: () async {
                await launchUrl(Uri.parse("https://github.com/ZakariaRebouhi"));
              },
              leading:
                  const FaIcon(FontAwesomeIcons.github, color: ZColors.white),
              title: const Text(
                "Cource code",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: ZColors.white,
                ),
              ),
            ),
          ),
          Card(
            color: ZColors.second,
            child: ListTile(
              onTap: () async {
                await launchUrl(Uri(
                  scheme: 'mailto',
                  path: 'zakaria.rebouhi.brb@gmail.com',
                ));
              },
              leading: const FaIcon(
                FontAwesomeIcons.envelope,
                color: ZColors.black,
              ),
              title: const Text(
                "Contact developer by gmail",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Card(
            color: ZColors.primary,
            child: ListTile(
              onTap: () async {
                await launchUrl(
                    Uri.parse("https://telegram.me/Zakaria_rebouhi"));
              },
              leading: const FaIcon(
                FontAwesomeIcons.paperPlane,
                color: ZColors.white,
              ),
              title: const Text(
                "Contact developer by telegram",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: ZColors.white,
                ),
              ),
            ),
          ),
          Card(
            color: ZColors.second,
            child: ListTile(
              onTap: () async {
                await launchUrl(Uri.parse(
                    "https://play.google.com/store/apps/developer?id=Zakaria+Rebouhi&hl=en&gl=US"));
              },
              leading: const FaIcon(
                FontAwesomeIcons.googlePlay,
                color: ZColors.black,
              ),
              title: const Text(
                "More applications",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ]),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              FontAwesomeIcons.bars,
              color: ZColors.black,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: ZColors.transparent,
        elevation: 0,
        title: const Text(
          "Face detection",
          style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: ZColors.black,
              fontSize: 20),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.circleInfo,
                      color: ZColors.black,
                      size: 18,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Select image with faces",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Then view image details",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: ZColors.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: (_pickedImageFile == null)
                      ? Image.asset("assets/images/faces.png")
                      : Image.file(_pickedImageFile!),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: ZColors.primary,
                    minimumSize: const Size.fromHeight(50),
                    padding: const EdgeInsets.all(15),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.image),
                  label: const Text(
                    "Select images",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(
                                child: Text(
                              'Select image from',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                            actions: [
                              ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.camera),
                                  style: ElevatedButton.styleFrom(
                                    primary: ZColors.primary,
                                    minimumSize: const Size.fromHeight(50),
                                    padding: const EdgeInsets.all(15),
                                  ),
                                  onPressed: () async {
                                    _pickedImageFile = await _homePageViewModel
                                        .pickImageFromCamera();
                                    setState(() {});
                                    if (mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  label: const Text(
                                    "Camera",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              ElevatedButton.icon(
                                icon:
                                    const FaIcon(FontAwesomeIcons.solidFolder),
                                style: ElevatedButton.styleFrom(
                                  primary: ZColors.second,
                                  minimumSize: const Size.fromHeight(50),
                                  padding: const EdgeInsets.all(15),
                                ),
                                label: const Text(
                                  "Gallery",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () async {
                                  _pickedImageFile = await _homePageViewModel
                                      .pickImageFromGallery();
                                  setState(() {});
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: ZColors.second,
                      minimumSize: const Size.fromHeight(50),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () async {
                      if (_pickedImageFile == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  "No images added",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: const Text(
                                  "please add image",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      color: ZColors.grey),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                      "Okay",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          color: ZColors.primary),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        final options = FaceDetectorOptions(
                            enableClassification: true,
                            enableContours: true,
                            enableLandmarks: true,
                            enableTracking: true,
                            performanceMode: FaceDetectorMode.accurate);
                        final faceDetector = FaceDetector(options: options);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text(
                                  "Image processing...",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: LinearProgressIndicator(
                                  color: ZColors.primary,
                                ),
                              );
                            });
                        _faces = await faceDetector.processImage(
                            InputImage.fromFile(_pickedImageFile!));
                        if (mounted) {
                          Navigator.of(context).pop();
                        }

                        if (_faces == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    "images process error",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  content: const Text(
                                    "can't process image,try again",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: ZColors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Okay",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            color: ZColors.primary),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        } else {
                          if (_faces!.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("No faces"),
                                    content: const Text(
                                        "we have not detect any face, try with another picture"),
                                    actions: [
                                      TextButton(
                                        child: const Text("ok"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          } else {
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsView(
                                          faces: _faces!,
                                          imagesPicked: _pickedImageFile!,
                                        )),
                              );
                            }
                          }
                        }
                      }
                    },
                    icon: const FaIcon(FontAwesomeIcons.usersViewfinder,
                        color: ZColors.black),
                    label: const Text(
                      "Scan",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: ZColors.black),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
