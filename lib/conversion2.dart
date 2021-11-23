import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:core';

List<int> getNumConversation(String data) {
  var loopCode = double.parse(data);
  List<int> myList = Float32List.fromList([loopCode]).buffer.asUint8List();
  List<int> bytes = new List.from(myList.reversed);
  return bytes;
  // ByteData bdata = ByteData(4);
  // bdata.setFloat32(0, data);
  // List<int> arrayData = bdata.buffer.asUint8List();
  // return arrayData;
}

List<int> isSubArray(List<int> A, List<int> B, int len) {
  int n = A.length;
  int m = B.length;
  int i = 0, j = 0;
  while (i < n && j < m) {
    if (A[i] == B[j]) {
      i++;
      j++;
      if (j == m) {
        return A.sublist(i, i + len);
      }
    } else {
      i = i - j + 1;
      j = 0;
    }
  }
  return [-1];
}

List<int> codeConversation(String data2) {
  print(data2);
  String data = data2.toUpperCase();
  List<int> numeric = [];
  for (int i = 0; i < data.length; i++) {
    int tempValue = utf8.encode(data[i])[0] - 64;
    if (tempValue < 0) {
      numeric.add(tempValue + 64);
    } else {
      numeric.add(tempValue);
    }
  }
  int length = (numeric.length / 4).ceil();
  int reminder = (numeric.length % 4);
  for (int i = length * 4 - (4 - reminder); i < length * 4; i++) {
    numeric.add(0);
  }
  int value1 = 0;
  int value2 = 0;
  int value3 = 0;
  int twoiterations = 0;
  int sixiterations = 0;
  int count = 0;
  List<int> finalData = [];
  int index = 0;
  while (length > index) {
    value1 =
        (256 * numeric[4 * index + 0] + numeric[4 * index + 1]) & 0xffffffff;
    value2 =
        (256 * numeric[4 * index + 2] + numeric[4 * index + 3]) & 0xffffffff;
    value3 = (256 * 256 * value1 + value2) & 0xffffffff;
    int i = 0;
    while (i < 4) {
      for (int i = 0; i < 2; i++) {
        value3 = value3 << 1;
        var num = value3 & 0xffffffff;
        twoiterations = num.toInt();
      }
      for (int i = 0; i < 6; i++) {
        if (count != 0) {
          count = count << 1;
          count = count & 0xffffffff;
        }
        if (value3 >> 31 == 1) {
          count++;
          count = count & 0xffffffff;
        }

        value3 = value3 << 1;
        value3 = value3 & 0xffffffff;
        sixiterations = value3 & 0xffffffff;
      }
      value3 = twoiterations << 6;
      value3 = value3 & 0xffffffff;
      i++;
    }

    var finalValue = count.toRadixString(16);
    var secondValue = count % 65536;
    var firstValue = (count / 65536).floor();

    finalData.add(firstValue % 256);
    finalData.add((secondValue / 256).floor());
    finalData.add(secondValue % 256);

    value1 = 0;
    value2 = 0;
    value3 = 0;
    twoiterations = 0;
    sixiterations = 0;
    count = 0;
    index++;
  }
  print(':::::::::::::::::::::::::::::::::::::::::::::::');
  print(finalData);
  print(':::::::::::::::::::::::::::::::::::::::::::::::');
  for (int i = finalData.length; i < 6; i++) {
    finalData.add(0);
  }
  print(':::::::::::::::::::::::::::::::::::::::::::::::');
  print(finalData);
  print(':::::::::::::::::::::::::::::::::::::::::::::::');
  return (finalData);
}

String reverseConversation(List<int> data2) {
  String text = '';
  List<int> dataConvert = [];
  int length = (data2.length / 3).ceil();

  List<int> numeric1 = data2.sublist(0, 3);
  List<int> numeric2 = data2.sublist(3, 6);
  List<int> numeric = data2;
  int value1 = 0;
  int value2 = 0;
  int value3 = 0;
  int index = 0;
  double twoiterations = 0;
  double count = 0;
  double sixiterations = 0;
  bool flag = false;
  while (length > index) {
    count = 0;
    value1 = (256 * numeric[3 * index + 1] + numeric[3 * index + 2]);
    value3 = (256 * 256 * numeric[3 * index + 0] + value1);
    int i = 0;
    int d = 1;
    while (i < 4) {
      for (int i = 0; i < 6; i++) {
        if (value3 % 2 == 1) {
          value3 = value3 >> 1;

          count = ((count.ceil() / 2).toInt() | 0x80000000).toDouble();

          continue;
        }

        if (value3 % 2 == 0) {
          count = count / 2;
          count = count;
        }
        value3 = value3 >> 1;
        value3 = value3;
        print(value3);
        print(count);
        print('-----------------');
      }
      count = count / 4;
      i++;
    }
    double genuis1 = count / 65536;
    double genuis2 = count % 65536;
    double genuis3 = genuis1 / 256;
    double genuis4 = genuis1 % 256;
    double genuis5 = genuis2 / 256;
    double genuis6 = genuis2 % 256;

    dataConvert
        .add(genuis3.round() > 48 ? genuis3.round() - 64 : genuis3.round());
    dataConvert
        .add(genuis4.round() > 48 ? genuis4.round() - 64 : genuis4.round());
    dataConvert
        .add(genuis5.round() > 48 ? genuis5.round() - 64 : genuis5.round());
    dataConvert
        .add(genuis6.round() > 48 ? genuis6.round() - 64 : genuis6.round());

    index++;
  }

  for (int i = 0; i < 8; i++) {
    text += String.fromCharCode(dataConvert[i] + 64);
  }
  return text;
}
