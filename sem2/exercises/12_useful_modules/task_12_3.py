# -*- coding: utf-8 -*-
"""
Задание 12.3

Создать функцию print_ip_table, которая отображает таблицу доступных
и недоступных IP-адресов.

Функция ожидает как аргументы два списка:
* список доступных IP-адресов
* список недоступных IP-адресов

Результат работы функции - вывод на стандартный поток вывода таблицы вида:

Reachable    Unreachable
-----------  -------------
10.1.1.1     10.1.1.7
10.1.1.2     10.1.1.8
             10.1.1.9

"""
from tabulate import tabulate
from task_12_1 import ping_ip_addresses
from task_12_2 import convert_ranges_to_ip_list

def print_ip_table(reachable, unreachable):
    table_tmp = {'Reachable': reachable, 'Unreachable': unreachable}

    print(tabulate(table_tmp, headers='keys'))

    
if __name__ == "__main__":
    ip = ['8.8.8.8', '9.9.9.9', '10.1.1.1-3', '123.2.1.3']
    ip_list = ping_ip_addresses(convert_ranges_to_ip_list(ip))
    print_ip_table(ip_list[0], ip_list[1])