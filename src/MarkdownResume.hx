package ;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

import haxe.Template;

class MarkdownResume
{
  // Output format
  var _type : OutputType;

  // Resume file path
  var _md_file : String;

  // Template directory
  var _template : String;

  // Output directory
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

  /**
   * HTML export
   */
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

  /**
   * PDF
   */
  function generatePdfFile()
  {
    // http://wkhtmltopdf.org/
  }

}

enum OutputType {
  HTML;
  /*PDF;*/
}
