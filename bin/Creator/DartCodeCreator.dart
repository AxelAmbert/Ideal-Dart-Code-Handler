import 'CodeWriter/RouteWriter.dart';
import 'JsonData/CreatorData.dart';
import 'JsonData/CreatorParameters.dart';
import 'DartCodeViewWriter.dart';

class DartCodeCreator {
  CreatorParameters parameters;
  Function onEnd;

  DartCodeCreator(this.parameters, this.onEnd);

  /*Future<void> launchThreads() async {
    final threadPool = <Thread>[];

    final stopwatch = new Stopwatch()..start();
    RouteWriter.write(parameters);
    for (var i = 0; i < parameters.views.length; i++) {
      final thread = Thread(() async {
        await DartCodeViewWriter(CreatorData(parameters, i), () {}).creator();
      });
      await thread.start();
      threadPool.add(thread);
    }
    for (final thread in threadPool) {
      await thread.join();
    }
    print('Time elapsed + ${stopwatch.elapsed}');
    onEnd();
  }*/

  Future<void> launchThreads() async {

    RouteWriter.write(parameters);
    for (var i = 0; i < parameters.views.length; i++) {
      await DartCodeViewWriter(CreatorData(parameters, i), () {}).creator();
    }
    onEnd();
  }


}