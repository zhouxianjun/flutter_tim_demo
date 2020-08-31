import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiniu/flutter_qiniu.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/components/common_bar.dart';
import 'package:tim_demo/constant/index.dart';
import 'package:tim_demo/store/mine.dart';
import 'package:tim_demo/util/im.dart';

class UserFace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserFace();
  }
}

class _UserFace extends State<UserFace> {
  /// 我的信息存储
  MineStore mineStore;

  /// 图片选择器
  final ImagePicker _imagePicker = ImagePicker();

  /// 七牛云存储
  final FlutterQiniu _qiniu = FlutterQiniu(zone: QNFixedZone.zone2);

  Widget renderActionSheet(context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text('拍照'),
          onPressed: () {
            _chooseImage(ImageSource.camera);
            Navigator.of(context).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: Text('从手机相册选择'),
          onPressed: () {
            _chooseImage(ImageSource.gallery);
            Navigator.of(context).pop();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('取消'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  _chooseImage(ImageSource source) async {
    PickedFile pickedFile = await _imagePicker.getImage(source: source);
    if (pickedFile == null) {
      return null;
    }
    File file = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
    );
    if (file == null) {
      return;
    }
    modifySelfFace(file);
  }

  modifySelfFace(File file) async {
    String key =
        'face.url.${mineStore.identifier}.${DateTime.now().millisecondsSinceEpoch}';
    String token = createUploadToken();
    String url = await _qiniu.uploadFile(file.path, key, token);
    await TencentImPlugin.modifySelfProfile(
        params: {'Tag_Profile_IM_Image': '$ossDomain/$url'});
    mineStore.load(true);
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mineStore = Provider.of<MineStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonBar(
        title: '个人头像',
        centerTitle: true,
        rightDMActions: <Widget>[
          InkWell(
            child: Image.asset('assets/images/right_more.png'),
            onTap: () {
              showCupertinoModalPopup(
                  context: context, builder: (_) => renderActionSheet(context));
            },
          )
        ],
      ),
      body: Container(
          child: PhotoView(
        imageProvider: CachedNetworkImageProvider(mineStore.faceUrl),
      )),
    );
  }
}
