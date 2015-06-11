unit IEEE754;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, Math;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Edit2: TEdit;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function HexToIEEE754(hexVal: String): Real;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Edit2.Text := FloatToStr(HexToIEEE754(Edit1.Text));
  Edit1.SetFocus;
end;


// this function converts a string representing an 8 digit
// hexadecimal number to its decimal equivalent assuming
// IEEE754 floating point number encoding
function TForm1.HexToIEEE754(hexVal: String): Real;
var
  sign:       Integer;
  exponent:   Integer;
  mantissa:   Integer;
  position:   Integer;
  value:      Real;
  currentBit: Integer;

begin

  // check for valid input
  // Make sure the length is correct and try converting it
  // to see if it is a valid hex number
  if (Length(Edit1.Text) < 8) or (not TryStrToInt('$' + Edit1.Text, mantissa)) then
  begin
    ShowMessage('Enter an 8 digit hexadecimal number');
    HexToIEEE754 := 0.0;
    Exit; // stop conversion and leave the function
  end;

  // check for 0 (ignore the sign bit and check that both
  // exponent and mantissa = 0)
  if (StrToInt('$'+ Edit1.Text) and $7FFFFFFF) = 0 then
  begin
    HexToIEEE754 := 0.0;
    Exit;  // stop conversion and leave the function
  end;

  // This conversion is based on pages 13-15 of RS485.pdf
  // http://metering.igmc.ir/static_info/RS485.pdf

  // Check the sign bit (leftmost bit of leftmost hex digit)
  //
  // Note that we need to add a preceedeing '$' to the string to
  // indicate hex format
  if StrToInt(LeftStr('$' + Edit1.Text, 2)) >= 8 then
    sign := -1  // if bit is 1 then sign is negative
  else
    sign := 1;  // if bit is 1 then sign is positive

  // calculate the exponent

  // extract the exponent from the leftmost 3 hex digits
  // and convert it to a number
  exponent := StrToInt(LeftStr('$' + Edit1.Text, 4));

  // mask out the sign bit
  exponent := exponent and $7FF;

  // shift right to remove the lower 3 bits which are
  // part of the mantissa
  exponent := exponent shr 3;

  // subtract 127 becuase it is in 2's complement form
  exponent := exponent - 127;

  // calculate the mantissa

  // extract the exponent from the rightmost 6 hex digits
  // and convert it to a number
  mantissa := StrToInt('$' + RightStr(Edit1.Text, 6));

  // add the implied '1' to the left of the decimal point
  // which is not stored (the leftmost bit)
  mantissa := mantissa or $800000;

  value := 0.0;

  // iterate from the least significant bit (rightmost) to the
  // most significant bit (leftmost) and add the value for each
  // of the mantissa's 24 bits
  for position := 0 to 23 do
  begin
    currentBit := (mantissa shr position) and 1;
    value := value + (currentBit * Power(2, exponent - 23 + position));
    //ShowMessage('position = ' + IntToStr(position) +
    //            ', bit = ' + IntToStr(currentBit) +
    //            ', value = ' + FloatToStr(value));  // trace
  end;

  HexToIEEE754 := sign * value;

end;

end.
