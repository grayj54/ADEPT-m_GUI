function [Vmp]=a_findMP(dev,V1,V2)
global mpdev

mpdev=dev;

Vmp=fminbnd(@(V) a_power(V),V1,V2,optimset('display','off'));
