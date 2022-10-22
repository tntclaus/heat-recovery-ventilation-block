square_vent110x55 = ["square_vent_110x55", "Канал пластиковый плоский 50 (110x55)", 110, 55, 107, 52, 4];
square_vent204x60 = ["square_vent_204x60", "Канал пластиковый плоский 80 (204x60)", 204, 60, 200, 57, 5];


square_vent204x60_t_joint = ["square_vent_204x60_t_joint", "Тройник плоский 838 (204x60)", 208, 63, 204, 60, 5, 248, 288];

square_vent40x80 = ["square_vent_40x80", "Канал пластиковый плоский DIY 40x80", 44, 84, 40, 80, 5];
square_vent80x40 = ["square_vent_80x40", "Канал пластиковый плоский DIY 80x40", 84, 44, 80, 40, 5];
square_vent80x80 = ["square_vent_80x80", "Канал пластиковый плоский DIY 80x80", 84, 84, 80, 80, 5];
square_vent80x80_t_joint = ["square_vent_80x80_t_joint", "Тройник плоский DIY (80x80)", 84, 84, 80, 80, 8];
square_vent154x80_t_joint = ["square_vent_154x80_t_joint", "Тройник плоский DIY (154x80)", 158, 84, 154, 80, 8];


square_vent103x49 = change_type(square_vent110x55, dw = - 4, dh = - 3);
square_vent114x59 = change_type(square_vent110x55, dw = 4, dh = 4);
square_vent88x80 = change_type(square_vent80x80, dw = 8, dh = 0);
square_vent42x80 = change_type(square_vent40x80, dw = 2, dh = 0);
square_vent_54x91 = change_type(square_vent40x80, dw = 10, dh = 7);
square_vent_91x54 = change_type(square_vent80x40, dw = 10, dh = 7);

square_vent82x42 = change_type(square_vent80x40, dw = 2, dh = 2);
square_vent166x92 = change_type(square_vent154x80_t_joint, dw = 8, dh = 8);

square_vent170x80 = ["square_vent_170x80", "Канал плоский DIY (170x80)", 174, 84, 170, 80, 8];

use <square_vent_channel.scad>
