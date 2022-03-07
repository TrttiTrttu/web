# -*- coding: utf-8 -*-
"""
Задание 9.3

Создать функцию get_int_vlan_map, которая обрабатывает конфигурационный
файл коммутатора и возвращает кортеж из двух словарей:
* словарь портов в режиме access, где ключи номера портов,
  а значения access VLAN (числа):
{'FastEthernet0/12': 10,
 'FastEthernet0/14': 11,
 'FastEthernet0/16': 17}

* словарь портов в режиме trunk, где ключи номера портов,
  а значения список разрешенных VLAN (список чисел):
{'FastEthernet0/1': [10, 20],
 'FastEthernet0/2': [11, 30],
 'FastEthernet0/4': [17]}

У функции должен быть один параметр config_filename, который ожидает как аргумент
имя конфигурационного файла.

Проверить работу функции на примере файла config_sw1.txt

Ограничение: Все задания надо выполнять используя только пройденные темы.
"""


def get_int_vlan_map(config_filename):
    d_access = {}
    d_trunk = {}
    with open(config_filename, 'r') as file:
        intf = ''
        for line in file.read().split('\n'): 
            if line.find('interface') != -1:
                intf = line[line.find(' ') + 1:]
                continue
            if line.find('trunk allowed') != -1:
                d_trunk[intf] = list(map(int, line[line.rfind(' ') + 1:].split(',')))
            elif line.find('access vlan') != -1:
                d_access[intf] = list(map(int, line[line.rfind(' ') + 1:].split(',')))
    
    return (d_access, d_trunk)

print(get_int_vlan_map('config_sw1.txt'))