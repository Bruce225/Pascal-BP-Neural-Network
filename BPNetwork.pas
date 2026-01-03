program BPNetwork;

uses
  math, sysUtils;

const
  hidNode = 16;
  lr = 0.1;
  epochs = 50000;
var
  f, fOut: textfile;
  i, j, k: longint;
  ch, ch2: char;
  mmse, Mse, Mae, apr, arl: double;
  tStart, tEnd: int64;
  Data: array[0..1050, 0..8] of double;
  Dmin, Dmax: array[0..8] of double;
  W1: array[0..7, 0..hidNode-1] of double;
  W2: array[0..hidNode-1, 0..0] of double;
  B1: array[0..hidNode-1] of double;
  B2: array[0..0] of double;
  hOut: array[0..hidNode-1] of double;
  rOut: array[0..0] of double;
  sigTable: array[0..2010] of double;

procedure shuffleData;
var
  i, j, k: integer;
  temp: double;
begin
  randSeed := 20260103;
  for i := 1029 downto 1 do
  begin
    k := random(i + 1);
    for j := 0 to 8 do
    begin
      temp := Data[i, j];
      Data[i, j] := Data[k, j];
      Data[k, j] := temp;
    end;
  end;
end;

procedure normData;
var
  i, j: integer;
begin
  for j := 0 to 8 do
  begin
    Dmin[j] := 1e8;
    Dmax[j] := -1;
    for i := 0 to 1029 do
    begin
      if (Data[i, j] < Dmin[j]) then Dmin[j] := Data[i, j];
      if (Data[i, j] > Dmax[j]) then Dmax[j] := Data[i, j];
    end;
    for i := 0 to 1029 do
      Data[i, j] := (Data[i, j] - Dmin[j]) / (Dmax[j] - Dmin[j]);
  end;
end;

procedure init;
var
  i, j: integer;
begin
  for i := 0 to 7 do
    for j := 0 to hidNode - 1 do
      W1[i, j] := random() * 2 - 1;
  for i := 0 to hidNode - 1 do
  begin
    B1[i] := random() * 2 - 1;
    W2[i, 0] := random() * 2 - 1;
  end;
  B2[0] := random() * 2 - 1;
end;

procedure iniSigmoid;
var
  i: integer;
  x: double;
begin
  for i := 0 to 2000 do
  begin
    x := -10 + i * 0.01;
    sigTable[i] := 1 / (1 + exp(-x));
  end;
end;

function fastSigmoid(x: double): double;
begin
  if (x >= 10) then exit(1);
  if (x <= -10) then exit(0);
  fastSigmoid := sigTable[round((x + 10) * 100)];
end;

procedure doForward(x: integer);
var
  i, j: integer;
  sum: double;
begin
  for j := 0 to hidNode - 1 do
  begin
    sum := B1[j];
    for i := 0 to 7 do
      sum := sum + Data[x, i] * W1[i, j];
    hOut[j] := fastSigmoid(sum);
  end;
  sum := B2[0];
  for i := 0 to hidNode - 1 do
    sum := sum + hOut[i] * W2[i, 0];
  rOut[0] := fastSigmoid(sum);
end;

procedure doBackward(x: integer; lr: double);
var
  i, j: integer;
  rl, pd, delOut: double;
  delHid: array[0..hidNode-1] of double;
begin
  rl := Data[x, 8];
  pd := rOut[0];
  delOut := (rl - pd) * pd * (1 - pd);
  for i := 0 to hidNode - 1 do
    delHid[i] := delOut * W2[i, 0] * hOut[i] * (1 - hOut[i]);
  for i := 0 to hidNode - 1 do
    W2[i, 0] := W2[i, 0] + lr * delOut * hOut[i];
  B2[0] := B2[0] + lr * delOut;
  for i := 0 to 7 do
    for j := 0 to hidNode - 1 do
      W1[i, j] := W1[i, j] + lr * delHid[j] * Data[x, i];
  for i := 0 to hidNode - 1 do
    B1[i] := B1[i] + lr * delHid[i];
end;

begin
  assign(f, 'Concrete_Data.csv');
  reset(f);

  for i := 0 to 1029 do
  begin
    read(f, Data[i, 0], ch, ch2);
    read(f, Data[i, 1], ch, ch2);
    read(f, Data[i, 2], ch, ch2);
    read(f, Data[i, 3], ch, ch2);
    read(f, Data[i, 4], ch, ch2);
    read(f, Data[i, 5], ch, ch2);
    read(f, Data[i, 6], ch, ch2);
    read(f, Data[i, 7], ch, ch2);
    readln(f, Data[i, 8]);
  end;

  close(f);
  assign(fOut, 'Training_result.txt');
  rewrite(fOut);

  shuffleData;
  normData;
  init;
  iniSigmoid;

  tStart := getTickCount64;

  for k := 1 to epochs do
  begin
    mmse := 0;
    for i := 0 to 824 do
    begin
      doForward(i);
      doBackward(i, lr);
      mmse := mmse + sqr(Data[i, 8] - rOut[0]);
    end;
    if (k mod 1000 = 0) then
    begin
      writeln('Epoch ', k , ': mmse = ', mmse:0:4);
      writeln(fOut, 'Epoch ', k , ': mmse = ', mmse:0:4);
    end;
  end;

  tEnd := getTickCount64;

  for i := 825 to 1029 do
  begin
    doForward(i);
    Mse := Mse + sqr(Data[i, 8] - rOut[0]);
    apr := rOut[0] * (Dmax[8] - Dmin[8]) + Dmin[8];
    arl := Data[i, 8] * (Dmax[8] - Dmin[8]) + Dmin[8];
    writeln('Sample ', i, ', Predict ', apr:0:4, ', Real ', arl:0:4, ', Error ', abs(apr - arl):0:4);
    writeln(fOut, 'Sample ', i, ', Predict ', apr:0:4, ', Real ', arl:0:4, ', Error ', abs(apr - arl):0:4);
    Mae := Mae + abs(apr - arl);
  end;

  writeln('Total MSE = ', Mse / 205 :0:4, ', Total Mae = ', Mae / 205 :0:4);
  writeln('Total time = ', (tEnd - tStart) / 1000 :0:3, ' sec');
  writeln(fOut, 'Total MSE = ', Mse / 205 :0:4, ', Total Mae = ', Mae / 205 :0:4);
  writeln(fOut, 'Total time = ', (tEnd - tStart) / 1000 :0:3, ' sec');
  close(fOut);
end.
