package ;

class Main
{
  public static function main() : Void
  {
    var args = Sys.args();

    if(args[0] == "help")
    {
      neko.Lib.println("Markdown Resume");
      neko.Lib.println("");
      neko.Lib.println("[format] [md file] [template directory] [output directory]");
      neko.Lib.println("[format] should be html or pdf");
      neko.Lib.println("");
      neko.Lib.println("Type help to display this help");
    }
    else
    {
      var mdresume = new MarkdownResume(args[0], args[1], args[2], args[3]);
      mdresume.generate();
    }
  }
}
