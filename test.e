MODULE 'DelphE/FileUtils', 'DelphE/Array', 'DelphE/String'

PROC main()
    DEF names: arr, fu: fileUtils, s: string, i


    NEW fu
    names:=fu.contents('Files:e/DelphE')

    WriteF('Adding \d nodes\n', names.length())

    FOR i:=0 TO names.length()-1
       s:=names.getItem(i)
       WriteF('[\d]=\s\n', i, s.value)
    ENDFOR

    WriteF('Test complete!\n')
ENDPROC
