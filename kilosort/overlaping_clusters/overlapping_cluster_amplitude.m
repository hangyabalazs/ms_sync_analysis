function overlapping_cluster_amplitude()

waveformDir = 'D:\ANA_MOUSE\WAVEFORMS';

sameCluPath = 'D:\ANA_MOUSE\OVERLAPING\same_clusters';
fileNames = dir(sameCluPath);
fileNames(1:3) = [];

ampPairs = zeros(1000,2);
Ids = cell(1000,5);
cnt = 1;
for it = 1:numel(fileNames)
    a = strsplit(fileNames(it).name,'_');
    load(fullfile(sameCluPath,fileNames(it).name));
    for it2 = 1:size(sameGroups)
        f1 = fullfile(waveformDir,a{1},a{2},[a{1},'_',a{2},'_',num2str(sameGroups(it2,1)),'_waveform.mat']);
        f2 = fullfile(waveformDir,a{1},a{3},[a{1},'_',a{3},'_',num2str(sameGroups(it2,2)),'_waveform.mat']);
        if exist(f1) & exist(f2)
            load(f1,'amps');
            ampPairs(cnt,1) = max(sum(amps))/100;
            load(f2,'amps');
            ampPairs(cnt,2) = max(sum(amps))/100;
            Ids(cnt,:) = [a(1:3),sameGroups(it2,1),sameGroups(it2,2)];
            cnt = cnt + 1;
        end
    end
end
ampPairs(cnt+1:end,:) = [];
nplot(ampPairs)
ylabel('Spike max-min amplitude (mV)')
legend('2nd recording (shifted)','1st recording')
xlabel('Overlapping cluster pairs')
end