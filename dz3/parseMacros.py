"""
Kako parsiram makro naredbe:
Makro naredbe su zapravo nista drugo nego skraceni nacin pisanja assemblera.
To znaci da cu od linije gdje je zapisana makro naredba tu makro naredbu zamijeniti odgovarajucim
assemblerskim kodom.

Zatim je lako taj kod normalno proci funkcijom parse_command

"""
def _parse_macros(self):
    self._init_macros()
    self._iter_macros(self._parse_macro)

def _parse_macro(self, line, o, p):
    #ako redak uopce nije makro naredba
    if line[0] != '$':
        return [line]#linija uopce nije makro
    com = line[1:]
    macro = com.split('(')[0]

    #je li makro definiran
    if macro not in self._macros:
        self._flag = False
        self._line = o
        self._errm = "Unidentified macro"
        return [line]

    #provjera zagrada
    #ovo je, primjerice, u redu s ovakvom provjerom zagrada
    #MV((R0), (R1))
    openP = []

    for c in com:
        if c == '(':
            openP.append(c)
        if c == ')':
            if(len(openP) > 0):
                openP.pop()
            else:
                self._flag = False
                self._line = o
                self._errm = "Unmatched ')'"
                return [line]
    
    if(len(openP) > 0):
        self._flag = False
        self._line = o
        self._errm = "Unclosed '('"
        return [line]

    args = []
    
    #ili ti ga ako macro nije bas end
    if self._macros[macro] > 0:
        args = com.split('(', 1)[1].rsplit(')', 1)[0].split(',')
        for i in range(0, len(args)):
            args[i] = args[i].strip('()')

    if len(args) != self._macros[macro]:
        self._flag = False
        self._line = o
        self._errm = ("Insufficient number of" if len(args) < self._macros[macro] else "Too many") + " arguments for macro " + macro
        return [line]

    #makro je prosao sve glavne provjere, vrijeme je za parsiranje
    macro_lines = []
    if(macro == 'MV'):
        return self._parse_MV(macro, args, o, p)

    elif(macro == 'SWP'):
        return self._parse_SWP(macro, args, o, p)

    elif(macro == 'SUM'):
        return self._parse_SUM(macro, args, o, p)

    elif(macro == 'WHILE'):
        return self._parse_WHILE(macro, args, o, p)
    
    elif(macro == 'END'):
        return self._parse_END(macro, args, o, p)

    #vracanje praznog stringa znaci da  iter_lines nece napraviti nikakvu promjenu na stringu
    #mi smo je vec napravili ovdje
    return ""

def _parse_MV(self, macro, args, o, p):
    mf = open('./macros/MV.macro', 'r')
    lines = mf.readlines()
    for i in range(0, len(lines)):
        lines[i] = lines[i].replace('[0]', args[0])
        lines[i] = lines[i].replace('[1]', args[1])
        lines[i] = lines[i].strip().strip('\n')
    mf.close()
    return lines

def _parse_SWP(self, macro, args, o, p):
    mf = open('./macros/SWP.macro', 'r')
    lines = mf.readlines()
    for i in range(0, len(lines)):
        lines[i] = lines[i].replace('[0]', args[0])
        lines[i] = lines[i].replace('[1]', args[1])
        lines[i] = lines[i].strip().strip('\n')
    mf.close()
    return lines

def _parse_SUM(self, macro, args, o, p):
    mf = open('./macros/SUM.macro', 'r')
    lines = mf.readlines()
    for i in range(0, len(lines)):
        lines[i] = lines[i].replace('[0]', args[0])
        lines[i] = lines[i].replace('[1]', args[1])
        lines[i] = lines[i].replace('[2]', args[2])
        lines[i] = lines[i].strip().strip('\n')
    mf.close()
    return lines

def _parse_WHILE(self, macro, args, o, p):
    mf = open('./macros/WHILE.macro', 'r')
    lines = mf.readlines()
    self._while_loops.append((self._while_count, o))
    self._while_count += 1
    for i in range(0, len(lines)):
        lines[i] = lines[i].replace('[label0]', f'WHILE{self._while_loops[-1][0]}')
        lines[i] = lines[i].replace('[0]', args[0])
        lines[i] = lines[i].replace('[label1]', f'ENDWHILE{self._while_loops[-1][0]}')
        lines[i] = lines[i].strip().strip('\n')
    
    mf.close()
    return lines

def _parse_END(self, macro, args, o, p):
    if(len(self._while_loops) == 0): #ovo sprjecava zatvaranje nepostojece while petlje
        self._flag = False
        self._line = o
        self._errm = "Closure of a non-existent WHILE loop"
        return ""
    
    
    mf = open('./macros/END.macro', 'r')
    lines = mf.readlines()
    for i in range(0, len(lines)):
        lines[i] = lines[i].replace('[label0]', f'WHILE{self._while_loops[-1][0]}')
        lines[i] = lines[i].replace('[label1]', f'ENDWHILE{self._while_loops[-1][0]}')
        lines[i] = lines[i].strip().strip('\n')

    self._while_loops.pop()
    mf.close()
    return lines
#self._macros je rjecnik koji sprema koliko argumenata makro naredba prima
#te naziv same makro naredbe
def _init_macros(self):
    self._macros = {
        "MV": 2,
        "SWP": 2,
        "SUM": 3,
        "WHILE": 1,
        "END": 0
    }
    #temp ce biti rezervirana oznaka, tj, ako korisnik bude koristio temp oznaku
    #za neku svoju varijablu ili oznaku, dogodit ce se undefined behavior
    #temp_name = 'temp'
    self._while_count = 0

    #odavdje cu izbacivati jedan po jedan while kako budem dolazio do endova
    #u listi ce se nalaziti uredeni parovi rednih brojeva while petlji (pocevsi od nule)
    #i brojeva redova u kojima se nalaze
    self._while_loops = []
    