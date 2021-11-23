class Command {
  static List<int> manufacturerCMD = [0x00, 0x00, 0x7E];

  static List<int> despritionTagCMD = [0x0D, 0x00, 0x73];

  static List<int> upperlimitlowerTagCMD = [0x0F, 0x00, 0x71];

  static List<int> currentCMD = [0x02, 0x00, 0x7C];

  static List<int> processCMD = [0x1, 0x0, 0x7F];

  static List<int> tagCMDFirst = [0x12, 0x15];

  static List<int> tagCMDSecond = [
    0x14,
    0xA0,
    0x71,
    0xC7,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x0,
    0x00,
    0x00,
    0x00,
    0x7B
  ];

  static List<int> loopFirst = [0x28, 0x4];

  static List<int> loopSecond = [0x33];

  static List<int> outerLowCMD = [0x28, 0x4, 0x40, 0x80, 0x0, 0x0, 0x5A];

  static List<int> outerHighCMD = [0x28, 0x4, 0x41, 0xA0, 0x0, 0x0, 0x7B];
  static List<int> lowerCMD = [0x83, 0x5, 0xA, 0x0, 0x0, 0x0, 0x0, 0x3A];
  static List<int> higherCMD = [
    0x82,
    0x5,
    0xA,
    0x44,
    0xFA,
    0x0,
    0x0,
    0x85,
    0x0D,
    0x0A
  ];

  static List<int> zeroTrimCmd = [
    0x2B,
    0x0,
    0x55,
  ];

  static List<int> lcluclCmd = [
    0x23,
    0x9,
    0x4,
    0x44,
    0xF9,
    0xE0,
    0x0,
    0x3F,
    0x80,
    0x00,
    0x00,
    0xB2,
  ];
  static List<int> lcluclCmd1 = [0x23, 0x9];
  static List<int> lcluclCmd2 = [0xB2];

  static List<int> FetchlcluclCMD = [
    0xF,
    0x0,
    0x71,
  ];
}


//class Command {
//   static List<int> manufacturerCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//     0x00,
//     0x00,
//     0x7E,
//     0x0D,
//     0x0A
//   ];

//   static List<int> despritionTagCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//     0x0D,
//     0x00,
//     0x73,
//     0x0D,
//     0x0A
//   ];

//   static List<int> upperlimitlowerTagCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//     0x0F,
//     0x00,
//     0x71,
//     0x0D,
//     0x0A
//   ];

//   static List<int> currentCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//     0x02,
//     0x00,
//     0x7C,
//     0x0D,
//     0x0A
//   ];

//   //   static List<int> currentCMD = [
//   //   0xFF,
//   //   0xFF,
//   //   0xFF,
//   //   0xFF,
//   //   0xFF,
//   //   0x82,
//   //   0xB7,
//   //   0x04,
//   //   0x2D,
//   //   0xAD,
//   //   0xCF,
//   //   0x02,
//   //   0x00,
//   //   0x7C,
//   //   0x0D,
//   //   0x0A
//   // ];
//   static List<int> processCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//     0x1,
//     0x0,
//     0x7F,
//     0x0D,
//     0x0A
//   ];
//   // static List<int> processCMD = [
//   //   0xFF,
//   //   0xFF,
//   //   0xFF,
//   //   0xFF,
//   //   0xFF,
//   //   0x82,
//   //   0xB7,
//   //   0x04,
//   //   0x26,
//   //   0xA9,
//   //   0x08,
//   //   0x28,
//   //   0x4,
//   //   0x41,
//   //   0xA0,
//   //   0x0,
//   //    0x0,
//   //    0x7b

//   // ];
//   static List<int> tagCMDFirst = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//     0x12,
//     0x15,
//     0x0D,
//     0x0A
//     // 0x04,
//     // 0x14,
//     // 0xC,
//     // 0x4,
//     // 0x14,
//     // 0xC,
//   ];

//   static List<int> tagCMDSecond = [
//     0x14,
//     0xA0,
//     0x71,
//     0xC7,
//     0x0,
//     0x40,
//     0x0,
//     0x0,
//     0x0,
//     0x0,
//     0x0,
//     0x0,
//     0x00,
//     0x00,
//     0x00,
//     0x3B,
//     0x0D,
//     0x0A
//   ];

//   static List<int> loopFirst = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x82, 0xB7, 0x4, 0x2D, 0xAD, 0xCF, 0x28, 0x4, 0x0D, 0x0A];

//   static List<int> loopSecond = [0x33, 0x0D, 0x0A];

//   static List<int> outerLowCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x26,
//     0xA9,
//     0x8,
//     0x28,
//     0x4,
//     0x40,
//     0x80,
//     0x0,
//     0x0,
//     0x5A,
//     0x0D,
//     0x0A
//   ];

//   static List<int> outerHighCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x26,
//     0xA9,
//     0x8,
//     0x28,
//     0x4,
//     0x41,
//     0xA0,
//     0x0,
//     0x0,
//     0x7B,
//     0x0D,
//     0x0A
//   ];
//   static List<int> lowerCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x26,
//     0xA9,
//     0x8,
//     0x83,
//     0x5,
//     0xA,
//     0x0,
//     0x0,
//     0x0,
//     0x0,
//     0x3A,
//     0x0D,
//     0x0A
//   ];
//   static List<int> higherCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x26,
//     0xA9,
//     0x8,
//     0x82,
//     0x5,
//     0xA,
//     0x44,
//     0xFA,
//     0x0,
//     0x0,
//     0x85,
//     0x0D,
//     0x0A
//   ];

//   static List<int> zeroTrimCmd = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//     0x2B,
//     0x0,
//     0x55,
//     0x0D,
//     0x0A
//   ];

//   static List<int> lcluclCmd = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//     0x23,
//     0x9,
//     0x4,
//     0x44,
//     0xF9,
//     0xE0,
//     0x0,
//     0x3F,
//     0x80,
//     0x00,
//     0x00,
//     0xB2,
//     0x0D,
//     0x0A
//   ];
//    static List<int> lcluclCmd1 = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//     0x23,
//     0x9,
//   ];
//    static List<int> lcluclCmd2 = [
//     0xB2,
//     0x0D,
//     0x0A
//   ];


//    static List<int> FetchlcluclCMD = [
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0xFF,
//     0x82,
//     0xB7,
//     0x04,
//     0x2D,
//     0xAD,
//     0xCF,
//    0xF,
//    0x0,
//    0x71,
//     0x0D,
//     0x0A
//   ];
// }

 
  
  