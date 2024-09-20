﻿
-- Do NOT EDIT Unique Code. EDIT ONLY TEXT.
-- 고유 코드를 절대로 수정하지 마십시오. 텍스트만 수정하십시오.

local L = ulxSTC:AddLanguage("한국어", "ko")
-- ulxSTC:AddLanguage("Language Name", "Language Code")

-- L.(Unique Code) = "text"
L.Make_New = "새로 만들기"
L.Make_New_Shortcut = "새 단축키 만들기"
L.Edit_Shortcut = "\"%s\" 수정"
L.Delete_Shortcut = "\"%s\" 삭제"
L.Select_All = "모두 선택"
L.De_Select_All = "모두 취소"
L.Mirror = "선택 반전"
L.Select_The_Command_To_Creat_Shortcut = "단축키를 추가할 명령어 선택"
L.Command_List_Ex = "명령어를 선택해서 단축키로 만듭니다. 여기서는 대상(플레이어)가 있는 명령어만 나열되어있습니다."
L.Command_Shortcut_Setting = "%s의 단축키 추가 설정"
L.No_Ex_For_This_Command = "이 명령어에 대한 설명이 없습니다."
L.Shortcut_Name_Setting = "이 단축어의 이름"
L.Shortcut_Default_Args_Ex = "단축키를 누를 때 이 값이 적용됩니다."
L.Cancel = "취소"
L.Add = "추가"
L.Back = "뒤로"
L.Run = "실행"
L.Apply = "적용"
L.Bool_Arg_Ex = "이 명령어의 작동 방식을 선택합니다. ulx mute로 예를 들면, true일 경우 !mute, false일 경우 !unmute와 같습니다."
L.CopiedToClipboard_HKList = "단축키 배열이 클립보드에 복사됐습니다. 디스코드 등을 이용해서 이걸 공유하면, 다른 사람도 나와 똑같은 단축키 배열을 사용할 수 있습니다."
L.CopyToClipboard = "내 단축키 배열을 복사"
L.SetListTo = "공유받은 단축키 배열을 적용"
L.SetListToEx = "공유받은 단축키 배열을 여기에 붙여넣으세요"
L.SetListToError = "공유받은 단축키 배열에 문제가 있어서 적용에 실패했습니다."
L.MoLodingError = "[%s] 커맨드가 유효하지 않습니다! 사용할 수 있는 커맨드가 맞는지 확인하십시오!"
L.NotString = "알 수 없는 문제로 잘못된 값을 전달 받았습니다...(문자열이 아닙니다.)"
L.CompileError = "컴파일 에러입니다..."
L.CalError = "계산식 오류입니다..."
L.CalculateError = "인수 계산 도중 문제가 발생해서 명령을 실행할 수 없음: %s"
L.ExcuteNumExpHere = "여기에 수식 입력(변수 및 random()등을 사용 가능)"
L.UseNumExpHere = "숫자 인수에 고급 수식 사용"
L.UseNumExpHereExp = "고정되어 있지 않은 숫자 인수를 위해, 여러 변수와 사칙 연산 그리고 함수를 사용할 수 있습니다.\n고급 수식을 사용하려면 체크하세요.\n사용 가능한 변수 및 함수 목록을 보려면 이 버튼을 클릭하세요."
