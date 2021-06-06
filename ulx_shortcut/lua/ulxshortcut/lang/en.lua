
-- Do NOT EDIT Unique Code. EDIT ONLY TEXT.
-- 고유 코드를 절대로 수정하지 마십시오. 텍스트만 수정하십시오.

local lang = ulxSTC:AddLanguage("English", "en")
-- ulxSTC:AddLanguage("Language Name", "Language Code")

-- lang.(Unique Code) = "text"
lang.Make_New = "New"
lang.Make_New_Shortcut = "Create A New Shortcut"
lang.Edit_Shortcut = "Edit \"%s\""
lang.Delete_Shortcut = "Delete \"%s\""
lang.Select_All = "Select All"
lang.De_Select_All = "Unselect All"
lang.Mirror = "Reverse"
lang.Select_The_Command_To_Creat_Shortcut = "Select a command to add a shortcut to"
lang.Command_List_Ex = "Select a command and make it a shortcut. Only commands with targets(players) are listed here."
lang.Command_Shortcut_Setting = "%s's shortcut setting"
lang.No_Ex_For_This_Command = "There is no help message for this command."
lang.Shortcut_Name_Setting = "This Shortcut name"
lang.Shortcut_Default_Args_Ex = "This value will be used when you press the shortcut."
lang.Cancel = "Cancel"
lang.Add = "Add"
lang.Back = "Back"
lang.Run = "Run"
lang.Apply = "Apply"
lang.Bool_Arg_Ex = "Choose how this command works. For ulx mute, !mute if true, !unmute if false."
lang.CopiedToClipboard_HKList = "Shortcut Array has been copied to the clipboard. If you share this using Discord or something, other people can use the same shortcut as you."
lang.CopyToClipboard = "Copy My Shortcut Array"
lang.SetListTo = "Apply shared shortcuts"
lang.SetListToEx = "Paste the shared shortcut array here"
lang.SetListToError = "Apply failed because shortcut array is not valid."
lang.MoLodingError = "Command [%s] is not valid! Please check ulx command you can use!"