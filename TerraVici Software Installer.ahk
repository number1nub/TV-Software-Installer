#NoEnv
#SingleInstance, Force
SetWorkingDir, % A_ScriptDir (A_IsCompiled ? "" : "\..")
Menu, Tray, Icon, res\TerraVici.ico

global tabs

version  := "9.1.3"
appTitle := "TerraVici Installer v" version
tw       := 400
th       := 400
bw       := 110

gui, +AlwaysOnTop
Gui, Margin, 5, 5
Gui, Font, s12 bold, Segoe UI
Gui Add, Tab3, w%tw% h%th% vtabs gtabChanged hwndhwndtabs +Section, TerraVici Software|Drivers + Runtimes
Gui, Font, s11 norm
Gui Tab, 1
Gui Add, ListBox, % "hWndhwndSWList vSWList gLBClick xs+7 ys+42 w" (tw-17) " h" (th-40), % GetList(tabs ? tabs : "TerraVici Software")
Gui Tab, 2
Gui Add, ListBox, % "hWndhwndDriverList vDriverList gLBClick xs+7 ys+42 w" (tw-17) " h" (th-40), % GetList(tabs ? tabs : "Drivers + Runtimes")
Gui, tab
Gui Add, Button, % "hwndhBtnInstall gInstall +Disabled y+18 w110 h40 x" ((tw-bw)/2), &Install

Gui Show,, %appTitle%
Return


Install: ;{
	gui, Submit, NoHide
	fPath := A_WorkingDir "\" tabs "\" (tabs="TerraVici Software" ? SWList : DriverList) "\setup.exe"
	Run, %fPath%
	if (ErrorLevel) 
		MBox("ico:!", "Something went wrong when trying to run the installer!")
	Gui, -AlwaysOnTop
	SplashImage,, B1 w500 h150 y200 FM16 FS12 WM700 WS400 CWSilver CTMaroon, Launching the installer..., %appTitle%
	Sleep 1200
	ExitApp
Return ;}


GuiClose:
GuiEscape:	;{
	if (A_ThisLabel="GuiEscape" && A_IsCompiled)
		return
ExitApp	;}


tabChanged: ;{
	gui, Submit, NoHide
	GuiControl, % tabs="TerraVici Software" ? (SWList ? "Enable":"Disable") : (DriverList ? "Enable":"Disable"), %hBtnInstall%
return ;}


LBClick: ;{
	gui, Submit, NoHide
	GuiControl, % tabs="TerraVici Software" ? (SWList ? "Enable":"Disable") : (DriverList ? "Enable":"Disable"), %hBtnInstall%
return ;}


GetList(root) {
	fList := ""
	Loop, Files, %root%\*, D
	{	
		if (SubStr(fName:=A_LoopFileName, 1, 1) = "_")
			Continue
		fList .= (fList ? "|" : "") fName
	}
	return fList
}


MBox(info*) {
	static icons:={"x":16,"?":32,"!":48,"i":64}, btns:={c:1,oc:1,co:1,ari:2,iar:2,ria:2,rai:2,ync:3,nyc:3,cyn:3,cny:3,yn:4,ny:4,rc:5,cr:5}
	for c, v in info {
		if RegExMatch(v, "imS)^(?:btn:(?P<btn>c|\w{2,3})|(?:ico:)?(?P<ico>x|\?|\!|i)|title:(?P<title>.+)|def:(?P<def>\d+)|time:(?P<time>\d+(?:\.\d{1,2})?|\.\d{1,2}))$", m_) {
			mBtns:=m_btn?1:mBtns, title:=m_title?m_title:title, timeout:=m_time?m_time:timeout
			opt += m_btn?btns[m_btn]:m_ico?icons[m_ico]:m_def?(m_def-1)*256:0
		}
		else
			txt .= (txt ? "`n":"") v
	}
	MsgBox, % (opt+262144), %title%, %txt%, %timeout%
	IfMsgBox, OK
		return (mBtns ? "OK":"")
	else IfMsgBox, Yes
		return "YES"
	else IfMsgBox, No
		return "NO"
	else IfMsgBox, Cancel
		return "CANCEL"
	else IfMsgBox, Retry
		return "RETRY"
}