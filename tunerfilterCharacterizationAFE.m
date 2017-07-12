
%tunerfilterCharacterizationAFE.m

clear all
close all

if(1)
    path1=['C:\Users\Neil Birkett\Documents\CUSTOMERS\Aurora\MATLAB\DioLAN\'];
    fid1=['AFE003_adaptive_tuner2_band3_data_20120216.mat'];
    string=strcat(path1, fid1);
    load(string)
    
    x=CH_FREQ_STR_VEC;
    y=hex2dec(DPOT_HEX_STR_VEC);
    
else %use spreadsheet
    path1=['C:\Users\Neil Birkett\Documents\CUSTOMERS\Aurora\DOCUMENTS\TestPlan&Characterization\Characterization Spreadsheets\'];
    fid1=['AFE6AdaptiveTuner.xlsx'];
    sheet1=['Tuner1 Band3 Jan17'];
    range=['A9:E46'];
    
    string=strcat(path1, fid1);
    DATA=xlsread(string, sheet1, range);
    %col1=index, col2=channel, col3=tuned freq [MHz], col4=digipotHEX, col5=digipotDEC
    x=DATA(:,2);  y=DATA(:,5);
end

%% ensure monotonicity
% 
% for kk=2:length(y);
%     y(kk)=max(y(kk), y(kk-1));
% end
%% 
%%% github edit test

order=4;    % 1st order is linear
a0=0.01*ones(order+1,1);

%curveFit
[a,resnorm] = lsqcurvefit(@myfun,a0,x,y);

Fdata = myfun(a,x);

%% ensure monotonicity of Fitted data
Fdata=round(Fdata);
for kk=2:length(Fdata);
    Fdata(kk)=max(Fdata(kk), Fdata(kk-1));
    Fdata(kk)=min(Fdata(kk), 255);
end


%% 
Channel=21+(x-515)/6;

plot(Channel,y, Channel,Fdata)
grid


legend('Measured','LS Fitted')
xlabel('Channel Number')
ylabel('Digipot value [DEC]')

DigipotHEXFitted=dec2hex(Fdata)

%% 


% savefile='AFE6 AdaptiveTuner Band3.mat';
% save(savefile, 'Channel', 'DigipotHEX')

Channel
DigipotHEXFitted






