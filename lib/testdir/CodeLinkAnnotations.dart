class Callback {
  final String name;
  final String description;

  const Callback(this.name, this.description);
}


class CodeLink {
  final visibility;

  const CodeLink(this.visibility);
}

class CallbackParameter {
  final int paramNb;
  final bool isCallback;
  const CallbackParameter(this.paramNb, this.isCallback);
}