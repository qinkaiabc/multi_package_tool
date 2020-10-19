import 'dart:async';
import 'dart:convert';

import 'package:file_chooser/file_chooser.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:mult_package_tool/model/Line.dart';
import 'package:process_run/shell.dart';

class PackageModel with ChangeNotifier {
  String apkFilePath, channelFilePath, outputPath;
  String toolPath = '/Applications/mult_package_tool.app/Contents/Frameworks/App.framework/Versions/A/Resources/flutter_assets/assets/file/walle-cli-all.jar';
  Shell shell;
  ScrollController controller = ScrollController();
  final stdoutCtl = StreamController<List<int>>();
  final stderrCtl = StreamController<List<int>>();
  final linesCtl = StreamController<List<Line>>();
  var _lines = <Line>[];

  void _addLine(Line line) {
    _lines.add(line);
    // Limit line count
    if (_lines.length > 100) {
      _lines = _lines.sublist(20);
    }
    linesCtl.add(_lines);
  }

  void init() {
    utf8.decoder.bind(stdoutCtl.stream).transform(const LineSplitter()).listen((text) {
      _addLine(OutLine(text));
      controller.jumpTo(controller.position.maxScrollExtent);
    });
    utf8.decoder.bind(stderrCtl.stream).transform(const LineSplitter()).listen((text) {
      _addLine(ErrLine(text));
    });
    shell = Shell(stdout: stdoutCtl.sink, stderr: stderrCtl.sink);
  }

  void apkFileChoose() async {
    FileChooserResult result = await showOpenPanel(allowsMultipleSelection: false);
    if (result != null) {
      apkFilePath = result.paths?.first;
      notifyListeners();
    }
  }

  void channelFileChoose() async {
    FileChooserResult result = await showOpenPanel(allowsMultipleSelection: false);
    if (result != null) {
      channelFilePath = result.paths?.first;
      notifyListeners();
    }
  }

  void outputDirectoryChoose() async {
    FileChooserResult result = await showOpenPanel(allowsMultipleSelection: false, canSelectDirectories: true);
    if (result != null) {
      outputPath = result.paths?.first;
      notifyListeners();
    }
  }

  void toolFileChoose() async {
    FileChooserResult result = await showOpenPanel(allowsMultipleSelection: false);
    if (result != null) {
      toolPath = result.paths?.first;
      notifyListeners();
    }
  }

  void runCommand() async {
    if (ObjectUtil.isEmpty(apkFilePath)) {
      _addLine(ErrLine('请选择需要打包的APK文件'));
      return;
    }
    if (ObjectUtil.isEmpty(channelFilePath)) {
      _addLine(ErrLine('请选择渠道文件'));
      return;
    }
    /*if (ObjectUtil.isEmpty(toolPath)) {
      _addLine(ErrLine('请选择打包工具文件'));
      return;
    }*/
    if (ObjectUtil.isEmpty(outputPath)) {
      _addLine(ErrLine('请选择输出目录'));
      return;
    }
    await shell.run('java -jar $toolPath batch -f $channelFilePath $apkFilePath $outputPath');
  }

  @override
  void dispose() {
    super.dispose();
    stdoutCtl.close();
    stderrCtl.close();
    linesCtl.close();
  }
}
