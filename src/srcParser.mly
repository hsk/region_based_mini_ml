%{
open Target.SrcExp
%}
%token <string> VAR %token <int> INT                                // リテラル
%token PLUS MINUS ASTERISK SLASH EQUAL LESS GREATER NOTEQ COLCOL    // 演算子
%token LPAREN RPAREN LBRA RBRA                                      // 括弧類
%token ARROW VBAR                                                   // 区切り記号
%token TRUE FALSE FUN LET REC IN IF THEN ELSE MATCH WITH HEAD TAIL  // キーワード
%token EOF                                                          // 制御記号
// 演算子優先順位 (優先度の低いものほど先)
%nonassoc IN ELSE ARROW WITH
%left VBAR
%left EQUAL GREATER LESS NOTEQ
%right COLCOL
%left PLUS MINUS
%left ASTERISK SLASH
%nonassoc UNARY
// 最後にarg_exprの一番左のトークンを並べる
%left VAR INT TRUE FALSE LBRA LPAREN
%start main %type <Target.SrcExp.t> main
%%
main      : // 開始記号
          | exp EOF               { $1 }
arg_exp   : // 関数の引数になれる式
          | VAR                   { Var $1 }
          | INT                   { IntLit $1 }
        //| TRUE                  { BoolLit true }
        //| FALSE                 { BoolLit false }
          | LBRA RBRA             { Empty }               // 空リスト
          | LPAREN exp RPAREN     { $2 }                  // 括弧で囲まれた式
exp       : // 式
          | arg_exp               { $1 }
          | exp arg_exp           { Call ($1, $2) }       // 関数適用 (e1 e2)
        //| MINUS exp %prec UNARY { Minus (IntLit 0, $2) }// 符号の反転 -e
        //| exp PLUS exp          { Plus ($1, $3) }       // e1 + e2
        //| exp MINUS exp         { Minus ($1, $3) }      // e1 - e2
        //| exp ASTERISK exp      { Times ($1, $3) }      // e1 * e2
        //| exp SLASH exp         { Div ($1, $3) }        // e1 / e2
        //| exp EQUAL exp         { Eq ($1, $3) }         // e1 = e2
        //| exp LESS exp          { Less ($1, $3) }       // e1 < e2
        //| exp GREATER exp       { Greater ($1, $3) }    // e1 > e2
        //| exp NOTEQ exp         { NotEq ($1, $3) }      // e1 <> e2
          | FUN VAR ARROW exp     { Lam ($2, $4) }        // fun x -> e
          | LET VAR EQUAL exp IN exp                      // let x = e1 in e2
                                  { Let ($2, $4, $6) }
          | LET REC VAR VAR EQUAL exp IN exp              // let rec f x = e1 in e2
                                  { LetRec ($3, $4, $6, $8) }
        //| IF exp THEN exp ELSE exp                      // if e1 then e2 else e3
        //                        { If ($2, $4, $6) }
          | error                 { failwith (Printf.sprintf
                                      "parse error near characters %d-%d"
                                      (Parsing.symbol_start ())
                                      (Parsing.symbol_end ()))            }
/*
// 注: yaccでは左再帰のほうがスタック消費量が少ない。
cases_rev : // match文のcaseの列
          | pattern ARROW exp     { [($1, $3)] }
          | cases_rev VBAR pattern ARROW exp
                                  { ($3, $5) :: $1 }
pattern   : // パターン
          | VAR                   { Var $1 }
          | INT                   { IntLit $1 }
          | TRUE                  { BoolLit true }
          | FALSE                 { BoolLit false }
          | LBRA RBRA             { Empty }
*/