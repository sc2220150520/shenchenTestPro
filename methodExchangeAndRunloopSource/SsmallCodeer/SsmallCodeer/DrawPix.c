//
//  DrawPix.c
//  SsmallCodeer
//
//  Created by shen chen on 2017/9/20.
//  Copyright © 2017年 shenchen. All rights reserved.
//


#include "DrawPix.h"

void draw_picture(int index)
{
    int low = 2 * index - 1;
    int startlow = index; int starNum = 1;
    for (int i = 1; i <= index; i++) {
        int start_switch = 0; int open_switch = 1; int star_count = 0;
        for (int j = 1; j<=low; j++) {
            if (j < startlow) {
                printf(" ");
            } else if (j == startlow) {
                start_switch = 1;
                printf("*");
                open_switch = 0;
                star_count++;
            } else if (j > startlow) {
                if (star_count < starNum) {
                    if (open_switch == 1) {
                        printf("*");
                        open_switch = 0;
                        star_count++;
                    } else if (open_switch == 0) {
                        printf(" ");
                        open_switch = 1;
                    }
                } else {
                     printf(" ");
                }
            }
        }
        startlow--;
        starNum++;
        printf("\n");
    }
}
