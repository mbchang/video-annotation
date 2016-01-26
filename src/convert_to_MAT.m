% use ls or dir to specifically match *.avi files
addpath('data')
files = dir(fullfile('data/videos/*.mov'));

for f = 1:size(files); 

    file = files(f);  % pick one file
    disp(file.name);

    videoreader = VideoReader(file.name);
    video = read(videoreader);
    disp(size(video));

    % now we just want the name minus the ext
    [pathstr,name,ext] = fileparts(file.name);
    fout = ['data/matfiles/',name,'.mat'];
    save(fout,'video', '-v7.3');
    
    % It will be saved in a .mat file, call it f. size(f.video) will return
    % [height width numchannels numframes]
end