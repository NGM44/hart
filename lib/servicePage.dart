import 'dart:math';

class Service{
    double convertion(dynamic bytes) {
    var bits = (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | (bytes[3]);
    print(bits);
    var sign = ((bits >> 31) == 0) ? 1.0 : -1.0;
    var e = ((bits >> 23) & 0xff);
    var m = (e == 0) ? (bits & 0x7fffff) << 1 : (bits & 0x7fffff) | 0x800000;
    var f = sign * m * pow(2, e - 150);
    return f;
  }
}