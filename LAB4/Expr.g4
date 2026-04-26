grammar Expr;
expr
    :expr '^' expr
    | expr ('*'|'/') expr
     | expr ('+'|'-') expr
     | '(' expr  ')'
     | ID
     | NUMBER
     ;

     ID : [a-zA-Z]+;
     NUMBER: [0-9]+('.'[0-9]+)?;
     WS    :[ \t\r\n]+ ->skip;

