clear all
close all
clc


load('simulationM.mat')

s = rng;
temp = randperm(400);
stage1_index = temp(1:80);
temp1 = randperm(200);
stage2_index1 = temp1(1:80);
temp2 = randperm(190);
stage2_index2 = temp2(1:80);
temp3 = randperm(100);
stage3_index1 = temp3(1:80);
temp4 = randperm(100);
stage3_index2 = temp4(1:80);
temp5 = randperm(92);
stage3_index3 = temp5(1:80);
temp6 = randperm(100);
stage3_index4 = temp6(1:80);

stagedata = simulation.data;
numberL = simulation.numberL;

stage1 = stagedata(numberL == 1,:);
stage1 = stage1(stage1_index,:);
temp_numberL1 = ones(size(stage1,1),1);

stage2_1 = stagedata(numberL == 2,:);
stage2_1 = stage2_1(stage2_index1,:);
temp_numberL2 = 2*ones(size(stage2_1,1),1);

stage2_2 = stagedata(numberL == 3,:);
stage2_2 = stage2_2(stage2_index2,:);
temp_numberL3 = 3*ones(size(stage2_2,1),1);

stage3_1 = stagedata(numberL == 4,:);
stage3_1 = stage3_1(stage3_index1,:);
temp_numberL4 = 4*ones(size(stage3_1,1),1);

stage3_2 = stagedata(numberL == 5,:);
stage3_2 = stage3_2(stage3_index2,:);
temp_numberL5 = 5*ones(size(stage3_2,1),1);

stage3_3 = stagedata(numberL == 6,:);
stage3_3 = stage3_3(stage3_index3,:);
temp_numberL6 = 6*ones(size(stage3_3,1),1);

stage3_4 = stagedata(numberL == 7,:);
stage3_4 = stage3_4(stage3_index4,:);
temp_numberL7 = 7*ones(size(stage3_4,1),1);

data = [stage1;stage2_1;stage2_2;stage3_1;stage3_2;stage3_3;stage3_4];
numberL = [temp_numberL1;temp_numberL2;temp_numberL3;temp_numberL4;temp_numberL5;temp_numberL6;temp_numberL7];

% temp = randperm(560);
% temp = temp(1:500);
% data = data(temp,:);
% numberL = numberL(temp);
% temp = [23:54 468:490 517:534];
% data = data(temp,:);
% numberL = numberL(temp);

save('simulation_2017.mat','data','numberL')


