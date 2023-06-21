CLASS zst_cl_secret_handshake DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    METHODS get_commands
      IMPORTING VALUE(code)     TYPE i
      RETURNING VALUE(commands) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zst_cl_secret_handshake IMPLEMENTATION.

  METHOD get_commands.

    "! Convert number(between 1-31) to binary
    "! Check is there any matching corresponds to commands
    DATA: division  TYPE i,
          remainder TYPE i,
          binary    TYPE string.

    division = code.
    IF division GT 0.
      WHILE division GT 0.
        remainder = division MOD 2.

        division = division DIV 2.

        binary = remainder && binary.
      ENDWHILE.

      DATA(offset) = strlen( binary ) - 1.

      IF substring( val = binary off = offset len = 1 ) EQ 1.
        APPEND 'wink' TO commands.
      ENDIF.
      IF offset - 1 GE 0 AND substring( val = binary off = offset - 1 len = 1 ) EQ 1.
        APPEND 'double blink' TO commands.
      ENDIF.
      IF offset - 2 GE 0 AND substring( val = binary off = offset - 2 len = 1 ) EQ 1.
        APPEND 'close your eyes' TO commands.
      ENDIF.
      IF offset - 3 GE 0 AND substring( val = binary off = offset - 3 len = 1 ) EQ 1.
        APPEND 'jump' TO commands.
      ENDIF.
      IF offset - 4 GE 0 AND substring( val = binary off = offset - 4 len = 1 ) EQ 1.
        DATA(commands_copy) = commands.
        DATA(table_lines) = lines( commands ).
        DATA(idx_a) = 1.

        DO lines( commands ) TIMES.

          commands[ idx_a ] = commands_copy[ table_lines ].
          idx_a += 1.
          table_lines -= 1.

        ENDDO.
      ENDIF.
    ENDIF.

* alternative solution

*    DATA(x) = CONV xstring( code ).
*    DATA(c) = VALUE string_table( ( `wink` ) ( `double blink` ) ( `close your eyes` ) ( `jump` ) ).
*    DO 4 TIMES.
*      CHECK x O CONV xstring( 2 ** ( sy-index - 1 ) ).
*      IF x Z CONV xstring( 16 ).
*        INSERT c[ sy-index ] INTO TABLE commands.
*      ELSE.
*        INSERT c[ sy-index ] INTO commands INDEX 1.
*      ENDIF.
*    ENDDO.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    me->get_commands( code     = 9 ).

    out->write( |debug finished| ).

  ENDMETHOD.

ENDCLASS.
