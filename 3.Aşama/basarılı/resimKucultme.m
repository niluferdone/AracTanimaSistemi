
image_folder='C:\Users\Mehmet Akif YILMAZ\Desktop\segment\vehicleImages';
filenames=dir(fullfile(image_folder, '*.jpg'));
total_images=numel(filenames);
for n=1:total_images
    f=fullfile(image_folder,filenames(n).name) ;
    our_images= imread(f);
    J=imresize(our_images,[144 144]);
    path=strcat('C:\Users\Mehmet Akif YILMAZ\Desktop\segment\road_line\egitim\segmentlenmemis',filenames(n).name);
    imwrite(J,path);
end