clc
clearvars -except data ibi
% Remove zeroes
%data = ibi;
data = data(data~=0);

% Remove oversampled ibi values
count = 1;
ibiArr(count) = data(count);
for i = 2:1:numel(data)
    if(data(i) ~= ibiArr(count))
       count = count + 1;
       ibiArr(count) = data(i); 
    end
end

% Now ibiArr contains individual non-zero values


% Clean ibi data by median filtering and constant thresholding
W = 11;
TH = 100;
N = numel(ibiArr);
nCorrC = zeros(1,N);
i = W;
ibi1 = [];
while(i <= N)
    curIdx = i-W + (W+1)/2;
    ref(curIdx) = median(ibiArr(i-W+1:i));
       
        if(abs(ibiArr(curIdx) - med(curIdx)) > TH)
          % ibiC(i) = round(interp1(1:1:W3,ibiN(i:i+W3-1), (W3+1)/2, 'linear'));
            ibiC(curIdx) = med(curIdx);
            nCorrC(curIdx) = 1;
        else
            ibiC(curIdx) = ibiArr(curIdx);
        end
        
    i = i+1;
end

fprintf("Number of corrections in Median filtering and constant thresholding = %d \n",sum(nCorrC));


% HR and HRV

N = numel(ibiC);














figure()
subplot(3,1,1)
title("Median filtering and constant thresholding")
hold on
plot(ibiArr,'r')
plot(ibiC,'b','LineWidth',2)
%plot(diff(ibiArr),'k')
plot(med,'--g','LineWidth',1)
plot(med - TH,'k','LineWidth',1)
plot(med + TH,'k','LineWidth',1)
stem(nCorrC.*450,'k','LineWidth',1,'MarkerSize',0.1)
ylim([400 1200])



% Average threshlding

N = numel(ibiArr);
nCorrCA = zeros(1,N);
i = W;
ibiCA = [];
while(i <= N)
    curIdx = i-W + (W+1)/2;

    avg(curIdx) = mean(ibiArr(i-W+1:i));
       
        if(abs(ibiArr(curIdx) - avg(curIdx)) > TH)
          % ibiC(i) = round(interp1(1:1:W3,ibiN(i:i+W3-1), (W3+1)/2, 'linear'));
            ibiCA(curIdx) = avg(curIdx);
            nCorrCA(curIdx) = 1;
        else
            ibiCA(curIdx) = ibiArr(curIdx);
        end
        
    i = i+1;
end

fprintf("Number of corrections in Average filtering and constant thresholding = %d \n",sum(nCorrCA))


subplot(3,1,2)
title("Average filtering and constant thresholding")
hold on
plot(ibiArr,'r')
plot(ibiCA,'b','LineWidth',2)
%plot(diff(ibiArr),'k')
plot(avg,'--g','LineWidth',1)
plot(avg - TH,'k','LineWidth',1)
plot(avg + TH,'k','LineWidth',1)
stem(nCorrCA.*450,'k','LineWidth',1,'MarkerSize',0.1)
ylim([400 1200])

% subplot(3,1,3)
% hold on
% plot(med,'k','LineWidth',1)
% plot(avg,'r','LineWidth',1)

% Now we have two filtered ibis - ibiC(median filtered) and ibiCA(avg filtered)



% My algo ---

W = 11;
N = numel(ibiArr);
gndRef = [];
m = 2;
thr = [];
curIdx = [];
diff = [];
nCorr = zeros(1,N);
ibiCorr = [];
i = W;
lowBound = 50;
highBound = 1150;
while( (i >= W) && (i <= N))
   
    curIdx = i-W + (W+1)/2;
    
    gndRef(curIdx) = median(ibiArr(i-W+1:i));
    thr(curIdx) = m*median(abs(ibiArr(i-W+1:i) - gndRef(curIdx)));
    if(thr(curIdx) < lowBound)
        thr(curIdx) = lowBound;
    end
    
    if(thr(curIdx) > highBound)
        thr(curIdx) = highBound;
    end
    
    diff = ibiArr(curIdx) - gndRef(curIdx);

    if(abs(diff) > abs(thr(curIdx)))
        % ibiC(i) = round(interp1(1:1:W3,ibiN(i:i+W3-1), (W3+1)/2, 'linear'));
        if(diff > 0)
            ibiCorr(curIdx) = gndRef(curIdx) + thr(curIdx);
        elseif(diff < 0)
            ibiCorr(curIdx) = gndRef(curIdx) - thr(curIdx);
        end
        nCorr(curIdx) = 1;
        
    else
        ibiCorr(curIdx) = ibiArr(curIdx);
    end
 
    i = i+1;
end

subplot(3,1,3)
title("New algo")
hold on
plot(ibiArr,'r')
plot(ibiCorr,'b','LineWidth',2)
%plot(diff(ibiArr),'k')
plot(gndRef,'--g','LineWidth',1)
plot(gndRef - thr,'k','LineWidth',1)
plot(gndRef + thr,'k','LineWidth',1)
stem(nCorr.*500,'k','LineWidth',1,'MarkerSize',0.1)
ylim([400 1200])

fprintf("New algo = %d \n",sum(nCorr))


%%
WD = 11

ibiC = ibiArr;

subplot(3,1,3)
plot(ibiC)


fprintf('Mean ibi = %d, Median ibi = %d, std = %d \n', round(mean(ibiC)), round(median(ibiC)), round(std(ibiC)))
% -- HR
fprintf('------------ HR ---------------\n')

hrb2b = 60000./ibiC;

fprintf('Mean hr (from ibi) = %d, Median hr (from ibi) = %d,\n', round(60000/mean(ibiC)), round(60000/median(ibiC)))
fprintf('Mean hr (from hrb2b) = %d, Median hr (from hrb2b) = %d, std = %d \n', round(mean(hrb2b)), round(median(hrb2b)), round(std(hrb2b)))

N = numel(hrb2b);
i = 1;
W2 = WD;
while(i <= N-W2+1)
   hrb2bav(i+W2-1) =  mean(hrb2b(i:i+W2-1));
   hrb2bmd(i+W2-1) =  median(hrb2b(i:i+W2-1));
   i = i+1;    
end

hrb2bav = hrb2bav(hrb2bav~=0);
hrb2bmd = hrb2bmd(hrb2bmd~=0);


fprintf('Mean hr (from hrb2b-W-mean) = %d, Median hr (from hrb2b-W-mean) = %d,  std = %d \n', round(mean(hrb2bav)), round(median(hrb2bav)), round(std(hrb2bav)))
fprintf('Mean hr (from hrb2b-W-median) = %d, Median hr (from hrb2b-W-median) = %d,  std = %d \n', round(mean(hrb2bmd)), round(median(hrb2bmd)), round(std(hrb2bmd)))

figure()
subplot(4,2,1)
hold on
%plot(hrb2b,'b')
plot(hrb2bav,'r')
plot(hrb2bmd,'k')
title('HR statistics')


% -- HRV
fprintf('------------ HRV ---------------\n')

i = 1;
W1 = 2;
while(i <= N-W1+1)
   hrvb2b(i+W1-1) =  sqrt(sum(diff(ibiC(i:i+W1-1)).^2)/(W1-1));
   i = i+1;    
end

fprintf('hrv (from ibi) = %d,\n', round(sqrt(sum(diff(ibiC).^2)/(N-1))))
fprintf('Mean hrv (from hrvb2b) = %d, Median hrv (from hrvb2b) = %d, std = %d \n', round(mean(hrvb2b)), round(median(hrvb2b)), round(std(hrvb2b)))

N = numel(hrb2b);
i = 1;
W2 = WD;
while(i <= N-W2+1)
   hrvb2bav(i+W2-1) =  mean(hrvb2b(i:i+W2-1));
   hrvb2bmd(i+W2-1) =  median(hrvb2b(i:i+W2-1));
   i = i+1;    
end

hrvb2bav = hrvb2bav(hrvb2bav~=0);
hrvb2bmd = hrvb2bmd(hrvb2bmd~=0);

fprintf('Mean hrv (from hrvb2b-W-mean) = %d, Median hrv (from hrvb2b-W-mean) = %d, std = %d \n', round(mean(hrvb2bav)), round(median(hrvb2bav)), round(std(hrvb2bav)))
fprintf('Mean hrv (from hrvb2b-W-median) = %d, Median hrv (from hrvb2b-W-median) = %d, std = %d \n', round(mean(hrvb2bmd)), round(median(hrvb2bmd)), round(std(hrvb2bmd)))

subplot(4,2,2)
hold on
%plot(hrvb2b,'b')
plot(hrvb2bav,'r')
plot(hrvb2bmd,'k')
title('HRV statistics')

subplot(4,2,3)
hist(hrb2b,200)
xlim([0 max(hrb2b)])
title('HR - histogram b2b')

subplot(4,2,5)
hist(hrb2bav,200)
xlim([0 max(hrb2b)])
title('HR - histogram avg filtering')

subplot(4,2,7)
hist(hrb2bmd,200)
xlim([0 max(hrb2b)])
title('HR - histogram median filtering')

subplot(4,2,4)
hist(hrvb2b,200)
xlim([0 max(hrvb2b)])
title('HRV - histogram b2b')

subplot(4,2,6)
hist(hrvb2bav,200)
xlim([0 max(hrvb2b)])
title('HRV - histogram avg filtering')

subplot(4,2,8)
hist(hrvb2bmd,200)
xlim([0 max(hrvb2b)])
title('HRV - histogram median filtering')



%% Testing FCEUX BioNES
clearvars
clc

try
    [status,cmdout] =  system('taskkill -f -im fceux64.exe');
    if(~status)
        disp("Already running instance of FCEUX has been terminated.")
    else
        disp("FCEUX is not running.")
    end
     
    % Loading ROM and LUA-script path
    sp = ' ';
    br = '"';
    ROM_FullPath = [pwd,'\fceux64\ROMs\','Super Mario Bros. (World).zip'];
    LUA_FullPath = [pwd,'\fceux64\luaScripts\','BioNES.lua'];
    
    % Starting game
    FCEUX_cmd = ['fceux64\fceux64.exe',sp,'-pal 1',sp,'-lua',sp,LUA_FullPath,sp,br,ROM_FullPath,br,sp,'&'];
    system(FCEUX_cmd);
    disp("New instance of FCEUX is started and Game loaded.")
    
    % Starting TCP/IP server in MATLAB to communicate with game
    fceux = tcpip('127.0.0.1', 30000, 'NetworkRole', 'server');
    fopen(fceux);
    disp("TCP/IP Server started.")
    disp("MATLAB is connected to FCEUX.")
        
catch ME
     disp(ME.identifier)
     disp(ME) 

end
pause(2)


%% Reading score
count = 0;
tic
while(count < 100)
    count = count + 1;
    fwrite(fceux, 14)
   
        a =  fread(fceux, 6);
     %   val(count) = str2double(sprintf('%d',a));
         
    pause(0.001)
end
tt = toc
count/tt



%% Sending numeric values to FCEUX 
 
      
    a = num2str(round(hr_avg_cont(count)));
    d = [];
    for i =1:1:numel(a)
        d = [d '\' a(i)];
    end
    d= ['memory.writebyterangeppu(0x2028,' '"' d '"' ')'];
    data = convertCharsToStrings(d);
    fwrite(fceux, data)
    pause(0.01)

%% First ibi real-time interpolation Algorithm
  while(toggleButtonState && (toc <= sessionDuration) )
        
        while( ((toc*10^6) - timeSample) < (timeIntervalUs - timeJitterUs) )
            % disp('wasting time')
            % drawnow limitrate
            pause(0);
        end
        
        timeSample = toc*10^6;
        count = count + 1;
                
        %---------- Acquire data from arduino ----------
        fwrite(ard,160);
        rec_MSB = double(fread(ard,1));
        rec_LSB = double(fread(ard,1));
        beat(count) = bitshift(rec_MSB,-7);
        rec_MSB = bitand(rec_MSB,7);
        ibiS = bitor(bitshift(rec_MSB,8), rec_LSB);
                
        %---------- Calculating features ----------
        if (beat(count))  %
            isSensorError = false; 
            isDataCorrupted = 0;
            lastBeatTime = timeSample;
            ibiArr = circshift(ibiArr,-1);
            ibiArr(nBeat) = ibiS;
            
            if(sum(isnan(ibiArr)))
                isArrFull = 0;
                hrAvgS = 0;
                hrvAvgS = 0;
            else
                isArrFull = 1;
                isDataAdjusted = 0;
                ibiMedS = round(median(ibiArr));
            end
                        
            if(isArrFull && abs(ibiS-ibiMedS) > ibiTh)
                % Extrapolation
                ibiS = round(interp1(t,ibiArr(1:nBeat-1), nBeat, 'makima','extrap'));
                ibiArr(nBeat) = ibiS;
                isDataAdjusted = 1;
                if(abs(ibiS-ibiMedS) > ibiTh)
                %     ibiS = ibiMedS;
                    isDataCorrupted = 1; % Extrapolation failed
                end
            end
            
            if(isArrFull)
                % Calculate features
                ibiAvgS = sum(ibiArr)/nBeat;
                hrAvgS = 60000/ibiAvgS;
                hrvAvgS = sqrt(sum(diff(ibiArr).^2)/(nBeat-1));
                % correct hrv yet to calculate using median algo
            end
            
        else
           if(count > 1) 
            ibiS = ibi(count-1);
           end
        end
        
            
      % Updating vars        
       ibi(count) = ibiS;
       hrAvg(count) = hrAvgS;
       hrvAvg(count) = hrvAvgS;
   
        %    elseif(rec == 162)
        %        SetParam(handles.text_statusMsg, 'NACK Received. Data not received', 'error', 'text');
        %     end
             
        
        if(isArrFull)
            dataRel(count) = 1;
        else
            dataRel(count) = 0;
        end
        
        if(isDataAdjusted)
           dataAdj(count) = 1; 
           disp('adjustment...')
        else
           dataAdj(count) = 0; 
        end
        
        if(isDataCorrupted)
            disp('corruption ..')
            dataRel(count) = 0;
            ibiArr = nan(1, nBeat);
            isArrFull = 0;
        end
        
        if(timeSample - lastBeatTime > 2*10^6)
            if(~isSensorError)
                isSensorError = 1;
                ibiArr = nan(1, nBeat);
                isArrFull = 0;
            end
        end
        
          
        %---------- Calculating graph variables ----------
        timeSampleSec = timeSample/(10^6);
        % setting plot axes property
        if(timeSampleSec > plotWidth)
            
            xMin = timeSampleSec-plotWidth;
            xMax = timeSampleSec+rightOffset;
        else
            % timeSampleSec <= scrollPlotWidth
            xMin = 0;
            xMax = plotWidth+rightOffset;
        end
        
        %---------- Plotting data ----------
        set(handles.axes1,'xlim',[xMin xMax]);
        addpoints(animatedlineHandle1, timeSampleSec,beat(count)*10);
        addpoints(animatedlineHandle2, timeSampleSec,ibi(count));
        addpoints(animatedlineHandle3, timeSampleSec,hrAvg(count));
        addpoints(animatedlineHandle4, timeSampleSec,hrvAvg(count));

        %   time_buttonUpdate = toc(timer_buttonUpdate); % check timer
        %   if (time_buttonUpdate > 1)
       
        %---------- Jitter calculation and GUI update ----------
        toggleButtonState = get(hObject,'Value');
        drawnow limitrate
        %       timer_buttonUpdate = tic; % reset timer after updating
        %   end
        
        
        timeJitterUs = timeSample - (timeIntervalUs*(count));
        %  TJ_Work(count) = toc(tWork)*1000;
        
    end

%% comparing interpolation methods

a = [ 723   843   739   784   829   874   815   829   698   420]
N = numel(a);
med_a = median(a)
a = a(1:N-1)
t = 1:1:N-1;

int_linear = round(interp1(t,a,N,'linear','extrap'))
int_pchip = round(interp1(t,a,N,'pchip','extrap'))
int_makima = round(interp1(t,a,N,'makima','extrap'))
int_spline = round(interp1(t,a,N,'spline','extrap'))

figure
hold on
stem(t,a,'b')


%% Important scripts

% before main while loop
    gta =  getappdata(handles.figure1,'settings_gta');
    
 %   isGTA = false;

% inside main while loop

        %---------- Communicating with GTA5 ----------        
               
 %       if(isGTA)
 %      if(gta.BytesAvailable)
 %          rG = fread(gta,1);
 %          if(rG == 'p')
 %              dataGta = sprintf("h%dv%db%d",(round(hrAvg(count))), (round(hrvAvg(count))), beat(count));
 %              fwrite(gta,dataGta);
 %          end
 %          flushinput(gta)   % use only if gta makes faster requests to matlab
 %      end
 %      end
 
 
 % inside connect arduino
 
 %                 gta = serial('COM11');
%                 set(gta,'DataBits',8);
%                 set(gta,'StopBits',1);
%                 set(gta,'BaudRate',115200);
%                 set(gta,'Parity','none');
%                 fopen(gta);
%                 pause(1);
%                 while(gta.BytesAvailable)
%                     uint8(fread(ard,1));
%                 end
%                 setappdata(handles.figure1,'settings_gta',gta);
 