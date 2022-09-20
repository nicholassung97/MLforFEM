clear vars; close all; clc;

a = readtable('file1.txt');
b = readtable('file2.txt');
c = readtable('file3.txt');
d = readtable('displacement.txt');
e = readtable('Finestress.txt');

%Material Properties
E = 10E6;
nu = 0.3;
s = 1;

%training data
data = [a.par1 b.par2 c.par3 d.u1./1e-06]';

%target data
rlt = e.target;
eu = [rlt']';
eu = eu';


%setting parameters for training
net = fitnet(2, 'trainbr');
net.layers{1}.transferFcn = 'purelin';
net.trainParam.showWindow = false;

%training the neural network
rerra = 0;

for i1=1:1:300
    [net,tr] = train(net,data,eu); 
    y = net(data);                  
    euPred = net(data(:,tr.testInd)); 
    euPredval = net(data(:,tr.valInd));
    euPredtrain = net(data(:,tr.trainInd));
    euErr = ((euPred - eu(:,tr.testInd))./eu(:,tr.testInd))*100;
    err = euErr.^2;
    rerr = mean(err);
    rerr = sqrt(rerr);
      
    if rerr>rerra;
        rerra = rerr;
        
       
    end
end
 
rerra



