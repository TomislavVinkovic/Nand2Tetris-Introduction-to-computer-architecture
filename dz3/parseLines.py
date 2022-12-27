def _parse_lines(self):
    self._comment = False    
    self._iter_lines(self._parse_line)

def _parse_line(self, line : str, p, o):
    l = ""
    i = 0
    k = ''
    
    #ovo je potrebno jer zadnja linija u datoteci ne mora biti nuzno prazna
    if('\n' not in line):
        line += '\n'

    while i < len(line) - 1:
        p = line[i] + line[i + 1]

        if (self._comment == False and p == "/*") or (self._comment and p == "*/"):
            self._comment = not self._comment
            i += 1
        elif self._comment == False and p == "*/":
            self._flag = False
            self._line = o
            self._errm = "Unbalanced comment delimiter"
        elif (p == "//"):
            break
        elif line[i].isspace() == False and self._comment == False:
            l += line[i]

        i += 1
    return l 