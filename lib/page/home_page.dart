import 'dart:async';
import 'dart:convert';

import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

import '../util/image_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

abstract class Line {
  final String text;

  Line(this.text);
}

class OutLine extends Line {
  OutLine(String text) : super(text);
}

class ErrLine extends Line {
  ErrLine(String text) : super(text);
}

class _HomePageState extends State<HomePage> {
  String apkFilePath, channelFilePath, outputPath;
  ScrollController _controller = ScrollController();
  final _stdoutCtlr = StreamController<List<int>>();
  final _stderrCtlr = StreamController<List<int>>();
  final _linesCtlr = StreamController<List<Line>>();
  var _lines = <Line>[];
  var shell;

  void _addLine(Line line) {
    _lines.add(line);
    // Limit line count
    if (_lines.length > 100) {
      _lines = _lines.sublist(20);
    }
    _linesCtlr.add(_lines);
  }

  @override
  void initState() {
    super.initState();
    utf8.decoder.bind(_stdoutCtlr.stream).transform(const LineSplitter()).listen((text) {
      _addLine(OutLine(text));
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    utf8.decoder.bind(_stderrCtlr.stream).transform(const LineSplitter()).listen((text) {
      _addLine(ErrLine(text));
    });
    shell = Shell(stdout: _stdoutCtlr.sink, stderr: _stderrCtlr.sink);
  }

  @override
  void dispose() {
    _stdoutCtlr.close();
    _stderrCtlr.close();
    _linesCtlr.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: ImageUtils.getAssetImage('background', format: ImageFormat.jpg), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image(
                image: ImageUtils.getAssetImage('logo'),
                width: 100,
                height: 100,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Text('APK路径：', style: TextStyle(fontSize: 20, color: Colors.white)),
                  Container(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.white))),
                    child: Text(apkFilePath ?? '请选择需要打包的APK文件', style: TextStyle(fontSize: 18, color: Colors.white70)),
                  ),
                  InkWell(
                    onTap: () async {
                      FileChooserResult result = await showOpenPanel(allowsMultipleSelection: false);
                      if (result != null) {
                        setState(() {
                          apkFilePath = result.paths?.first;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.white)),
                      child: Text('选择', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Text('渠道路径：', style: TextStyle(fontSize: 20, color: Colors.white)),
                  Container(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.white))),
                    child: Text(channelFilePath ?? '请选择渠道文件', style: TextStyle(fontSize: 18, color: Colors.white70)),
                  ),
                  InkWell(
                    onTap: () async {
                      FileChooserResult result = await showOpenPanel(allowsMultipleSelection: false);
                      if (result != null) {
                        setState(() {
                          channelFilePath = result.paths?.first;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.white)),
                      child: Text('选择', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Text('输出路径：', style: TextStyle(fontSize: 20, color: Colors.white)),
                  Container(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.white))),
                    child: Text(outputPath ?? '请选择输出目录', style: TextStyle(fontSize: 18, color: Colors.white70)),
                  ),
                  InkWell(
                    onTap: () async {
                      FileChooserResult result = await showOpenPanel(allowsMultipleSelection: false, canSelectDirectories: true);
                      if (result != null) {
                        setState(() {
                          outputPath = result.paths?.first;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.white)),
                      child: Text('选择', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  await shell.run('dart --version');
                },
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.white)),
                  child: Text('开始打包', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  controller: _controller,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 50),
                      child: StreamBuilder<List<Line>>(
                        stream: _linesCtlr.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: snapshot.data
                                .map((line) => Text(
                                      line.text ?? '',
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
