import 'test2.dart';
import '../CodeLinkAnnotations.dart';

class theClass extends testImport {
  theClass(bool visibility) : super(visibility);
}

String bool_Int__String([bool val = true, int lol = 0]) {
  return ("ok");
}

bool String__Bool({String name = "ok"}) {
  return (true);
}

@CodeLink(true)
int String_Int__Int(String source, int toAdd) {
  return (1);
}

class RandomClass<T, R, M> {
  T variable;

  RandomClass(this.variable) {
    print('salut');
  }

  RandomClass.testOtherConstructor(this.variable, int i) {
    print('?');
  }

  T Int_Int__TemplateT(int a, int mdr) {
    print('haha!');
    var i = 0;
    print(i);
    return (this.variable);
  }
}

@CallbackParameter(1, true)
@CallbackParameter(3, true)
int Callback_Int_Callback__Int(Function func, int ok, Function secondFunc) {
  return (1);
}

void main() {}

class One extends Two {
  const One(
      {required String? one,
      Osef? two,
      String? three,
      required int? four,
      bool? five}) : super(one: one, five: five);
}

class Two {
  const Two({
    required Osef? one,
    required bool? five,
  });
}

const bool a = true;
const int i = 314;
const String stringValue = "a random value...";
