import 'dart:io';
import 'dart:ui' as ui;
import 'package:face_smile_detection/utils/z_colors.dart';
import 'package:face_smile_detection/viewmodel/details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../utils/face_painter.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({
    Key? key,
    required this.faces,
    required this.imagesPicked,
  }) : super(key: key);
  final List<Face> faces;
  final File imagesPicked;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final DetailsViewModel _detailsViewModel = DetailsViewModel();
  List<Color> colorsList = [];
  ui.Image? _image;

  @override
  void initState() {
    colorsList = _detailsViewModel.colorsGeneratedList(widget.faces);
    _detailsViewModel.loadImage(widget.imagesPicked).then((value) {
      setState(() {
        _image = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: ZColors.primary,
            expandedHeight: 200,
            flexibleSpace: Container(
              color: ZColors.primary,
              child: FlexibleSpaceBar(
                background: (_image == null)
                    ? LinearProgressIndicator(
                        color: colorsList[0],
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(widget.imagesPicked, fit: BoxFit.cover),
                          ClipRRect(
                            child: BackdropFilter(
                              filter:
                                  ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                color: Colors.grey.withOpacity(0.1),
                                alignment: Alignment.center,
                                child: Center(
                                  child: FittedBox(
                                    child: SizedBox(
                                      width: _image!.width.toDouble(),
                                      height: _image!.height.toDouble(),
                                      child: CustomPaint(
                                        painter: FacePainter(
                                            _image!, widget.faces, colorsList),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: widget.faces.isEmpty
                ? const Center(
                    child: Text(
                      "No faces detected,Try again",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: widget.faces.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: colorsList[index]),
                                child: Icon(
                                  _detailsViewModel.faceMotion(
                                      widget.faces[index].smilingProbability! *
                                          100),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            "Face ${index + 1}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              const Text(
                                "smile probability",
                              ),
                              Flexible(
                                child: LinearPercentIndicator(
                                  lineHeight: 20,
                                  barRadius: const ui.Radius.circular(5),
                                  percent:
                                      widget.faces[index].smilingProbability!,
                                  center: Text(
                                    "${(widget.faces[index].smilingProbability! * 100).toStringAsFixed(2)}%",
                                    style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  progressColor: colorsList[index],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
          )
        ],
      ),
    );
  }
}
