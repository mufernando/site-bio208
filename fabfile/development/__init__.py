# -*- coding:utf-8 -*-

from fabric.api import local


def freeze(site):
    ''' Creates static html files '''
    local('python site.py build {}'.format(site))

def build(site=''):
    freeze(site)

def run():
    local('python site.py')
