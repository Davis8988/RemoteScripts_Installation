procedure ShiftDown(Control: TControl; DeltaY: Integer);
begin
  Control.Top := Control.Top + DeltaY;
end;

procedure ShiftRight(Control: TControl; DeltaX: Integer);
begin
  Control.Left := Control.Left + DeltaX;
end;

procedure ShiftDownAndRight(Control: TControl; DeltaX, DeltaY: Integer);
begin
  ShiftDown(Control, DeltaY);
  ShiftRight(Control, DeltaX);
end;

procedure GrowDown(Control: TControl; DeltaY: Integer);
begin
  Control.Height := Control.Height + DeltaY;
end;

procedure GrowRight(Control: TControl; DeltaX: Integer);
begin
  Control.Width := Control.Width + DeltaX;
end;

procedure GrowRightAndDown(Control: TControl; DeltaX, DeltaY: Integer);
begin
  GrowRight(Control, DeltaX);
  GrowDown(Control, DeltaY);
end;

procedure GrowRightAndShiftDown(Control: TControl; DeltaX, DeltaY: Integer);
begin
  GrowRight(Control, DeltaX);
  ShiftDown(Control, DeltaY);
end;

procedure GrowWizard(DeltaX, DeltaY: Integer);
begin
  GrowRightAndDown(WizardForm, DeltaX, DeltaY);

  with WizardForm do
  begin
    GrowRightAndShiftDown(Bevel, DeltaX, DeltaY);
    ShiftDownAndRight(CancelButton, DeltaX, DeltaY);
    ShiftDownAndRight(NextButton, DeltaX, DeltaY);
    ShiftDownAndRight(BackButton, DeltaX, DeltaY);
    GrowRightAndDown(OuterNotebook, DeltaX, DeltaY);
    GrowRight(BeveledLabel, DeltaX);

    { WelcomePage }
    GrowDown(WizardBitmapImage, DeltaY);
    GrowRight(WelcomeLabel2, DeltaX);
    GrowRight(WelcomeLabel1, DeltaX);

    { InnerPage }
    GrowRight(Bevel1, DeltaX);
    GrowRightAndDown(InnerNotebook, DeltaX, DeltaY);

    { LicensePage }
    ShiftDown(LicenseNotAcceptedRadio, DeltaY);
    ShiftDown(LicenseAcceptedRadio, DeltaY);
    GrowRightAndDown(LicenseMemo, DeltaX, DeltaY);
    GrowRight(LicenseLabel1, DeltaX);

    { SelectDirPage }
    GrowRightAndShiftDown(DiskSpaceLabel, DeltaX, DeltaY);
    ShiftRight(DirBrowseButton, DeltaX);
    GrowRight(DirEdit, DeltaX);
    GrowRight(SelectDirBrowseLabel, DeltaX);
    GrowRight(SelectDirLabel, DeltaX);

    { SelectComponentsPage }
    GrowRightAndShiftDown(ComponentsDiskSpaceLabel, DeltaX, DeltaY);
    GrowRightAndDown(ComponentsList, DeltaX, DeltaY);
    GrowRight(TypesCombo, DeltaX);
    GrowRight(SelectComponentsLabel, DeltaX);

    { SelectTasksPage }
    GrowRightAndDown(TasksList, DeltaX, DeltaY);
    GrowRight(SelectTasksLabel, DeltaX);

    { ReadyPage }
    GrowRightAndDown(ReadyMemo, DeltaX, DeltaY);
    GrowRight(ReadyLabel, DeltaX);

    { InstallingPage }
    GrowRight(FilenameLabel, DeltaX);
    GrowRight(StatusLabel, DeltaX);
    GrowRight(ProgressGauge, DeltaX);

    { MainPanel }
    GrowRight(MainPanel, DeltaX);
    ShiftRight(WizardSmallBitmapImage, DeltaX);
    GrowRight(PageDescriptionLabel, DeltaX);
    GrowRight(PageNameLabel, DeltaX);

    { FinishedPage }
    GrowDown(WizardBitmapImage2, DeltaY);
    GrowRight(RunList, DeltaX);
    GrowRight(FinishedLabel, DeltaX);
    GrowRight(FinishedHeadingLabel, DeltaX);
  end;
end;