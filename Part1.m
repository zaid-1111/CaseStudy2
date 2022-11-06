clear;
close all;
SIRD=[0.95,0.04,0,0;0.05,0.85,0,0;0,0.1,1,0;0,0.01,0,1];
SampleA=[1000;0;0;0];
stepNumber=500;
graphMatrixA=[1000;0;0;0];
for t=1:stepNumber
    SampleA= SIRD*SampleA;
    graphMatrixA= cat(2,graphMatrixA,SampleA);
end
plot(graphMatrixA.')
SIRD(3,3)=0.995;
SIRD(1,3)=0.005;
title("Matrix A")
graphMatrixB=[1000;0;0;0];
SampleB=[1000;0;0;0];
stepNumber=5000;
for t=1:stepNumber
    SampleB= SIRD*SampleB;
    graphMatrixB= cat(2,graphMatrixB,SampleB);
end
figure()
plot(graphMatrixB.')
legend('S','I','R','D')
title("Matrix B")