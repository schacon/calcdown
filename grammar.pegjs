start
  = expression+

expression
  = ass:assignment _ lb* { return ass }
  / cmp:complete lb* { return cmp }
  / wds:wordLine lb* { return wds }

wordLine
  = ws:(word _)+ {
    var ws = [].concat.apply([],ws);
    return ["words", ws.join("")]
  }

complete
  = _ key:variable _ "=>" _
  {
    return ['complete', key]
  }

assignment
  = _ key:variable _ "=" _ val:additive
  {
    return ['assign', key, val]
  }

variable
  = v:([a-zA-Z_][a-zA-Z0-9_]*) {
    var v = [].concat.apply([],v);
    return v.join("");
  }

integer
  = digits:[0-9]+ {
    return parseInt(digits.join(""), 10);
  }

float
  = digits:[\.0-9]+ {
    return parseFloat(digits.join(""), 10);
  }

money
 = "$" integer
 / "$" float

additive
  = left:muldiv _ sign:[+-] _ right:additive {
    return {
      type: "compute",
      name:sign,
      args:[left,right]
    }
  }
  / muldiv

primary
  = (variable / integer / float / money)
  / "(" _ additive:additive _ ")" { return additive; }

muldiv
  = left:primary _ sign:[*/] _ right:muldiv {
    return {
      type: "compute",
      name: sign,
      args:[left, right]
    }
  }
  / primary

word
  = v:(!lb .)+ {
    var v = [].concat.apply([],v);
    return v.join("");
  }

ws
 = [ \t]

_
 = (ws)*

lb
 = "\n"
