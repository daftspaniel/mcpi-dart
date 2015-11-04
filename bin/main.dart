// Copyright (c) 2015, Davy Mitchell. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import '../lib/mcdart.dart';
import 'dart:math' as math;

Minecraft mci;

main() async {
  // Connect to the server.
  mci = new Minecraft();
  await mci.connect("192.168.0.106", 4711);

  // Run the demos.
  chatDemo();

  blockDemo();

  await posDemo();

  digMine(); //TODO : Convert from Python script.

  buildRainbow();

  await mci.disconnect();
}

/// Send a message to chat.
chatDemo() {
  print("Chat Demo Start");
  mci.chat("Dart is awesome!");
  mci.chat("Minecraft is awesome!");
  print("Chat Demo End");
}

/// Build a wall of shiny blocks - x,y,z pos relative to player.
blockDemo() {
  print("Block Demo : Start...");
  for (int i = 0; i < 42; i++) {
    mci
      ..setBlock(11, i, 0, Block.GOLD_BLOCK)
      ..setBlock(13, i, 0, Block.DIAMOND_BLOCK)
      ..setBlock(15, i, 0, Block.WOOL)
      ..setBlock(17, i, 0, Block.LEAVES);
  }
  print("Block Demo : End.");
}

/// Retrieve position of the player.
// TODO : Convert to int?
posDemo() async {
  print("Position Demo : Start...");
  var s = (await mci.getPos());
  print("Player position $s");
  print("Position : Demo End.");
}

/// Dig a staircase mine.
void digMine() {}


/// Build a rainbow out of wool.
void buildRainbow() {
  print("Starting rainbow construction...");

  List<int> woolColors = [14, 1, 4, 5, 3, 11, 10];
  int height = 54;
  double y;
  for (int x = 0; x < 128; x++) {
    for (int ci = 0; ci < woolColors.length; ci++) {
      y = math.sin((x / 128.0) * math.PI) * height + ci;
      mci.setBlock(x - 24, y.round(), 0, Block.WOOL, ci);
    }
  }
  print("Built a rainbow!");
}
