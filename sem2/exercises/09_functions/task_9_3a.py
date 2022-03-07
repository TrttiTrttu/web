# -*- coding: utf-8 -*-
"""
Задание 9.3a

Сделать копию функции get_int_vlan_map из задания 9.3.

Дополнить функцию: добавить поддержку конфигурации, когда настройка access-порта
выглядит так:
    interface FastEthernet0/20
        switchport mode access
        duplex auto

То есть, порт находится в VLAN 1

В таком случае, в словарь портов должна добавляться информация, что порт в VLAN 1
Пример словаря:
    {'FastEthernet0/12': 10,
     'FastEthernet0/14': 11,
     'FastEthernet0/20': 1 }

У функции должен быть один параметр config_filename, который ожидает
как аргумент имя конфигурационного файла.

Проверить работу функции на примере файла config_sw2.txt

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
            if line.find('duplex') != -1 and intf not in d_access.keys() and intf not in d_trunk.keys():
                 d_access[intf] = [1]
    
    return (d_access, d_trunk)

print(get_int_vlan_map('config_sw2.txt'))