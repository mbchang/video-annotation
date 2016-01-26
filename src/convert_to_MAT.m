% use ls or dir to specifically match *.avi files
addpath('/Users/MichaelChang/Documents/Researchlink/Michigan Research/Datasets/Extra')
files = dir(fullfile('/Users/MichaelChang/Documents/Researchlink/Michigan Research/Datasets/Extra/*.mov'));

for f = 1:size(files); 

    file = files(f);  % pick one file
    disp(file.name);

    videoreader = VideoReader(file.name);
    video = read(videoreader);
    disp(size(video));

    % now we just want the name minus the ext
    [pathstr,name,ext] = fileparts(file.name);
    fout = ['/Users/MichaelChang/Documents/Researchlink/Michigan Research/Datasets/Extra/matfiles/',name,'.mat'];
    save(fout,'video', '-v7.3');
    
    % It will be saved in a .mat file, call it f. size(f.video) will return
    % [height width numchannels numframes]
end