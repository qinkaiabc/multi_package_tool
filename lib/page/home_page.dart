import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mult_package_tool/model/Line.dart';
import 'package:mult_package_tool/provider/provider_widget.dart';
import 'package:mult_package_tool/view_model/package_model.dart';

import '../util/image_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProviderWidget<PackageModel>(
          model: PackageModel(),
          onModelReady: (packageModel) => packageModel.init(),
          builder: (BuildContext context, PackageModel packageModel, Widget child) {
            return Container(
              decoration:
                  BoxDecoration(image: DecorationImage(image: ImageUtils.getAssetImage('background', format: ImageFormat.jpg), fit: BoxFit.fill)),
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
                        Text('APK文件：', style: TextStyle(fontSize: 20, color: Colors.white)),
                        Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.white))),
                          child: Text(packageModel.apkFilePath ?? '请选择需要打包的APK文件',
                              style: TextStyle(fontSize: 18, color: ObjectUtil.isNotEmpty(packageModel.apkFilePath) ? Colors.white : Colors.white70)),
                        ),
                        InkWell(
                          onTap: () => packageModel.apkFileChoose(),
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
                        Text('渠道文件：', style: TextStyle(fontSize: 20, color: Colors.white)),
                        Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.white))),
                          child: Text(packageModel.channelFilePath ?? '请选择渠道文件',
                              style: TextStyle(
                                  fontSize: 18, color: ObjectUtil.isNotEmpty(packageModel.channelFilePath) ? Colors.white : Colors.white70)),
                        ),
                        InkWell(
                          onTap: () => packageModel.channelFileChoose(),
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
                        Text('输出目录：', style: TextStyle(fontSize: 20, color: Colors.white)),
                        Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.white))),
                          child: Text(packageModel.outputPath ?? '请选择输出目录',
                              style: TextStyle(fontSize: 18, color: ObjectUtil.isNotEmpty(packageModel.outputPath) ? Colors.white : Colors.white70)),
                        ),
                        InkWell(
                          onTap: () => packageModel.outputDirectoryChoose(),
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
                        Text('工具文件：', style: TextStyle(fontSize: 20, color: Colors.white)),
                        Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Colors.white))),
                          child: Text(packageModel.toolPath ?? '请选择打包工具文件',
                              style: TextStyle(fontSize: 18, color: ObjectUtil.isNotEmpty(packageModel.toolPath) ? Colors.white : Colors.white70)),
                        ),
                        InkWell(
                          onTap: () => packageModel.toolFileChoose(),
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
                      onTap: () => packageModel.runCommand(),
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
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
                        controller: packageModel.controller,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 50),
                            child: StreamBuilder<List<Line>>(
                              stream: packageModel.linesCtl.stream,
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
                                            style: TextStyle(color: line is ErrLine ? Colors.red : Colors.white, fontSize: 14),
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
            );
          }),
    );
  }
}
