grammar Oberon;

compilationUnit
  : 'MODULE' name = Id ';' declarations block? 'END' Id '.'
  ;  

declarations
  : ('CONST' constant+)? ('VAR' varDeclaration+)? procedure*
  ;
  
constant
  : constName = Id '=' exp = expression ';'
  ;

varDeclaration
  : (vars += Id (',' vars += Id)*) ':' varType = oberonType ';'    
  ; 

procedure :
  'PROCEDURE' name = Id '(' formals?  ')' (: procedureType = oberonType)? ';'
    declarations    // NOTE: This might support nested procedures
    block
   Id
  ; 

formals
 : formalArg (',' formalArg)*
 ;

arguments
 : expression (',' expression)*
 ;
 
formalArg 
 : (args += Id (',' args += Id)*) ':' argType = oberonType ';' 
 ; // TODO: we should also support VarBased formal arguments.
 
block
 : 'BEGIN' statement 'END'
 ; 
    
expression
 : '(' expression ')'                                                                     #Brackets
 | intValue                                                                               #IntegerValue
 | boolValue                                                                              #BooleanValue 
 | name = Id                                                                              #Variable
 | name = Id '(' arguments? ')'                                                           #FunctionCall       
 | left = expression opr = ('=' | '#' | '<' | '<=' | '>' | '>=')  right = expression      #RelExpression 
 | left = expression opr = ('*' | '/' | '&&') right = expression                          #MultExpression  
 | left = expression opr = ('+' | '-' | '||') right = expression                          #AddExpression
 ;

statement
 : var = Id ':=' exp = expression                                                          #AssignmentStmt
 | stmt += statement (';' stmt += statement)+                                              #SequenceStmt
 | 'readInt'  '(' var = Id ')'                                                             #ReadIntStmt
 | 'write' '(' expression ')'                                                              #WriteStmt
 | name = Id '(' arguments? ')'                                                            #ProcedureCall
 | 'IF' cond = expression 'THEN' thenStmt = statement ('ELSE' elseStmt = statement)? 'END' #IfElseStmt
 | 'WHILE' cond = expression 'DO' stmt = statement 'END'                                   #WhileStmt
 | 'RETURN' exp = expression                                                               #ReturnStmt
 ; 
 
// TODO: NOT, MOD, Relational operators, 
// <assoc=right> expr '::' expr

intValue : INT ;

boolValue: TRUE | FALSE ;

oberonType
 : 'INTEGER'
 | 'BOOLEAN'
 ;

INT : Digit+;

TRUE  : 'True' ;
FALSE : 'False'  ;


Id : CharDef (CharDef | Digit | '_')* ;

CharDef
  : ('a'..'z') | ('A' .. 'Z')
  ;


fragment Digit : [0-9] ;

//
// Whitespace and comments
//

NL
   : '\n'
   | '\r' '\n'?
   ;
   

fragment WhiteSpace
   : '\u0020' | '\u0009' | '\u000D' | '\u000A'
   ;
   
NEWLINE
   : NL+ -> skip
   ;

WS
   :  WhiteSpace+ -> skip
   ;

COMMENT
   :   '/*' .*? '*/' -> skip
   ;


LINE_COMMENT
   :   '//' (~[\r\n])* -> skip
   ;