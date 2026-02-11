import 'dart:async';

import 'package:flasher/models/io_progress.dart';
import 'package:flasher/models/target_disk.dart';
import 'package:flasher/models/user_file.dart';

class FlasherService {
  Future<Stream<IoProgress>> flashWithProgress(
    UserFile sourceFile,
    TargetDisk destinationDisk,
  ) async {
    final ioProgressController = StreamController<IoProgress>();
    final sourceStream = sourceFile.readStream().handleError(
      ioProgressController.addError,
    );
    final destinationWritter = await destinationDisk.ioWritterFromPlatform();

    unawaited(() async {
      final total = sourceFile.size;
      var current = 0;

      try {
        await for (final chunk in sourceStream) {
          destinationWritter.add(chunk);
          await destinationWritter.flush();
          current += chunk.length;
          ioProgressController.add(IoProgress(current: current, total: total));
        }
      } catch (e) {
        ioProgressController.addError(e);
      }

      // we want to always call finish no matter what,
      // and pass error to consumer of stream
      try {
        await destinationWritter.finish();
      } catch (e) {
        ioProgressController.addError(e);
      }

      await ioProgressController.close();
    }());

    return ioProgressController.stream;
  }
}
