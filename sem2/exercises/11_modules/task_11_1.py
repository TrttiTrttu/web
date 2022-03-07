# -*- coding: utf-8 -*-
"""
Задание 11.1

Создать функцию parse_cdp_neighbors, которая обрабатывает
вывод команды show cdp neighbors.

У функции должен быть один параметр command_output, который ожидает как аргумент
вывод команды одной строкой (не имя файла). Для этого надо считать все содержимое
файла в строку, а затем передать строку как аргумент функции (как передать вывод
команды показано в коде ниже).

Функция должна возвращать словарь, который описывает соединения между устройствами.

Например, если как аргумент был передан такой вывод:
R4>show cdp neighbors

Device ID    Local Intrfce   Holdtme     Capability       Platform    Port ID
R5           Fa 0/1          122           R S I           2811       Fa 0/1
R6           Fa 0/2          143           R S I           2811       Fa 0/0

Функция должна вернуть такой словарь:

    {("R4", "Fa0/1"): ("R5", "Fa0/1"),
     ("R4", "Fa0/2"): ("R6", "Fa0/0")}

В словаре интерфейсы должны быть записаны без пробела между типом и именем.
То есть так Fa0/0, а не так Fa 0/0.

Проверить работу функции на содержимом файла sh_cdp_n_sw1.txt. При этом функция должна
работать и на других файлах (тест проверяет работу функции на выводе
из sh_cdp_n_sw1.txt и sh_cdp_n_r3.txt).

Ограничение: Все задания надо выполнять используя только пройденные темы.
"""


def parse_cdp_neighbors(command_output):
    """
    Тут мы передаем вывод команды одной строкой потому что именно в таком виде будет
    получен вывод команды с оборудования. Принимая как аргумент вывод команды,
    вместо имени файла, мы делаем функцию более универсальной: она может работать
    и с файлами и с выводом с оборудования.
    Плюс учимся работать с таким выводом.
    """
    table_length = command_output.find('Port ID') + len('Port ID') + 1 - command_output.find('Device ID')
    lcl_device = command_output[:command_output.find('>')].strip()
    command_output = command_output[command_output.find('Device ID'):]
    num_of_devices = len(command_output)//table_length - 1
    dst_devices = []
    lcl_intf = []
    dst_intf = []
    res = {}

    for i in range(1, num_of_devices + 1):
        dst_devices.append(command_output[(command_output.find('Device ID') + table_length ) * i:(command_output.find('Device ID') + table_length) * i + 5].strip())
        lcl_intf.append(command_output[command_output.find('Local Intrfce') + (table_length * i):command_output.find('Local Intrfce') + (table_length * i) + 10].strip().replace(' ',''))
        dst_intf.append(command_output[command_output.find('Port ID') + (table_length * i):command_output.find('Port ID') + (table_length * i) + 8].strip().replace(' ',''))
    
    for i in range(num_of_devices):
        res[(lcl_device, lcl_intf[i])] = (dst_devices[i], dst_intf[i])

    return res

if __name__ == "__main__":
    with open("sh_cdp_n_sw1.txt") as f:
        print(parse_cdp_neighbors(f.read()))
