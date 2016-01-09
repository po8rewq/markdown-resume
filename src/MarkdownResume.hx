package ;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

import haxe.Template;

class MarkdownResume
{
  // Type d'export
  var _type : OutputType;

  // chemin du fichier md
  var _md_file : String;

  // chemin du dossier de template
  var _template : String;

  // chemin de sortie
  var _outputDir : String;

  public function new(pType:String, pMdFile: String, pTemplate: String, pOutputDir: String)
  {
    _md_file = pMdFile;
    _template = pTemplate;
    _outputDir = pOutputDir;

    try{
      _type = Type.createEnum(OutputType, pType.toUpperCase());
    }catch ( error:Dynamic ){
      throw "Format not supported yet";
    }
  }

  public function generate()
  {
    switch(_type)
    {
      case HTML: generateHtmlFile();
      /*case PDF: generatePdfFile();*/
    }
  }

  function generateHtmlFile()
  {
    var resume = File.getContent(_md_file);
    var htmlResume = Markdown.markdownToHtml(resume);

    var htmlFile = Path.join([_template, "index.html"]);
    var cssFiles : Array<String> = new Array();
    var cssDirectory = Path.join([_template, "css"]);
    for(f in FileSystem.readDirectory(cssDirectory))
      cssFiles.push( File.getContent( Path.join([cssDirectory, f]) ) );

    var template = new Template( File.getContent(htmlFile) );
    var data = {
      title: "Markdown Resume",
      styles: cssFiles,
      resume: htmlResume
    };
    var output = template.execute(data);

    var outFile = File.write( Path.join([_outputDir, "resume.html"]), false );
    outFile.writeString(output);
    outFile.close();
  }

  function generatePdfFile()
  {
    // http://wkhtmltopdf.org/
    // "C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe" examples\resume.html examples\resume.pdf
  }

}

enum OutputType {
  HTML;
  /*PDF;*/
}
