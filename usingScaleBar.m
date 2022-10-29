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
auto_save('ex1a'); 

%% Define value precision 

figure();
x = linspace(0, 2*pi, 1e3);
y = sin(x);
plot(x, y);
scaleBar('numDecimals', 3); 
auto_save('ex2a'); 

%% Just x bar 
figure();
x = linspace(0, 2*pi, 1e3);
y = sin(x);
plot(x, y);
scaleBar('xBarOnly', true); 
auto_save('ex3a'); 

%% Just y bar 
figure();
x = linspace(0, 2*pi, 1e3);
y = sin(x);
plot(x, y);
scaleBar('yBarOnly', true); 
auto_save('ex4a'); 

%% Move to new location 
figure();
x = linspace(0, 2*pi, 1e3);
y = sin(x);
plot(x, y);
scaleBar('barOrigin', [1 -0.2]); 
auto_save('ex5a'); 

%% Different figure
x = linspace(0, 2*pi, 1e3);
y = cos(x);

figure();
plot(x, y);
scaleBar(); 
auto_save('ex1b'); 

figure();
plot(x, y);
scaleBar('xBarOnly', true); 
auto_save('ex3b'); 

figure();
plot(x, y);
scaleBar('yBarOnly', true); 
auto_save('ex4b'); 

figure();
plot(x, y);
scaleBar('barOrigin', [pi -0.2]); 
auto_save('ex5b'); 

%% Different magnitude 
x = linspace(0, 2*pi, 1e3);
y = cos(x)*5;

figure();
plot(x, y);
scaleBar(); 
auto_save('ex1c'); 

figure();
plot(x, y);
scaleBar('xBarOnly', true); 
auto_save('ex3c'); 

figure();
plot(x, y);
scaleBar('yBarOnly', true); 
auto_save('ex4c'); 

figure();
plot(x, y);
scaleBar('barOrigin', [pi -0.2]); 
auto_save('ex5c'); 
