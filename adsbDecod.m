function textAll = adsbDecod(adsbSignal,threshold)
% sampling rate 2MHz
%This is an example using a pre-selected set of data. It takes a chunk of
%d, called x, and thresholds it above 3. I chose 3 by looking at the graph.
%Then, y is the actual packet with preamble removed. Y is 4 times the ideal
%packet length (112) due to the sampling rate. I then downsample it in z by
%taking every other packet. I should use logic for g, but I got lazy and
%took another sample. G is my 112 (113 for some reason) bit packet. I
%convert the ICAO (bits 9:32) to hex and get a value.

%threshold=20;
msgL=112;
IdentifierVector = logical([0 0 1 0 0]');  % look for packets has TC=4
preamble = logical([ 1 0 1 0 0 0 0 1 0 1 0 0 0 0 0 0 ]');
Lpreamble=length(preamble);
ge =dec2bin(hex2dec('1FFF409'), 25);
gen = logical(ge-'0');
Hdet = comm.CRCDetector(gen);  % specify polynomial as [1 1 0 1] or [3 2 0]
Lpreamble=length(preamble);
textAll=[];
adsbSignal=[adsbSignal; zeros(250,1)];
x = abs(adsbSignal) > threshold;
%stem(x);
ICAO_ID=[];
ind=1;
while (ind+msgL*2+Lpreamble)<length(x)
    ind = find(x(ind:end), 1)+ind-1;
    if ~isempty(ind)
        if (sum(x(ind:ind+Lpreamble-1)==preamble)==Lpreamble)
            y = x(ind+Lpreamble:ind+Lpreamble+msgL*2-1); 
            DataPacket = y(1:2:end); %Sample the second time; should be logic
            DF=binaryVectorToHex(DataPacket(1:5).');
            DF=hex2dec(DF);
            TC=binaryVectorToHex(DataPacket(33:37).');
            TC=hex2dec(TC);
            if (DF==17)&&(TC==4)  %if data packets line up with identifier vector
                text='ind = '+string(ind)+ 'DF = '+string(DF)+'    TC = '+string(TC);
                [data,error] = step(Hdet, DataPacket);        % Check the error pattern E(x) alone. 
                if ~error
                    NewICAO = binaryVectorToHex(data(9:32).');
                    NewData = decode_id(data'); %decode the correct binary information
                    ICAO_ID = [ICAO_ID ;NewICAO '    '  NewData]; %add it to an array
                    text=text+'    ICAO = '+ NewICAO + '    ID = '+NewData+ '    CRC'+'(ok)'
                else
                    NewICAO = binaryVectorToHex(data(9:32).');
                    NewData = decode_id(data'); %decode the correct binary information
                    ICAO_ID = [ICAO_ID ;NewICAO '    '  NewData]; %add it to an array
                    text=text+'    ICAO = '+ NewICAO + '    ID = '+NewData+ '    CRC'+'(er)'
                end
                textAll=[textAll;text];
            else
                text='DF = '+string(DF)+'    TC = '+string(TC);
                disp(text);
            end
            ind=ind+Lpreamble+msgL*2;
        else
            ind=ind+1;
        end
    else
        break;
    end
end
    

disp(textAll);
%ICAO = binaryVectorToHex(g(9:32).')



