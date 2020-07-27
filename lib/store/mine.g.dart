// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mine.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MineStore on _MineStore, Store {
  final _$faceUrlAtom = Atom(name: '_MineStore.faceUrl');

  @override
  String get faceUrl {
    _$faceUrlAtom.reportRead();
    return super.faceUrl;
  }

  @override
  set faceUrl(String value) {
    _$faceUrlAtom.reportWrite(value, super.faceUrl, () {
      super.faceUrl = value;
    });
  }

  final _$nickNameAtom = Atom(name: '_MineStore.nickName');

  @override
  String get nickName {
    _$nickNameAtom.reportRead();
    return super.nickName;
  }

  @override
  set nickName(String value) {
    _$nickNameAtom.reportWrite(value, super.nickName, () {
      super.nickName = value;
    });
  }

  final _$identifierAtom = Atom(name: '_MineStore.identifier');

  @override
  String get identifier {
    _$identifierAtom.reportRead();
    return super.identifier;
  }

  @override
  set identifier(String value) {
    _$identifierAtom.reportWrite(value, super.identifier, () {
      super.identifier = value;
    });
  }

  final _$genderAtom = Atom(name: '_MineStore.gender');

  @override
  int get gender {
    _$genderAtom.reportRead();
    return super.gender;
  }

  @override
  set gender(int value) {
    _$genderAtom.reportWrite(value, super.gender, () {
      super.gender = value;
    });
  }

  final _$selfSignatureAtom = Atom(name: '_MineStore.selfSignature');

  @override
  String get selfSignature {
    _$selfSignatureAtom.reportRead();
    return super.selfSignature;
  }

  @override
  set selfSignature(String value) {
    _$selfSignatureAtom.reportWrite(value, super.selfSignature, () {
      super.selfSignature = value;
    });
  }

  final _$locationAtom = Atom(name: '_MineStore.location');

  @override
  String get location {
    _$locationAtom.reportRead();
    return super.location;
  }

  @override
  set location(String value) {
    _$locationAtom.reportWrite(value, super.location, () {
      super.location = value;
    });
  }

  final _$loadAsyncAction = AsyncAction('_MineStore.load');

  @override
  Future<void> load([bool forceUpdate]) {
    return _$loadAsyncAction.run(() => super.load(forceUpdate));
  }

  @override
  String toString() {
    return '''
faceUrl: ${faceUrl},
nickName: ${nickName},
identifier: ${identifier},
gender: ${gender},
selfSignature: ${selfSignature},
location: ${location}
    ''';
  }
}
