SET SERVEROUTPUT ON;
 
DECLARE
    CONN         UTL_TCP.CONNECTION;
    RETVAL       BINARY_INTEGER;
    L_RESPONSE   VARCHAR2(1000) := '';
    L_TEXT  VARCHAR2(1000);    
    bcCopy number := 10;
    tagVal varchar2(50) := '#orclAPEX';
    image varchar2(4000);
BEGIN
    image := 'eJzt07ENwyAQBVAQhUtG8CiMBlKKlBkho8SjeARLaSgsLhx3kG8lrtKGwnpCzoH8f4z5cUWivZuIitJWk9qxk3hiL2LPXsUzexMHdh7jxwG8F4qO3/g3On7lWUnGL/rQLScHtFetHCAj5IC4t+u1A+ozPulR2puFfSe5Pfsm0yhVX9Vr9UW9VSd1Bhcwoam7oAN4BnuwA1uwOdmfTubg/Pj9PnRwiZokfzJwBm/gBZzAptvyN+9NqYnE3qDYEgn7O6+YR45GcvQyYR25O8m9RT5JH1rknt79mctnr7Bv2EPsJ/YW+4w9x/4f/hf/dbpeLRp10g==:D9E7';
    
    L_TEXT := '^XA
^PW450
^FO352,32^GFA,01152,01152,00012,:Z64:'
||image||
'^BY2,3,51^FT368,45^BCI,,Y,N
^FD>:'||tagVal||'^FS
^FT368,108^A0I,33,33^FH\^FDZEBRA (ZPL-II)^FS
^FT11,151^BQN,2,3
^FH\^FDLA,https://bryangilbertson.com^FS
^PQ'||bcCopy||',0,1,Y^XZ';
    
    --OPEN THE CONNECTION
    CONN := UTL_TCP.OPEN_CONNECTION(
        REMOTE_HOST   => '192.168.16.217',
        REMOTE_PORT   => 9100,
        TX_TIMEOUT    => 10
    );

    --WRITE TO SOCKET
    RETVAL := UTL_TCP.WRITE_LINE(CONN,L_TEXT);
    UTL_TCP.FLUSH(CONN);
    
    -- CHECK AND READ RESPONSE FROM SOCKET
    BEGIN
        WHILE UTL_TCP.AVAILABLE(CONN,10) > 0 LOOP
            L_RESPONSE := L_RESPONSE ||  UTL_TCP.GET_LINE(CONN,TRUE);
        END LOOP;
    EXCEPTION
        WHEN UTL_TCP.END_OF_INPUT THEN
            NULL;
    END;
 
    DBMS_OUTPUT.PUT_LINE('Response from Socket Server : ' || L_RESPONSE);
    UTL_TCP.CLOSE_CONNECTION(CONN);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20101,SQLERRM);
        UTL_TCP.CLOSE_CONNECTION(CONN);
END;
/
