// Replaces all occurrences of a string 
//  with a different string in a text file
function FileReplaceString(const FileName, oldString, newString: string):boolean;
var
  MyFile : TStrings;
  MyText : string;
begin
  MyFile := TStringList.Create;

  try
    result := true;

    try
      MyFile.LoadFromFile(FileName);
      MyText := MyFile.Text;

      { Only save if text has been changed. }
      if StringChangeEx(MyText, oldString, newString, True) > 0 then
      begin;
        MyFile.Text := MyText;
        MyFile.SaveToFile(FileName);
      end;
    except
      result := false;
    end;
  finally
    MyFile.Free;
  end;
end;

function CreateSharedDir(const Path, Name : String): Integer;
var
    cmdParams : String;
    cmdExitCode : Integer;
begin
    cmdParams := 'net share '+ Name+'="'+Path +'" /GRANT:Everyone,Full';
		Log('Running the share cmd-command: ''cmd.exe /c '+ cmdParams+'''');
    Exec('cmd.exe', '/c "'+cmdParams+'"', '', SW_HIDE, ewWaitUntilTerminated, Result);
    Log('exit code is = '+ IntToStr(cmdExitCode));
end;

procedure shareInstallationDir();
var
  shareName: String;
  shareDescription: String;
  installationDir: String;
  sharedFullPath: String;
  thisComputerName: String;
  shareResult: Integer;
begin
	installationDir := ExpandConstant('{app}');
	
  shareName := ExpandConstant('{#SHARE_NAME}');
  shareDescription := 'Shared remote scripts dir for running remotely';
	
  thisComputerName := GetComputerNameString();
  sharedFullPath := '\\'+thisComputerName+'\'+shareName;
	Log('Checking if a share already exists: '''+sharedFullPath+'''');
  if not (DirExists(sharedFullPath)) then
  begin
		Log('No. Not shared yet.' + {#NEW_LINE} + 'Making a new share now to installation dir: '+installationDir+ '  with share-name: '''+shareName+'''');
    shareResult := CreateSharedDir(installationDir , shareName );
    if (shareResult <> 0) then
    begin
			Log('Share command failed. Failed to share directory: '''+installationDir+'''');
  	  MsgBox('Could not share directory: '+{#NEW_LINE}+installationDir+{#NEW_LINE}+{#NEW_LINE}+'Directory must be shared for ''Everyone'' for remote commands to work', mbError, MB_OK);
			Exit;
    end;
		Log('Successfuly shared installation directory: '''+installationDir+'''');
  end;
	Log('Installation Directory is shared. Continuing...');
	
	Log({#NEW_LINE});
end;


function getLinesAsStringsArray(linesArr: TStrings): TArrayOfString;
var
	linesResultArray: TArrayOfString;
	lineCount: Integer;
	ind: Integer;
begin
	lineCount := linesArr.Count;
	SetArrayLength(linesResultArray , lineCount+1);
	
	for ind := 0 to lineCount do
	begin
		linesResultArray[ind] := linesArr[ind];
	end;
	
	Result := linesResultArray;
end;




procedure saveNewComputerList(fullPathToSaveAt: String);
var
	loadedComputersFile: String;
	failIfExists: Boolean;
	computersListFileContent: TArrayOfString;
	appendToFile: Boolean;
begin
	failIfExists := False;
	if (radioBtnLoadComputerListMethod.Checked) then
	begin
		loadedComputersFile := Trim(textFieldComputersNamesFile.text);
		Log('Copying user-loaded computer list, From: '''+loadedComputersFile+'''  to a new computer list file at: '''+fullPathToSaveAt+'''');
		FileCopy(loadedComputersFile , fullPathToSaveAt , failIfExists);
	end else
	begin
		computersListFileContent := getLinesAsStringsArray(textBoxComputersNamesInput.Lines);
		appendToFile := False;
		Log('Generating a new computer list from manual-entered computer names to file at: '''+fullPathToSaveAt+'''');
		SaveStringsToFile(fullPathToSaveAt , computersListFileContent , appendToFile);
	end;
end;

procedure handleComputersListInput();
var
	nameOfComputerListFile: String;
	computerListDir: String;
	fullPathToSaveAt: String;
begin
	nameOfComputerListFile := Trim(textFieldComputersGroupName.text);
	computerListDir := ExpandConstant('{app}\Helpers\ComputerLists');
	
	Log('Checking which tasks were selected: ''DynamicRunScript'' and ''StaticRunScript''');
	if (IsTaskSelected('DynamicRunScript')) then
	begin
		fullPathToSaveAt := computerListDir + '\Dynamic\' + nameOfComputerListFile + '.txt'
		Log('Task ''DynamicRunScript'' was selected - saving a new computer list for Dynamic-Computer-Lists-Dir');
		saveNewComputerList(fullPathToSaveAt);
	end;
	
	if (IsTaskSelected('StaticRunScript')) then
	begin
		fullPathToSaveAt := computerListDir + '\Static\' + nameOfComputerListFile + '.txt'
		Log('Task ''StaticRunScript'' was selected - saving a new computer list for Static-Computer-Lists-Dir');
		saveNewComputerList(fullPathToSaveAt);
	end;
	
	Log('Computers Lists Files are ready. Continuing...');
	Log({#NEW_LINE});
end;

procedure writeNewActionBatFileToSharedDefinedActionsDir();
var
	actionBatFileContent: TArrayOfString;
	appendToFile: Boolean;
	nameOfCommand: String;
	fullPathToSaveAt: String;
begin
	actionBatFileContent := getLinesAsStringsArray(textBoxCommandToRun.Lines);
	
	nameOfCommand := Trim(textFieldCommandName.text);
	fullPathToSaveAt := ExpandConstant('{app}\Helpers\DefinedActions\'+nameOfCommand+'.bat');
	
	Log('Saving user action script as a new action batch file at: '''+fullPathToSaveAt+'''');
	
	appendToFile := False;
	SaveStringsToFile(fullPathToSaveAt , actionBatFileContent , appendToFile);
	
	Log({#NEW_LINE});
end;


procedure copyNewRemoteCommandFile(fullPathToCopyFrom, fullPathToSaveAt, computerListFileName, nameOfRemoteCommand : String);
var
	nameOfRemoteCommandFile: String;
	failIfExists: Boolean;
	thisComputerName: String;
	placeHolder: String;
begin
	failIfExists := False;
	
	if (FileCopy(fullPathToCopyFrom , fullPathToSaveAt , failIfExists) = False) then
	begin
		MsgBox('Could not copy new remote command file. From: '+fullPathToCopyFrom +'  to:  '+ fullPathToSaveAt, mbError , MB_OK);
		Exit;
	end;
	
	thisComputerName := GetComputerNameString();
	placeHolder := '#_HOSTING_COMPUTER_#';
	FileReplaceString(fullPathToSaveAt, placeHolder, thisComputerName);
	
	placeHolder := '#_COMMAND_TO_RUN_NAME_#';
	FileReplaceString(fullPathToSaveAt, placeHolder, nameOfRemoteCommand);
	
	placeHolder := '#_COMPUTER_LIST_TO_RUN_ON_PLACE_HOLDER_#';
	FileReplaceString(fullPathToSaveAt, placeHolder, computerListFileName);
	
	
end;

procedure handleNewRemoteCommandFiles();
var
	nameOfRemoteCommand: String;
	remoteCommandsDir: String;
	computersDir: String;
	fullPathToCopyFrom: String;
	fullPathToSaveAt: String;
	computerListFileName: String;
begin
	nameOfRemoteCommand := Trim(textFieldCommandName.text);
	remoteCommandsDir := ExpandConstant('{app}\Run');
	
	computerListFileName := Trim(textFieldComputersGroupName.text) + '.txt';
	
	Log('Generating (Dynamic or Static) run scripts to activate the new action batch command');
	if (IsTaskSelected('DynamicRunScript')) then
	begin
		fullPathToCopyFrom := remoteCommandsDir + '\Dynamic\TemplateRun_Dynamic.bat'
		fullPathToSaveAt := remoteCommandsDir + '\Dynamic\' + nameOfRemoteCommand + '.bat'
		
		Log('Generating a Dynamic Run Script at: '''+fullPathToSaveAt+'''');
		copyNewRemoteCommandFile(fullPathToCopyFrom, fullPathToSaveAt, computerListFileName, nameOfRemoteCommand);
	end;
	
	if (IsTaskSelected('StaticRunScript')) then
	begin
		fullPathToCopyFrom := remoteCommandsDir + '\Static\TemplateRun_Static.bat'
		fullPathToSaveAt := remoteCommandsDir + '\Static\' + nameOfRemoteCommand + '.bat'
		
		Log('Generating a Static Run Script at: '''+fullPathToSaveAt+'''');
		copyNewRemoteCommandFile(fullPathToCopyFrom, fullPathToSaveAt, computerListFileName, nameOfRemoteCommand);
	end;
	
	Log({#NEW_LINE});
end;


procedure updateStaticAndDynamicRunScripts();
var
	usernameToUse: String;
	passwordToUse: String;
	hostingRemoteCommandComputer: String;
	staticAndDynamicRunCommandsDir: String;
	hostingRemoteCommandsComputer: String;
	currentRemoteRunScript: String;
	placeHolder: String;
begin
	usernameToUse := Trim(textFieldComputersUserNameInput.text);
	passwordToUse := Trim(textFieldComputersPasswordInput.text);
	hostingRemoteCommandsComputer := GetComputerNameString();
	
	staticAndDynamicRunCommandsDir := ExpandConstant('{app}\Helpers\StaticAndDynamicScripts');
	
	Log('Updating place holders in scripts with values from the setup');
	
	if (IsTaskSelected('DynamicRunScript')) then
	begin
		currentRemoteRunScript := staticAndDynamicRunCommandsDir + '\Dynamic_RunRemoteTaskOnComputerList.bat';
		
		Log('Updating place holders of Dynamic Run Script: '''+currentRemoteRunScript+'''');
		
		placeHolder := '#_USERNAME_TO_USE_#'
		Log('Dynamic Run Script - Replacing place holder: '''+placeHolder+''' with value: '''+usernameToUse+'''');
		FileReplaceString(currentRemoteRunScript, placeHolder , usernameToUse);
		
		placeHolder := '#_PASSWORD_TO_USE_#'
		Log('Dynamic Run Script - Replacing place holder: '''+placeHolder+''' with value: ******');
		FileReplaceString(currentRemoteRunScript, placeHolder , passwordToUse);
		
		placeHolder := '#_HOSTING_COMPUTER_#'
		Log('Dynamic Run Script - Replacing place holder: '''+placeHolder+''' with value: '''+hostingRemoteCommandsComputer+'''');
		FileReplaceString(currentRemoteRunScript, placeHolder , hostingRemoteCommandsComputer);
		
	end;
	
	if (IsTaskSelected('StaticRunScript')) then
	begin
		currentRemoteRunScript := staticAndDynamicRunCommandsDir + '\Static_RunRemoteTaskOnComputerList.bat';
		
		placeHolder := '#_USERNAME_TO_USE_#'
		Log('Static Run Script - Replacing place holder: '''+placeHolder+''' with value: '''+usernameToUse+'''');
		FileReplaceString(currentRemoteRunScript, placeHolder , usernameToUse);
		
		placeHolder := '#_PASSWORD_TO_USE_#'
		Log('Static Run Script - Replacing place holder: '''+placeHolder+''' with value: ******');
		FileReplaceString(currentRemoteRunScript, placeHolder , passwordToUse);
		
		placeHolder := '#_HOSTING_COMPUTER_#'
		Log('Static Run Script - Replacing place holder: '''+placeHolder+''' with value: '''+hostingRemoteCommandsComputer+'''');
		FileReplaceString(currentRemoteRunScript, placeHolder , hostingRemoteCommandsComputer);
		
	end;
	
	Log({#NEW_LINE});
end;











