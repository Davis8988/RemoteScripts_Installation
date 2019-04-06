
// If ends with Result=True  then the setup will continue.
//   else the setup will not go beyond SEComputerNameInput page untill the user
//     fixes what is needed
function pageComputersNamesInput_NextButtonClick(Page: TWizardPage): Boolean;
var
  computersNames: String;
  computersGroupName: String;
  computersFile: String;
begin
  
  if (radioBtnEnterManuallyMethod.Checked) then
  begin
    computersNames := Trim(textBoxComputersNamesInput.Text);
	if (computersNames = '') then 
    begin
      MsgBox('Please enter Computer Names or IPs', mbError, MB_OK);
      Result := False;
      Exit;
    end;
  end else 
  begin
    computersFile := Trim(textFieldComputersNamesFile.Text);
	if (computersFile = '') then 
    begin
      MsgBox('Please enter Computer Names or IPs File', mbError, MB_OK);
      Result := False;
      Exit;
    end;
	
	if (not FileExists(computersFile)) then
	begin
	  MsgBox('Entered Computer Names or IPs File doesn`t exist at'+{#NEW_LINE}+''''+computersFile+'''', mbError, MB_OK);
      Result := False;
      Exit;
	end;
  end;
  
  computersGroupName := Trim(textFieldComputersGroupName.Text);
  if (computersGroupName = '') then 
  begin
    MsgBox('Please enter Computers Group Name or IPs File', mbError, MB_OK);
    Result := False;
    Exit;
  end;
  
  Result := True;
end;

// If ends with Result=True  then the setup will continue.
//   else the setup will not go beyond SEComputerNameInput page untill the user
//     fixes what is needed
function pageCredentialsInput_NextButtonClick(Page: TWizardPage): Boolean;
var
  computersUserName: String;
  computersPassword: String;
begin
  
  computersUserName := Trim(textFieldComputersUserNameInput.Text);
  computersPassword := Trim(textFieldComputersPasswordInput.Text);
  
  if ((computersUserName = '') or (computersPassword = '')) then 
  begin
    MsgBox('Please fill all details', mbError, MB_OK);
    Result := False;
    Exit;
  end;
  
  Result := True;
end;

// If ends with Result=True  then the setup will continue.
//   else the setup will not go beyond ConfigureFiles page untill the user
//     fixes what is needed
function pageCommandToRun_NextButtonClick(Page: TWizardPage): Boolean;
var
  commandToRun: String;
  commandName: String;
begin
  
  commandToRun := Trim(textBoxCommandToRun.Text);
  commandName := Trim(textFieldCommandName.Text);
  
  if (commandToRun = '') then 
  begin
    MsgBox('Please enter command to run', mbError, MB_OK);
    Result := False;
    Exit;
  end;
  
  if (commandName = '') then 
  begin
    MsgBox('Please enter command name', mbError, MB_OK);
    Result := False;
    Exit;
  end;
  
  Result := True;
end;


// Toggle Computers Names input method 
procedure toggleComputersNamesInputMethod(Sender: TObject);
begin
  if radioBtnEnterManuallyMethod.Checked then 
  begin
    textBoxComputersNamesInput.Enabled := True;
    textFieldComputersNamesFile.Enabled :=False;
	  btnLoadExistingComputersNamesFile.Enabled := False;
	
  end else
  begin
    textBoxComputersNamesInput.Enabled := False;
    textFieldComputersNamesFile.Enabled := True;
	  btnLoadExistingComputersNamesFile.Enabled := True;

  end;
end;

{browse for files after file click}
{ if want to choose directory use function:  browseforFolder('', directoryVar, true) }
procedure btnLoadExistingComputersNamesFile_Click(sender: TObject);
var
  filePath: string;
begin
  if GetOpenFileName('', filePath,'','*.*', '') then
  begin
    textFieldComputersNamesFile.Text := filePath;
  end;
end;

// ************* initializePageComputersNamesInput - BEGIN ****************************************************************************************************************************************
procedure initializePageComputersNamesInput();
var
    pageComputersNamesInput: TWizardPage;
    lblEnterComputersGroupName: TLabel;
begin
    pageComputersNamesInput := CreateCustomPage(wpSelectComponents, 'Computers to run on', 'Enter Your List of Computers');
    idNumberPageComputersNamesInput := pageComputersNamesInput.ID;
    
    with pageComputersNamesInput do
    begin
      OnNextButtonClick := @pageComputersNamesInput_NextButtonClick;
    end;
    
	{ radioBtnLoadComputerListMethod}
    radioBtnLoadComputerListMethod := TNewRadioButton.Create(pageComputersNamesInput);
    with radioBtnLoadComputerListMethod do
    begin
      Parent := pageComputersNamesInput.Surface;
      Left := ScaleX(0);
      Top := ScaleY(0);
      Width := pageComputersNamesInput.SurfaceWidth;
      Font.Size := 9;
	  Font.Style := [fsBold];
      Caption := 'Load existing list file:';
      Checked := True;
      OnClick := @toggleComputersNamesInputMethod;
    end;
	
	{ textFieldComputersNamesFile }
    textFieldComputersNamesFile := TEdit.Create(pageComputersNamesInput);
    with textFieldComputersNamesFile do
    begin
      Parent := pageComputersNamesInput.Surface;
      Left := ScaleX(0);
      Top := radioBtnLoadComputerListMethod.Top + radioBtnLoadComputerListMethod.Height + ScaleY(8);
      Width := ScaleX(fileTextFieldWidth);
      Height := ScaleY(21);
      Enabled := True;
      TabOrder := 1;
      Font.Size := 8;
    end;
	
	{ btnLoadExistingComputersNamesFile }
    btnLoadExistingComputersNamesFile := TButton.Create(pageComputersNamesInput);
    with btnLoadExistingComputersNamesFile do
    begin
      Parent := pageComputersNamesInput.Surface;
      Left := textFieldComputersNamesFile.Left+ textFieldComputersNamesFile.Width + ScaleX(8);
      Top := radioBtnLoadComputerListMethod.Top + radioBtnLoadComputerListMethod.Height + ScaleY(8);
      Width := ScaleX(60);
      Height := ScaleY(21);
      TabOrder := 1;
      Enabled := True;
      Caption := 'Browse';
      OnClick := @btnLoadExistingComputersNamesFile_Click
    end;
	
	{ radioBtnEnterManuallyMethod}
    radioBtnEnterManuallyMethod := TNewRadioButton.Create(pageComputersNamesInput);
    with radioBtnEnterManuallyMethod do
    begin
      Parent := pageComputersNamesInput.Surface;
      Left := ScaleX(0);
      Top := textFieldComputersNamesFile.Top + textFieldComputersNamesFile.Height + ScaleY(10);
      Width := pageComputersNamesInput.SurfaceWidth;
      Font.Size := 9;
      Font.Style := [fsBold];
      Caption := 'Enter Manually:  (1 Computer-Name for each line)';
      Checked := False;
      OnClick := @toggleComputersNamesInputMethod;
    end;
	
    { textBoxComputersNamesInput }
    textBoxComputersNamesInput := TNewMemo.Create(pageComputersNamesInput);
    with textBoxComputersNamesInput do
    begin
      Parent := pageComputersNamesInput.Surface;
      Left := ScaleX(0);
      Top := radioBtnEnterManuallyMethod.Top + radioBtnEnterManuallyMethod.Height + ScaleY(8);
      Width := ScaleX(inputTextBoxWidth);
      Height := ScaleY(160);
      Enabled := False;
      TabOrder := 0;
      ScrollBars := ssBoth;
      Font.Size := 10;
    end;
	
	{ lblEnterComputersGroupName }
    lblEnterComputersGroupName := TLabel.Create(pageComputersNamesInput);
    with lblEnterComputersGroupName do
    begin
      Parent := pageComputersNamesInput.Surface;
      Left := ScaleX(0);
      Top := textBoxComputersNamesInput.Top + textBoxComputersNamesInput.Height + ScaleY(18);
      Width := ScaleX(130);
      Height := ScaleY(21);
      Enabled := True;
      Font.Size := 8;
      Caption := 'Enter PC Group-Name: '+{#NEW_LINE} + '(It will be the name of the computer list file. If you choose a name that ' + {#NEW_LINE} + 'was used before in previous run of this setup, the file will be overwritten)';
    end;
	
	{ textFieldComputersGroupName }
    textFieldComputersGroupName := TEdit.Create(pageComputersNamesInput);
    with textFieldComputersGroupName do
    begin
      Parent := pageComputersNamesInput.Surface;
      Left := ScaleX(0);
      Top := lblEnterComputersGroupName.Top + lblEnterComputersGroupName.Height + ScaleY(8);
      Width := ScaleX(namesTextFieldWidth);
      Height := ScaleY(21);
      Enabled := True;
      TabOrder := 1;
      Font.Size := 8;
    end;
end;
// ************* initializePageComputersNamesInput - END ****************************************************************************************************************************************




// ************* initializePagePageCredentialsInput - BEGIN ****************************************************************************************************************************************
procedure initializePageCredentialsInput();
var   
    pageCredentialsInput: TWizardPage;
    lblEnterComputersUserName: TLabel;
    lblEnterComputersPassword: TLabel;
    lblInfo: TLabel;

begin
	pageCredentialsInput := CreateCustomPage(idNumberPageComputersNamesInput, 'Credentials', 'Enter Credentials for Your Computers');
  idNumberPageCredentialsInput := pageCredentialsInput.ID;
  
  with pageCredentialsInput do
  begin
    OnNextButtonClick := @pageCredentialsInput_NextButtonClick;
  end;

  { lblEnterComputersUserName }
  lblEnterComputersUserName := TLabel.Create(pageCredentialsInput);
  with lblEnterComputersUserName do
  begin
    Parent := pageCredentialsInput.Surface;
    Left := ScaleX(0);
    Top := ScaleY(0);
    Width := ScaleX(100);
    Height := ScaleY(21);
    Enabled := True;
    Font.Size := 8;
    Caption := 'Enter Computers User Name:';
  end;
  
  { textFieldComputersUserNameInput }
  textFieldComputersUserNameInput := TEdit.Create(pageCredentialsInput);
  with textFieldComputersUserNameInput do
  begin
    Parent := pageCredentialsInput.Surface;
    Left := ScaleX(0);
    Top := lblEnterComputersUserName.Top + lblEnterComputersUserName.Height + ScaleY(8);
    Width := ScaleX(userAndPasswordTextFieldWidth);
    Height := ScaleY(21);
    Enabled := True;
    TabOrder := 1;
    Font.Size := 8;
  end;
  
  { lblEnterComputersPassword }
  lblEnterComputersPassword := TLabel.Create(pageCredentialsInput);
  with lblEnterComputersPassword do
  begin
    Parent := pageCredentialsInput.Surface;
    Left := ScaleX(0);
    Top := textFieldComputersUserNameInput.Top + textFieldComputersUserNameInput.Height + ScaleY(8);
    Width := ScaleX(100);
    Height := ScaleY(21);
    Enabled := True;
    Font.Size := 8;
    Caption := 'Enter Computers Password:';
  end;
  
  { textFieldComputersPasswordInput }
  textFieldComputersPasswordInput := TEdit.Create(pageCredentialsInput);
  with textFieldComputersPasswordInput do
  begin
    Parent := pageCredentialsInput.Surface;
    Left := ScaleX(0);
    Top := lblEnterComputersPassword.Top + lblEnterComputersPassword.Height + ScaleY(8);
    Width := ScaleX(userAndPasswordTextFieldWidth);
    Height := ScaleY(21);
    Enabled := True;
    TabOrder := 2;
    Font.Style := [fsBold];
    Font.Size := 12;
    PasswordChar := '*';
  end;
  
  { lblInfo }
  lblInfo := TLabel.Create(pageCredentialsInput);
  with lblInfo do
  begin
    Parent := pageCredentialsInput.Surface;
    Left := ScaleX(0);
    Top := textFieldComputersPasswordInput.Top + textFieldComputersPasswordInput.Height + ScaleY(15);
    Width := pageCredentialsInput.SurfaceWidth;
    Height := ScaleY(21);
    Enabled := True;
    Font.Style := [fsBold];
    Font.Size := 9;
    Caption := {#NEW_LINE}+'*** Attention ***'+{#NEW_LINE}+'Credentials must be the SAME for all computers defined previously';
  end;
end;
// ************* initializePagePageCredentialsInput - END ****************************************************************************************************************************************



// ************* PageCommandToRun - BEGIN ****************************************************************************************************************************************
procedure initializePageCommandToRun();
var
    pageCommandToRun: TWizardPage;
    lblInfo: TLabel;
    lblEnterCommandToRun: TLabel;
    lblEnterCommandName: TLabel;
    checkBoxAddAskIfSureToStaticRun: TNewCheckBox;
  
begin
    pageCommandToRun := CreateCustomPage(idNumberPageCredentialsInput, 'Project Name', 'Enter Your Project Name');
    idNumberPageCommandToRun := pageCommandToRun.ID;
    
    with pageCommandToRun do
    begin
      OnNextButtonClick := @pageCommandToRun_NextButtonClick;
    end;
    
    { lblEnterCommandToRun }
    lblEnterCommandToRun := TLabel.Create(pageCommandToRun);
    with lblEnterCommandToRun do
    begin
      Parent := pageCommandToRun.Surface;
      Left := ScaleX(0);
      Top := ScaleY(0);
      Width := ScaleX(100);
      Height := ScaleY(21);
      Enabled := True;
      Font.Size := 9;
      Caption := 'Type command\script to be executed remotley on chosen computers:';
    end;
    
    { textBoxCommandToRun }
    textBoxCommandToRun := TNewMemo.Create(pageCommandToRun);
    with textBoxCommandToRun do
    begin
      Parent := pageCommandToRun.Surface;
      Left := ScaleX(0);
      Top := lblEnterCommandToRun.Top + lblEnterCommandToRun.Height + ScaleY(8);
      Width := ScaleX(inputTextBoxWidth);
      Height := ScaleY(170);
      Enabled := True;
	  ScrollBars := ssBoth;
      TabOrder := 0;
      Font.Size := 9;
    end;
    
    { lblEnterCommandName }
    lblEnterCommandName := TLabel.Create(pageCommandToRun);
    with lblEnterCommandName do
    begin
      Parent := pageCommandToRun.Surface;
      Left := ScaleX(0);
      Top := textBoxCommandToRun.Top + textBoxCommandToRun.Height + ScaleY(18);
      Width := pageCommandToRun.SurfaceWidth;
      Height := ScaleY(21);
      Enabled := True;
      Font.Size := 9;
      Caption := 'Enter Command Name: '+{#NEW_LINE} + '(It will be the name of the batch file that remote computers will run. If you choose ' + {#NEW_LINE} + 'a name that was used before in previous run of this setup, the file will be overwritten)';
    end;
	
	{ textFieldCommandName }
    textFieldCommandName := TEdit.Create(pageCommandToRun);
    with textFieldCommandName do
    begin
      Parent := pageCommandToRun.Surface;
      Left := ScaleX(0);
      Top := lblEnterCommandName.Top + lblEnterCommandName.Height + ScaleY(8);
      Width := ScaleX(namesTextFieldWidth);
      Height := ScaleY(21);
      Enabled := True;
      TabOrder := 0;
      Font.Size := 8;
    end;
    
	{ checkBoxAddAskIfSureToStaticRun }
	checkBoxAddAskIfSureToStaticRun := TNewCheckBox.Create(pageCommandToRun);
	with checkBoxAddAskIfSureToStaticRun do
	begin
	  Parent := pageCommandToRun.Surface;
	  Left := ScaleX(0);
	  Top := textFieldCommandName.Top + textFieldCommandName.Height + ScaleY(15);
	  Width := pageCommandToRun.SurfaceWidth;
	  Height := ScaleY(21);
	  Enabled := False;
		Checked := True;
	  Font.Size := 9;
	  Font.Style := [fsBold];
	  Caption := 'Include secure ''Ask if Sure?'' flag before launching this command';
	end;
	
	
end;
// ************* PageCommandToRun - END ****************************************************************************************************************************************


procedure initializeBackgroundImage();
var
  BackgroundBitmapImage: TBitmapImage;
  BackgroundBitmapText: TNewStaticText;
  bitmapLoc: String;
  extractedFilesCount: Integer;
begin
  extractedFilesCount := 0;
  extractedFilesCount := ExtractTemporaryFiles('{tmp}\{#BACKGROUND_IMAGE_NAME}');
  if (extractedFilesCount > 0 ) then
  begin
    bitmapLoc := ExpandConstant('{tmp}\{#BACKGROUND_IMAGE_NAME}');
    
    BackgroundBitmapImage := TBitmapImage.Create(MainForm);
    BackgroundBitmapImage.Left := 30;
    BackgroundBitmapImage.Top := 80;
    BackgroundBitmapImage.Bitmap := WizardForm.WizardBitmapImage.Bitmap;
    BackgroundBitmapImage.Bitmap.LoadFromFile(bitmapLoc);
    BackgroundBitmapImage.Parent := MainForm;
    BackgroundBitmapImage.AutoSize := True;
    
    BackgroundBitmapText := TNewStaticText.Create(MainForm);
    BackgroundBitmapText.Left := BackgroundBitmapImage.Left;
    BackgroundBitmapText.Top := BackgroundBitmapImage.Top + BackgroundBitmapImage.Height + ScaleY(8);
    BackgroundBitmapText.Font.Color := clWhite;
    BackgroundBitmapText.Parent := MainForm;
  end;
end;

procedure LoadPreviousData();
var
  computerListInputMode: String;
begin
  { Get Stored Items }
  textFieldComputersNamesFile.Text := GetPreviousData('textFieldComputersNamesFile', '');
  textBoxComputersNamesInput.Text := GetPreviousData('textBoxComputersNamesInput', '');
  textFieldComputersUserNameInput.Text := GetPreviousData('textFieldComputersUserNameInput', '');
  textFieldComputersPasswordInput.Text := GetPreviousData('textFieldComputersPasswordInput', '');
  textBoxCommandToRun.Text := GetPreviousData('textBoxCommandToRun', '');
  textFieldCommandName.Text := GetPreviousData('textFieldCommandName', '');
  textFieldComputersGroupName.Text := GetPreviousData('textFieldComputersGroupName', '');
  
  // Computer List Input Mode:
  case GetPreviousData('computerListInputMode', '') of
    'LoadExistingList': radioBtnLoadComputerListMethod.Checked := True;
    'ManualInput': radioBtnEnterManuallyMethod.Checked := True;
  else
    radioBtnEnterManuallyMethod.Checked := True;
  end;
  
end;

procedure UninstallButtonClick(Sender: TObject);
begin
  UninstallButton.Enabled := False;
end;


procedure CreateUninstallPage();
var
  UninstallFirstPage: TNewNotebookPage;
	lblInstallationDirectory: TLabel;
begin
  { Create the first page and make it active }
    UninstallFirstPage := TNewNotebookPage.Create(UninstallProgressForm);
    UninstallFirstPage.Notebook := UninstallProgressForm.InnerNotebook;
    UninstallFirstPage.Parent := UninstallProgressForm.InnerNotebook;
    UninstallFirstPage.Align := alClient;
    
    
    with UninstallProgressForm do
    begin
      InnerNotebook.ActivePage := UninstallFirstPage;
      PageNameLabel.Caption := 'Uninstall David`s Remote Scripts';
      PageDescriptionLabel.Caption := 'Choose tasks to be carried out by the uninstaller';
      CancelButton.Enabled := True;
      CancelButton.ModalResult := mrCancel;
    end;
    
    PageNameLabel := UninstallProgressForm.PageNameLabel.Caption;
    PageDescriptionLabel := UninstallProgressForm.PageDescriptionLabel.Caption;
    
    
    checkBoxRemoveSharingOfRemoteScriptsDir := TNewCheckBox.Create(UninstallProgressForm);
    with checkBoxRemoveSharingOfRemoteScriptsDir do
    begin
      Parent := UninstallFirstPage;
      Top := UninstallProgressForm.StatusLabel.Top;
      Left := UninstallProgressForm.StatusLabel.Left;
      Width := ScaleX(300);
      Caption := 'Remove Sharing of RemoteScripts Dir';
      Checked := False;
    end;
    
    checkBoxCompletelyRemoveInstallationDirectory := TNewCheckBox.Create(UninstallProgressForm);
    with checkBoxCompletelyRemoveInstallationDirectory do
    begin
      Parent := UninstallFirstPage;
      Top := checkBoxRemoveSharingOfRemoteScriptsDir.Top + checkBoxRemoveSharingOfRemoteScriptsDir.Height + ScaleX(10);
      Left := checkBoxRemoveSharingOfRemoteScriptsDir.Left;
      Width := ScaleY(300);
      Caption := 'Completely Remove Installation Directory:';
      Checked := False;
    end;
    
    lblInstallationDirectory := TLabel.Create(UninstallFirstPage);
    with lblInstallationDirectory do
    begin
      Parent := UninstallFirstPage;
      Left := checkBoxCompletelyRemoveInstallationDirectory.Left;
      Top := checkBoxCompletelyRemoveInstallationDirectory.Top + checkBoxCompletelyRemoveInstallationDirectory.Height + ScaleY(8);
      Width := ScaleX(400);
      Height := ScaleY(21);
      Enabled := True;
      Font.Style := [fsBold];
      Caption := ExpandConstant('{app}');
    end;
    
    
    UninstallButton := TNewButton.Create(UninstallProgressForm);
    with UninstallButton do
    begin
      Parent := UninstallProgressForm;
      Left := UninstallProgressForm.CancelButton.Left - UninstallProgressForm.CancelButton.Width - ScaleX(10);
      Top := UninstallProgressForm.CancelButton.Top;
      Width := UninstallProgressForm.CancelButton.Width;
      Height := UninstallProgressForm.CancelButton.Height;
      Visible := True;
      Caption := 'Uninstall';
      ModalResult := mrOK; { Make the "Uninstall" button break the ShowModal loop }
      onClick := @UninstallButtonClick;
    end;
    
end;

// ---------- Automatically Called Functions - BEGIN ----------------------
procedure RegisterPreviousData(PreviousDataKey: Integer);
var
  computerListInputMode: String;
begin
  { Store the settings so we can restore them next time }
  SetPreviousData(PreviousDataKey, 'textFieldComputersNamesFile', Trim(textFieldComputersNamesFile.text));
  SetPreviousData(PreviousDataKey, 'textBoxComputersNamesInput', Trim(textBoxComputersNamesInput.text));
  SetPreviousData(PreviousDataKey, 'textFieldComputersUserNameInput', Trim(textFieldComputersUserNameInput.text));
  SetPreviousData(PreviousDataKey, 'textFieldComputersPasswordInput', Trim(textFieldComputersPasswordInput.text));
  SetPreviousData(PreviousDataKey, 'textBoxCommandToRun', Trim(textBoxCommandToRun.text));
  SetPreviousData(PreviousDataKey, 'textFieldCommandName', Trim(textFieldCommandName.text));
  SetPreviousData(PreviousDataKey, 'textFieldComputersGroupName', Trim(textFieldComputersGroupName.text));
  
  // Computer List Input Mode:
  computerListInputMode := 'LoadExistingList';
  if (radioBtnEnterManuallyMethod.Checked) then 
  begin
	computerListInputMode := 'ManualInput';
  end;
  SetPreviousData(PreviousDataKey, 'computerListInputMode', computerListInputMode);
  
end;


procedure InitializeUninstallProgressForm();
begin
  if not UninstallSilent then
  begin
    
    CreateUninstallPage();
    
    { Run our wizard pages } 
    CancelButtonEnabled := UninstallProgressForm.CancelButton.Enabled
    CancelButtonModalResult := UninstallProgressForm.CancelButton.ModalResult;
        
    
    // This line stops the compilation here in a loop waiting for user click "Uninstall" button
      if UninstallProgressForm.ShowModal = mrCancel then Abort;
    // Continue here after user has clicked the "Uninstall" button
    
    
    { Restore the standard page payout }
    UninstallProgressForm.CancelButton.Enabled := CancelButtonEnabled;
    UninstallProgressForm.CancelButton.ModalResult := CancelButtonModalResult;

    UninstallProgressForm.PageNameLabel.Caption := PageNameLabel;
    UninstallProgressForm.PageDescriptionLabel.Caption := PageDescriptionLabel;

    UninstallProgressForm.InnerNotebook.ActivePage := UninstallProgressForm.InstallingPage;
  end;
end;


// Occures just before uninstallation begins
//  Asks if user wants to remove network sharing of
//  chosen installation dir at the setup process {app}
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  cmdExitCode : Integer;
  cmdParams : String;
  driveLetter : String;
  tempStr: String;
  newLineStr: String;
  selectedSubstDriveKTask: Boolean;
begin
  { 
    Possible Values
      usUninstall - just before uninstall begins
      usPostUninstall - just after uninstall finishes
      usDone - just before uninstaller window is closed
  }
	newLineStr := '#13#10';
  if CurUninstallStep = usPostUninstall then
  begin
    if (checkBoxCompletelyRemoveInstallationDirectory.Checked) then
		begin
		  cmdParams := 'net share RemoteScripts /delete /Y';
			Exec('cmd.exe', '/c "'+cmdParams+'"', '', SW_HIDE, ewWaitUntilTerminated, cmdExitCode);
			
			if (cmdExitCode <> 0) then
			begin
				MsgBox('Error'+newLineStr+'Could not un-share ''RemoteScripts'' dir: '+newLineStr+ExpandConstant('{app}'), mbError, MB_OK);
			end;
			
			DelTree(ExpandConstant('{app}'), True, True, True);
		end else if (checkBoxRemoveSharingOfRemoteScriptsDir.Checked) then
		begin
			cmdParams := 'net share RemoteScripts /delete /Y';
			Exec('cmd.exe', '/c "'+cmdParams+'"', '', SW_HIDE, ewWaitUntilTerminated, cmdExitCode);
			
			if (cmdExitCode <> 0) then
			begin
				MsgBox('Error'+newLineStr+'Could not un-share ''RemoteScripts'' dir: '+newLineStr+ExpandConstant('{app}'), mbError, MB_OK);
			end;
		end;
		
  end;
end;

// ---------- Automatically Called Functions - END ----------------------
