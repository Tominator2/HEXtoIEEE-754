program IEEE754_Converter;

uses
  Forms,
  IEEE754 in 'IEEE754.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'IEEE754 Converter';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
