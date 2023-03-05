SWITCH (5){
    CASE 2:
        PRINT(2);
        PRINT(3);
        BREAK;
    CASE 5:
        SWITCH (9){
            CASE 9:
                PRINT(9);
                BREAK;
            CASE 8:
                PRINT(8);
            DEFAULT:
                PRINT(11);
                BREAK;
                SWITCH (12){
                    CASE 19:
                        PRINT(19);
                        BREAK;
                }
        }
    DEFAULT:
        PRINT(7);
}