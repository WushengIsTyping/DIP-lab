clc;
choice=menu('Rain pixel recovery','input image','input video','noise reduction & rain detection','rain removal','exit');
if(choice==1)
  ipimage;
end;
if(choice==2)
  video;
end;
if(choice==3)
    raindet;
end;
if(choice==4)
    rainrem;
end;
if(choice==5)
%close all;
%clear all;
return;
end;