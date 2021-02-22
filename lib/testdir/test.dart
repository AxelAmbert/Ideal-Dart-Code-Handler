import 'test2.dart';

class theClass extends testImport {
  theClass(bool visibility) : super(visibility);

}


void main() {

}


class Callback {
  final String name;
  final String description;

  const Callback(this.name, this.description);
}


class CodeLink extends Callback {
  final bool visibility;

  const CodeLink(this.visibility): super('', '');
}

@CodeLink(true)
@Callback("ok", "voila")
int mdr(int lol, String hihi) {
  return (1);
}

class Mdr <T, R, M> {
  T lol;

  Mdr(this.lol);
  T memfunczeubi (int a, int mdr) {
      print("haha!");
      var i = 0;
      print(i);
      return (this.lol);
  }
}



bool a = true;