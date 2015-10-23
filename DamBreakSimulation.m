
clear;
clf;
close all;
addpath('DamBreak/');
h = 0.04;
numFluidParticlesPerRow = 20;
numFluidParticlesPerColumn = 20;

DamBreak(numFluidParticlesPerRow, numFluidParticlesPerColumn, h);