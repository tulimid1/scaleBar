%% Using scaleBar

clear;
clc;
close all;
cd('/Users/duncan/Documents/GitHub/scaleBar');

%% Add scale bar without any args

figure();
x = linspace(0, 2*pi, 1e3);
y = sin(x);
plot(x, y);
scaleBar(); 

%% Define value precision 

figure();
x = linspace(0, 2*pi, 1e3);
y = sin(x);
plot(x, y);
scaleBar('numDecimals', 3); 

%% Just x bar 
figure();
x = linspace(0, 2*pi, 1e3);
y = sin(x);
plot(x, y);
scaleBar('xBarOnly', true); 

%% Just y bar 
figure();
x = linspace(0, 2*pi, 1e3);
y = sin(x);
plot(x, y);
scaleBar('yBarOnly', true); 

%% Move to new location 
figure();
x = linspace(0, 2*pi, 1e3);
y = sin(x);
plot(x, y);
scaleBar('barOrigin', [1 -0.2]); 

%% Different figure
x = linspace(0, 2*pi, 1e3);
y = cos(x);

figure();
plot(x, y);
scaleBar(); 

figure();
plot(x, y);
scaleBar('xBarOnly', true); 

figure();
plot(x, y);
scaleBar('yBarOnly', true); 

figure();
plot(x, y);
scaleBar('barOrigin', [pi -0.2]); 

%% Different magnitude 
x = linspace(0, 2*pi, 1e3);
y = cos(x)*5;

figure();
plot(x, y);
scaleBar(); 

figure();
plot(x, y);
scaleBar('xBarOnly', true); 

figure();
plot(x, y);
scaleBar('yBarOnly', true); 

figure();
plot(x, y);
scaleBar('barOrigin', [pi -0.2]); 