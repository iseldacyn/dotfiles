#!/bin/python3
# from https://gist.github.com/fjueic/1ba317bcd9884bdb2f0ddab996206630

import datetime
import sys


def hours_in_binary(hours):
    hours = bin(hours)[2:]
    if len(hours) < 4:
        hours = "0" * (4 - len(hours)) + hours
    return hours.replace("1", "●").replace("0", "○")


def minutes_in_binary(minutes):
    minutes = bin(minutes)[2:]
    if len(minutes) < 6:
        minutes = "0" * (6 - len(minutes)) + minutes
    return minutes.replace("1", "●").replace("0", "○")


def seconds_in_binary(seconds):
    return minutes_in_binary(seconds)


t = datetime.datetime.now()
fun = [hours_in_binary, minutes_in_binary, seconds_in_binary]
time = [t.hour, t.minute, t.second]
if __name__ == "__main__":
    args = int(sys.argv[1])
    print(fun[args](time[args]))
