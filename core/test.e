MODULE 'DelphE/String', 'DelphE/Array'

PROC main()
    DEF s: PTR TO string, a: PTR TO arr, i

    NEW a
    a.create()

    NEW s.create('Hello')
    WriteF('1 = [\s]\n', s.value)
    a.add(s)

    WriteF('Length \d\n', a.length())
    s:=a.get(0)
    WriteF('Item[0] = \s\n', s.value)

    NEW s.create('World')
    WriteF('2 = [\s]\n', s.value)
    a.add(s)

    WriteF('Length \d\n', a.length())

    FOR i:=0 TO a.length()-1
        s:=a.get(i)
        WriteF('Item[\d] = \s\n', i, s.value)
    ENDFOR
ENDPROC
