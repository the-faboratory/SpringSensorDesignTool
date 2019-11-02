close all
clear all

dRod = 0.004;%meters, diameter of the rod inside the spring
L0_eff = 0.02381; %m, The amount of L0 that is actually available for deformation
d = 0.0016; %d, meters
D = 0.01247-d; %OD, meters
material = 1; %convert the categorical material into the format needed for the materialPropertySelector function
[E,G,~,~,~,~,error] = materialPropertySelector(material,d); %Pa, spring modulus of rigidity
Na = 6;%active coils, based on spring constant for linear compression spring
k = d^4 * G*1000000 / (8 * D^3 * Na);%k, N/m
kappa = d^4 * G*1000000 / (32 * D * Na); %a special parameter for the constants in eq. 13 of Keller & Gordon IMECE 2010 (Stress Approximation Technique for ... Springs...)

lateralGap = (D - dRod)/2; %m, ideal gap between spring and rod
endGap = 0.0018; %m, the gap between the end of the rod and the end of the spring

angles = [0:10:90]; %[deg] angle from horizontal. So 0 is the side of sensor. 

%find the initial value for F
%find radius of curvature
syms rho
outRho = solve(lateralGap == rho * (1 - cos(L0_eff/rho)),rho);
rho = double(outRho);
%find moment arm
theta = L0_eff/rho;
Lm = 2*rho*sin(theta/2)*sin((pi- theta)/2);
T = kappa * L0_eff / rho; %Nm
F_min = min([k * endGap,T/Lm]);
F_max = max([k * endGap,T/Lm]);
F_increment = (F_max - F_min)/100;

%preallocate variables for speed
F_contact = double(zeros(size(angles)));
F_axial = zeros(size(angles));
F_tangential = zeros(size(angles));
delta_axial = zeros(size(angles));
delta_tangential = zeros(size(angles));

%use bisection method for converging on F_contact
for i=1:length(angles)
    F_a = F_max;
    F_b = F_min;
    while true
        F_contact(i) = (F_a + F_b)/2;
        F_axial(i) = F_contact(i) * sin(angles(i)*pi/180);
        F_tangential(i) = F_contact(i) * cos(angles(i)*pi/180);
        delta_axial(i) = F_axial(i)/k;
        T(i) = F_tangential(i)*(L0_eff-delta_axial(i));
        delta_tangential(i) = abs(kappa*L0_eff *(1-cos(T(i)/kappa))/T(i));
        remainderAxial = endGap - delta_axial(i);
        remainderTangential = lateralGap - delta_tangential(i);
        %stop bisection search if the calculated gap is close enough
        if (abs(remainderAxial) < 0.00005 || abs(remainderTangential) < 0.00005)
            break;
        end
        if remainderAxial < 0 || remainderTangential < 0
            F_a = F_contact(i);
        else
            F_b = F_contact(i);
        end
        
    end
end


% STIFFER THICKER SPRING 10/26/19

data = [0	10	20	30	40	50	60	70	80	90;
3.8	4.8	4.5	4.7	4.4	7.2	7.1	14.6	15.5	13.15;
3.9	4.2	4.2	5.4	4.7	7.4	8	14.58	16.2	15;
4	5	4.7	4.1	6.3	8	9	13.4	14.86	12.5;
3.3	3.4	5	5	5.2	6.2	8.6	12.63	14.8	13.8];

%plot experimental data confidence bars 
errorbar(data(1,:),mean(data(2:end,:),1),std(data(2:end,:),1), 'lineWidth', 2, 'Color', [0 0 0]);
hold on; plot(data(1,:),mean(data(2:end,:),1), 'ko'); 
%plot theoretical values
plot(angles,F_contact)
ylabel('Force to trigger (N)'); 
xlabel('Angle of contact (deg)')

ax = gca; ax.FontSize = 20; 
set(gca,'fontname','arial')
ax.LineWidth = 1.5; 
box(ax,'on')