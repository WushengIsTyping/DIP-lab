% Author: Manu B.N
% Project Title: Rain Removal From Still Images Using L0 Gradient Minimization Technique
% Contact : manubn88@gmail.com

function varargout = Rain_Removal_GUI(varargin)
% RAIN_REMOVAL_GUI MATLAB code for Rain_Removal_GUI.fig
%      RAIN_REMOVAL_GUI, by itself, creates a new RAIN_REMOVAL_GUI or raises the existing
%      singleton*.
%
%      H = RAIN_REMOVAL_GUI returns the handle to a new RAIN_REMOVAL_GUI or the handle to
%      the existing singleton*.
%
%      RAIN_REMOVAL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAIN_REMOVAL_GUI.M with the given input arguments.
%
%      RAIN_REMOVAL_GUI('Property','Value',...) creates a new RAIN_REMOVAL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Rain_Removal_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Rain_Removal_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Rain_Removal_GUI

% Last Modified by GUIDE v2.5 30-Jul-2015 16:44:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Rain_Removal_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Rain_Removal_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Rain_Removal_GUI is made visible.
function Rain_Removal_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Rain_Removal_GUI (see VARARGIN)

% Choose default command line output for Rain_Removal_GUI
handles.output = hObject;
ss = ones(650,950);
axes(handles.axes1);
imshow(ss);
axes(handles.axes3);
imshow(ss);
kk = ones(350,650);
axes(handles.axes2);
imshow(kk);
axes(handles.axes4);
imshow(kk);
R = 'oo.oooo';
set(handles.edit1,'string',R);
set(handles.edit2,'string',R);
set(handles.edit3,'string',R);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Rain_Removal_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Rain_Removal_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.jpg;*.png;*.bmp','Pick a Rainy Image');
if isequal(FileName,0)||isequal(PathName,0)
    warndlg('User Pressed Cancel');
else
     ss = ones(650,950);
    axes(handles.axes3);
    imshow(ss);
    kk = ones(350,650);
    axes(handles.axes4);
    imshow(kk);
    R = 'oo.oooo';
    set(handles.edit1,'string',R);
    set(handles.edit2,'string',R);
    set(handles.edit3,'string',R);
    I = imread([PathName,FileName]);
    I_Large = imresize(I,[650,950]);
    axes(handles.axes1);
    imshow(I_Large);title('Rainy Image');
    helpdlg(' Rainy Image Is Selected ');
    [No_Of_RainPixels1 OnlyRainImage1] = find_rain(I);
    pause(1);
    Rain = imresize(OnlyRainImage1,[350,650]);
    axes(handles.axes2);
    imshow(Rain);
   
    handles.ImgData1 = I;
    handles.Imgdata2 = OnlyRainImage1;
    handles.ImgData3 = No_Of_RainPixels1;
    guidata(hObject,handles);
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%uWaitBar = waitbar(0,'Removing Rain Pixels');   
Img = handles.ImgData1;
Img = imadjust(Img,stretchlim(Img));
S = L0Smoothing(Img);
S = imadjust(S,stretchlim(S));
%%
% Try to enhance the quality of the images

srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');

shadow_lab = applycform(S, srgb2lab); % Convert to L*a*b*
% The values of luminosity can span a range from 0 to 100; scale them
% to [0 1] range (appropriate for MATLAB(R) intensity images of class double) 
% before applying any of the three contrast enhancement techniques
max_luminosity = 100;
L = shadow_lab(:,:,1)/max_luminosity;

% Replace the luminosity layer with the processed data and then convert
% the image back to the RGB colorspace
shadow_imadjust = shadow_lab;
% Alter Intensity
shadow_imadjust(:,:,1) = imadjust(L)*max_luminosity;
% Convert the image back to RGB
shadow_imadjust = applycform(shadow_imadjust, lab2srgb);

%%
%[No_Of_RainPixels2 OnlyRainImage2] = find_rain(shadow_imadjust);
if ndims(shadow_imadjust) == 3
   I2=rgb2gray(shadow_imadjust);
else
   I2 = shadow_imadjust;
end

BW2 = bwmorph(I2,'remove');
%figure,imshow(BW2);
BW3 = bwmorph(I2,'skel',Inf);
%figure,imshow(BW3);

SE = strel('arbitrary',eye(5));

BW2 = imerode(I2,SE);
%figure,imshow(BW2)
BW3 = imdilate(BW2,SE);
%figure,imshow(BW3)
closeBW = imclose(BW3,SE);
%figure, imshow(closeBW);
hy = fspecial('sobel');

hx = hy';
Iy = imfilter(double(shadow_imadjust), hy, 'replicate');
Ix = imfilter(double(shadow_imadjust), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
Iobrd = imdilate(BW2, SE );
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(closeBW));
Iobrcbr = imcomplement(Iobrcbr);
%Iobrcbr = imresize(Iobrcbr,[350,650]);
%OnlyRainI = imresize(OnlyRainImage2,[350,650]);
%figure, imshow(Iobrcbr);
OnlyRainImage2 = imregionalmax(Iobrcbr);
%figure, imshow(OnlyRainImage2);title('Only Rain');
 % Perform connected component analysis
 cc = bwconncomp(OnlyRainImage2,8);
 No_Of_RainPixels2 = cc.NumObjects;
% uWaitBar = waitbar(0,'Removing Rain Pixels');

shadow = imresize(shadow_imadjust,[650,950]);
%Rain2 = imresize(OnlyRainImage2,[350,650]);
%delete(uWaitBar)
%% % Only for rain2 image
K = L0Smoothing(Img);
S = L0Smoothing(K);
S = imadjust(S,stretchlim(S));
% Try to enhance the quality of the images
srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');

shadow_lab = applycform(S, srgb2lab); % Convert to L*a*b*
% The values of luminosity can span a range from 0 to 100; scale them
% to [0 1] range (appropriate for MATLAB(R) intensity images of class double) 
% before applying any of the three contrast enhancement techniques
max_luminosity = 100;
L = shadow_lab(:,:,1)/max_luminosity;

% Replace the luminosity layer with the processed data and then convert
% the image back to the RGB colorspace
shadow_imadjust = shadow_lab;
% Alter Intensity
shadow_imadjust(:,:,1) = imadjust(L)*max_luminosity;
% Convert the image back to RGB
shadow_imadjust = applycform(shadow_imadjust, lab2srgb);


%[No_Of_RainPixels2 OnlyRainImage2] = find_rain(shadow_imadjust);
if ndims(shadow_imadjust) == 3
   I2=rgb2gray(shadow_imadjust);
else
   I2 = shadow_imadjust;
end

BW2 = bwmorph(I2,'remove');
%figure,imshow(BW2);
BW3 = bwmorph(I2,'skel',Inf);
%figure,imshow(BW3);

SE = strel('arbitrary',eye(5));

BW2 = imerode(I2,SE);
%figure,imshow(BW2)
BW3 = imdilate(BW2,SE);
%figure,imshow(BW3)
closeBW = imclose(BW3,SE);
%figure, imshow(closeBW);
hy = fspecial('sobel');

hx = hy';
Iy = imfilter(double(shadow_imadjust), hy, 'replicate');
Ix = imfilter(double(shadow_imadjust), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
Iobrd = imdilate(BW2, SE );
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(closeBW));
Iobrcbr = imcomplement(Iobrcbr);
%Iobrcbr = imresize(Iobrcbr,[350,650]);
%OnlyRainI = imresize(OnlyRainImage2,[350,650]);
%figure, imshow(Iobrcbr);
OnlyRainImage2 = imregionalmax(Iobrcbr);
Rain2 = imresize(OnlyRainImage2,[350,650]);
%delete(uWaitBar)
axes(handles.axes3)
imshow(shadow);title(' Rain Removed Image ');
pause(2);
helpdlg(' Rain Pixels Are Removed Successfully ');
axes(handles.axes4)
pause(2);
imshow(Rain2);

%% PSNR
im1 = double(Img);
im2 = double(shadow_imadjust);
mse = sum((im1(:)-im2(:)).^2)/prod(size(im1));
psnr1 = 10*log10(255*255/mse);
%figure,bar(psnr,.2);title('Peak Signal to Noise Ratio');
% Evaluate Peak Signal to Noise Ratio after Smoothing operation
im3 = double(S);
mse2 = sum((im1(:)-im3(:)).^2)/prod(size(im1));
psnr2 = 10*log10(255*255/mse2);
psnr = [psnr2,psnr1];
set(handles.edit2,'string',psnr1);
set(handles.edit3,'string',psnr2);
pause(2);
figure,bar(psnr,0.25);title('PSNR values before & after Rain Removal');
%%
handles.ImgData4 = OnlyRainImage2;
handles.ImgData5 = No_Of_RainPixels2;
A1 = handles.ImgData3;
A2 = handles.ImgData5;

kk = bwconncomp(OnlyRainImage2,8);
NoOfRainPixels2 = kk.NumObjects;
Original = A1
Removed = NoOfRainPixels2
Remove = NoOfRainPixels2/A1;
Removed = 1-Remove;
R= Removed*100;
%disp(' % of Rain Pixels Removed is ','Remove')
set(handles.edit1,'string',R);
guidata(hObject,handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 close all;
