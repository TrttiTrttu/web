# -*- coding: utf-8 -*-
"""
Задание 12.2


Функция ping_ip_addresses из задания 12.1 принимает только список адресов,
но было бы удобно иметь возможность указывать адреса с помощью диапазона,
например, 192.168.100.1-10.

В этом задании необходимо создать функцию convert_ranges_to_ip_list,
которая конвертирует список IP-адресов в разных форматах в список,
где каждый IP-адрес указан отдельно.

Функция ожидает как аргумент список, в котором содержатся IP-адреса
и/или диапазоны IP-адресов.

Элементы списка могут быть в формате:
* 10.1.1.1
* 10.1.1.1-10.1.1.10
* 10.1.1.1-10

Если адрес указан в виде диапазона, надо развернуть диапазон в отдельные
адреса, включая последний адрес диапазона.
Для упрощения задачи, можно считать, что в диапазоне всегда меняется только
последний октет адреса.

Функция возвращает список IP-адресов.

Например, если передать функции convert_ranges_to_ip_list такой список:
['8.8.4.4', '1.1.1.1-3', '172.21.41.128-172.21.41.132']

Функция должна вернуть такой список:
['8.8.4.4', '1.1.1.1', '1.1.1.2', '1.1.1.3', '172.21.41.128',
 '172.21.41.129', '172.21.41.130', '172.21.41.131', '172.21.41.132']

"""
import task_12_1
import ipaddress


def convert_ranges_to_ip_list(ip_list):
    res = []
    for i in ip_list:
        if i.find('-') != -1:
            num = i[i.find('-') + 1:]
            net = i[:i.find('-')]

            if num.find('.') != -1:
                num = int(num[num.rfind('.') + 1:]) - int(net[net.rfind('.') + 1:])
            else:
                num = int(num)

            ip = ipaddress.ip_address(net)
            for k in range(num + 1):
                res.append(format(ipaddress.IPv4Address(ip + k)))
        else:
            res.append(i)
    return res

if __name__ == "__main__":
    ip = ['8.8.4.4', '1.1.1.1-3', '172.21.41.128-172.21.41.132']
    print(convert_ranges_to_ip_list(ip))