y=abs(loadFile('adsb_3.2M_3.dat'));
y=resample(y,5,4);
%out=zeros(1,length(y)/2);
% index=1;
% for k=1:2:length(y)
%    out(index)=y(k); 
%     index=index+1;
% end
out=y(1:2:length(y));
plot(linspace(1,length(out),length(out)),out);
Z=out(6554900:6555200);
plot(Z);
%thrshold=max(Z)-min(Z);
figure;
thres=Z>20;
stem(thres);
figure;
yy=thres(54:277);
stem(yy);

f=zeros(1,112);
ind=1;
for k=1:2:length(yy)
   if yy(k)==0 && yy(k+1)==1
       f(ind)=0;
   else f(ind)=1;
   end
   ind=ind+1;
end

stem(f(1:5));
stem(f(33:37));
hexval = binaryVectorToHex(f(9:32));
stem(f(9:32));
x=f(41:88);
cs=decode_id(f);

ge='1111111111111010000001001';
gen = logical(ge-'0');
Hdet = comm.CRCDetector(gen);
[data,error] = step(Hdet, f');

messages = adsbDecod(out, 19);