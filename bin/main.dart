// Copyright (c) 2015, Davy Mitchell. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import '../lib/mcdart.dart';
import 'dart:math' as math;

Minecraft mci;

main() async {

  // Connect to the server.
  mci = new Minecraft();
  await mci.connect("192.168.0.110", 4711);

  // Run the demos.
  chatDemo();

  blockDemo();

  await posDemo();

  digMine();//TODO : Convert from Python script.

  buildRainbow();
}

/// Send a message to chat.
chatDemo() {
  print("Chat Demo Start");
  mci.chat("Dart is awesome!");
  print("Chat Demo End");
}

/// Build a wall of shiny blocks - x,y,z pos relative to player.
blockDemo() {
  print("Block Demo Start");
  for (int i = 0; i < 99; i++) {
    mci
      ..setBlock(1, i, 0, Block.GOLD_BLOCK)
      ..setBlock(3, i, 0, Block.DIAMOND_BLOCK)
      ..setBlock(5, i, 0, Block.WOOL);
  }
  print("Block Demo End");
}

/// Retrieve position of the player.
// TODO : Convert to int?
posDemo() async {
  print("Pos Demo Start");
  var s = (await mci.getPos());
  print(s);
  print("Pos Demo End");
}

/// Dig a staircase mine.
void digMine() {}

void buildRainbow() {
  print("Starting rainbow...");
  var colors = [
    Block.BRICK_BLOCK,
    Block.GOLD_BLOCK,
    Block.MELON,
    Block.DIAMOND_BLOCK,
    Block.SANDSTONE,
    Block.GLOWSTONE_BLOCK,
    Block.LAPIS_LAZULI_BLOCK
  ];

  var height = 80;

  for (int x = 0; x < 128; x++) {
    for (int ci = 0; ci < colors.length; ci++) {
      double y = math.sin((x / 128.0) * math.PI) * height + ci;
      mci.setBlock(x - 64, y.round(), 0, colors[(colors.length - 1) - ci]);
    }
  }
  print("Built rainbow.");
}
