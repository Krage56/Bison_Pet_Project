SWITCH (5){
    CASE 2:
        PRINT(2);
        PRINT(3);
        BREAK;
    CASE 5:
        SWITCH (8){
            CASE 9:
                PRINT(9);
                BREAK;
            CASE 8:
                PRINT(8);
            DEFAULT:
                PRINT(11);
                SWITCH (12){
                    CASE 19:
                        PRINT(19);
                        BREAK;
                }
        }
    DEFAULT:
        PRINT(7);
}