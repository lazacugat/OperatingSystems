#include <stdlib.h>
#include <stdbool.h>

#include "parsing.h"
#include "parser.h"
#include "command.h"
#include <assert.h>


//lee el comando entero para devolver un comndo valido y si no NULL
static scommand parse_scommand(Parser p) 
{
    arg_kind_t argument_type;
    char *argument = parser_next_argument(p,&argument_type);
    scommand res=argument == NULL ? NULL : scommand_new();
    
    while(argument != NULL)
    {   
        switch(argument_type)
        {
            case(ARG_NORMAL):
                scommand_push_back(res,argument);
                break;
            case(ARG_INPUT): 
                scommand_set_redir_in(res,argument);  
                break;

            case(ARG_OUTPUT):
                scommand_set_redir_out(res,argument);                 
                break;

            default:
                break;
        }
        argument = parser_next_argument(p,&argument_type);    
    }
    return res;
}

pipeline parse_pipeline(Parser p) {
    assert( (p != NULL) && (!parser_at_eof(p)) );
    pipeline result = pipeline_new();
    scommand cmd = NULL;
    bool empty_scommand = false, another_pipe=true, is_background= false , has_garbage = false;

    cmd = parse_scommand(p);                                           
    empty_scommand = (cmd==NULL); /* Comando inválido al empezar */
                                                         
    while (another_pipe && !empty_scommand) {
      pipeline_push_back(result,cmd);
      parser_op_pipe(p, &another_pipe);
      cmd = parse_scommand(p);
      empty_scommand = (cmd==NULL);
    }

    parser_skip_blanks(p); /* Tolerancia a espacios posteriores */

    parser_op_background(p, &is_background);

    pipeline_set_wait(result,!is_background);

    parser_garbage(p, &has_garbage); /*Consumir todo lo que hay inclusive el \n*/
    
    if(has_garbage) /* Si hubo error, hacemos cleanup */
    {
        pipeline_destroy(result);
        result = NULL;
        fprintf(stderr,"bash: syntax error\n");
    }

    return result;
}