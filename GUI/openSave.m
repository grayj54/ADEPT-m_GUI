function hSaveMenu = openSave(~)


%device = Adept;
          
answer = questdlg('This device exists. Do you want to edit or overwrite it?', ...
	'Save', ...
	'Edit','Overwrite','Overwrite');
% Handle response
switch answer
    case 'Edit'
        
        dessert = 1;
    case 'Overwrite'
        answer =  uiputfile;
        dessert = 2;
    
end

