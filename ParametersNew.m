%% Preamble
% Program: ParametersNew
% Author: Jonathan Myers (Modified From S. Tay et al. 2010 Nature)
% Date: July 10th, 2019
% Purpose: To make the Tay MATLAB Parameters function more streamlined and
% easier to understand and modify.
% Arguments: None.
% Calls: None.
% Returns: Many Reaction Parameters.

%% ParametersNew
function [NF0,NF1,NF2,M0,M1,M2,k4,ka20,AB,kv,q1,q2,c1,c3,c4,c5,k1,k2,...
    k3,a1,a2,a3,c1a,c5a,c6a,i1,i1a,e1a,e2a,dt,tp,KN,KNN,ka,ki,kb,kf,Tdeg,...
    q1r,q2r,q2rr,c1r,c1rr,c3r]=ParametersNew
%% Numerical Simulation Parameters
dt=10;           %Simulation Step Size For Numerical Simulation of ODE.

%% Cell Properties Paramters
kv=5;        %Ratio of volumes between cytoplasm and nucleus. 
KN=10^5;         %default 10^5 - total number of IKKK kinase molecules, Assumption
KNN=2*10^5;      %default 2*10^5 - total number of IKK kinase molecules, Assumption
ka=2*10^-5;      %default 2*10^-5 - IKKK kinase activation rate (at most 1/s), Assumption                       
ki=0.01;         %default 0.01 - IKKK kinase inactivation rate, Assumption

%% Initial Randomly Varied Parameters
% M0=2000 mean number of TNFR1 receptors assumed for 3T3 cells (our experiment)
% Assumed M0=10000 for MEFS, M0=5000 for SK-N-AS, M0=500 for HeLa to acount
% for different cell sensitivities
M0=5000;  
M1=sqrt(2); % Standard Deviation of the natural log of the Random Variable 
M2=-1; % Mean of the natural log of the Random Variable 

% Lognormal distribution with Median=M0*Exp(M2), Mean=M0*Exp(M2+M1^2/2)=M0
% Variance = M0^2 * (Exp (M1^2 -1) * Exp(2*M2+M1^2)

% NF0 is the mean NF-kB quantity at the cellular level
NF0=10^5;
NF1=1/sqrt(2); % Standard Deviation of the natural log of the Random Variable 
NF2=-1/4; % Mean of the natural log of the Random Variable

% Lognormal distribution with Median=NF0*Exp(NF2), Mean=NF0*Exp(NF2+NF1^2/2)=NF0
% Variance = NF0^2 * (Exp (NF1^2 -1) * Exp(2*NF2+NF1^2)

%% Stochastic Reaction Parameters
kb=1.2*10^-5;       %default 1.2*10^-5 - TNF receptor activation rate           
kf=1.2*10^-3;       %default 1.2*10^-3 - TNF receptor inactivation rate

q1=4*10^-7;    %default 4*10^-7 - NF-kB ataching at A20 and IkBa site                               
q2=10^-6;      %default 10^-6 - IkBa inducible detaching from A20 and IkBa site

%% Determinisitic Reaction Parameters
% TNF loss, 2*10^-4  for 10ng (t1/2=60min), 7*10^-4  for 1ng, 
% 7.7*10^-4 for 0.1ng, 8.3*10^-4 for 0.01ng, 
% use 2*10^-4 for experiments in other than microfluidics
Tdeg=7.7*10^-4; 

% A20
AB=1;            %A20 on (or off)
c0=0.1;          %default 0.1 - inducible A20 and IkBa mRNA synthesis, Assumption 
c1=AB*c0;        %inducible A20 mRNA synthesis 
c3=0.00075;      %default 0.00075 - A20 and IkBa mRNA degradation rate
c4=0.5;          %default 0.5 - A20 and IkBa translation rate, FIT
c5=0.0005;       %default 0.0005 - A20 degradation rate, FIT
ka20=10^5;       %default 10^5 - A20 TNFR1 block, FIT    

% IkBa
AA=1;            %IkBa on (or off)
c1a=AA*c0;       %inducible IkBa mRNA synthesis 
a1=5*10^-7;      %default 5*10^-7 - IkBa*NFkB association, Assumption
a2=10^-7;        %default 10^-7 - IkBa phosphoryation due to action of IKKa, FIT
a3=5*10^-7;      %default 5*10^-7 - (IkBa|NFkb) phosphorylation due to action of IKKa,  FIT
tp=0.01;         %default 0.01 - degradation of single and NF-kB complexed phospho-IkBa, FIT  
c5a=0.0001;      %default 0.0001 - IkBa degradation rate
c6a=0.00002;     %default 0.00002 - spontaneous (IkBa|NFkB) degradation of IkBa

% IKK
k2=10000;        %default 10000 - IKKa inactivation caused by A20, FIT                                    
k1=6*10^-10;     %default 6*10^-10; IKKn activation caused by active IKKK, Assumption     
k3=0.002;        %default 0.002 - IKKa inactivation, FIT                                                    
k4=0.001;        %default 0.001 - IKKii transformation, FIT 

% Reporter Gene
q1r=1*10^-7;      %default 1*10^-7 NF-kB ataching at reporter gene site
q2r=1*10^-7;      %default 1*10^-7 inducible NF-kB detaching from reporter gene site
q2rr=1*10^-3;     %default 1*10^-3 spontaneous NF-kB detaching from reporter gene site

% Reporter mRNA
c1r=0.05;         %default 0.05 Reporter gene mRNA inducible synthesis  
c1rr=0.001;       %default 0.001 Reporter gene mRNA constitutive synthesis  
c3r=0.001;        %various considered,  Reporter mRNA degradation rate 

% Transport
i1=0.01;         %default 0.01 - NFkB nuclear import, FIT 
e2a=0.05;        %default 0.05 - (IkBa|NFkB) nuclear export, FIT 
i1a=0.002;       %default 0.002 - IkBa nuclear import, FIT
e1a=0.005;       %default 0.005 - IkBa nuclear export, FIT 