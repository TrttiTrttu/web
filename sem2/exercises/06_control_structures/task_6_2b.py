# -*- coding: utf-8 -*-
"""
Задание 6.2b

Сделать копию скрипта задания 6.2a.

Дополнить скрипт: Если адрес был введен неправильно, запросить адрес снова.

Если адрес задан неправильно, выводить сообщение: 'Неправильный IP-адрес'
Сообщение "Неправильный IP-адрес" должно выводиться только один раз,
даже если несколько пунктов выше не выполнены.

Ограничение: Все задания надо выполнять используя только пройденные темы.
"""

repeat = True

while (repeat):
    ip_addr = input('Введите ip\n')
    ip_addr = ip_addr.split('.')
    flag = False
    
    for i in ip_addr:
        if i.isdigit():
            if (0 <= int(i) <= 255):
                continue
            else:
                flag = True
                break
        else:
            flag = True
            break

    if (flag):
        print('Неправильный ip')

    else:
        repeat = False
        if 1 < int(ip_addr[0]) < 223:
            print('unicast')

        elif 224 < int(ip_addr[0]) < 239:
            print('multicast')

        elif int(ip_addr[0]) == 255 and int(ip_addr[1]) == 255 and int(ip_addr[2]) == 255 and int(ip_addr[3]) == 255:
            print('local broadcast')

        elif int(ip_addr[0]) == 0 and int(ip_addr[1]) == 0 and int(ip_addr[2]) == 0 and int(ip_addr[3]) == 0:
            print('unassigned')

        else:
            print('unused')
