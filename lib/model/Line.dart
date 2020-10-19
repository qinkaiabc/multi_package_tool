abstract class Line {
  final String text;

  Line(this.text);
}

class OutLine extends Line {
  OutLine(String text) : super(text);
}

class ErrLine extends Line {
  ErrLine(String text) : super(text);
}