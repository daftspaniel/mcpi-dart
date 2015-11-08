// Copyright (c) 2015, Davy Mitchell. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import '../lib/mcdart.dart';
import 'dart:math' as math;

Minecraft mci;

main() async {
  // Connect to the server.
  mci = new Minecraft();
  await mci.connect("192.168.0.111", 4711);

  // Run the demos.
  chatDemo();

  blockDemo();

  await posDemo();

  await digMine();

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
digMine() async {
  print('Diging a mine...');
  List<int> pos = await mci.getPos();
  int y = pos[1];
  int x = pos[0];
  int z = pos[2];
  int i = 0;
  while (y > -62) {
    i += 1;
    print('$x $y $z');
    mci.setBlock(x, y, z + i, Block.AIR);
    mci.setBlock(x, y, z + i + 1, Block.AIR);
    mci.setBlock(x, y, z + i + 2, Block.AIR);
    mci.setBlock(x, y, z + i + 3, Block.AIR);

    mci.setBlock(x - 1, y, z + i, Block.AIR);
    mci.setBlock(x - 1, y, z + i + 1, Block.AIR);
    mci.setBlock(x - 1, y, z + i + 2, Block.AIR);
    mci.setBlock(x - 1, y, z + i + 3, Block.AIR);

    mci.setBlock(x, y - 1, z + i, Block.MOSS_STONE);
    mci.setBlock(x - 1, y - 1, z + i, Block.MOSS_STONE);
    if (y % 5 == 0) {
      mci.setBlock(x - 2, y, z + i, Block.TORCH);
      mci.setBlock(x + 2, y, z + i, Block.TORCH);
    }
    y -= 1;
  }
  print('Mine complete.');
}

/// Build a rainbow out of wool.
void buildRainbow() {
  print("Starting rainbow construction...");

  List woolColors = [10, 11, 3, 5, 4, 1, 14];
  int height = 54;
  double y;
  for (int x = 0; x < 128; x++) {
    for (int ci = 0; ci < woolColors.length; ci++) {
      y = math.sin((x / 128.0) * math.PI) * height + ci;
      mci.setBlock(x - 24, y.round(), 0, Block.WOOL, woolColors[ci]);
    }
  }
  print("Built a rainbow!");
}
