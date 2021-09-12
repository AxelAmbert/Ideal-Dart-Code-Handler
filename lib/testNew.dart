import 'ResolvedMethodVisitor.dart';
import 'FieldDeclarationVisitor.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';

import '../CodeLinkAnnotations.dart';

import '../../Creator/Visitors/ImportDirectiveVisitor.dart';

class theClass extends testImport {
  String slt = '';

  theClass(bool visibility) : super(visibility);
}

void func_for_codelink_test()
{
  print("CODELINK FONCTIONNE");
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
	Button thebutton; var thebuttonOnPressed = null; var thebuttonOnPressed2 = null;

	Sizedbox mdr = null;

  MDRint coucou;
  T variable;

  RandomClass(this.variable) {
  }

  RandomClass.testOtherConstructor(this.variable, int i) {
    print('?');
  }

  T Int_Int__TemplateT(int a, int mdr) {
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

class HahaAOZAOZAPOEAPOEAPOEPAOEPAOEPAOEPAOEPAOEPAOEPAOEPAOEPAOE {

}

class One extends Two {
  HahaAOZAOZAPOEAPOEAPOEPAOEPAOEPAOEPAOEPAOEPAOEPAOEPAOEPAOE   /*mdr*/                  Callback_Int_Callback__Int(Function func, int ok, Function secondFunc) {
    return (HahaAOZAOZAPOEAPOEAPOEPAOEPAOEPAOEPAOEPAOEPAOEPAOEPAOEPAOE());
  }
  const One(
      {String one = '',
      dynamic two,
      String three = '',
      int four = 1,
      bool five = true}) : super(one: one, five: five);

  void test1() {

  }
}

class Two {
  const Two({
     dynamic one,
     bool five = true,
  });
}

const bool a = true;
const int i = 314;
const String stringValue = "a random value...";
