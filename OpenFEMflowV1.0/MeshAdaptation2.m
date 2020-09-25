function [nodes2, element2, U2] = MeshAdaptation2(nodes,element,U,ep)

global CFL

nElm1 = size(element,1);
element2 = element;
nodes2 = nodes;
nNode = size(nodes,1);
U2 = U;
Err = [];
eErr = [];

% element error
for i = 1:nElm1
    x1 = nodes(element(i,1),1); x2 = nodes(element(i,2),1); x3 = nodes(element(i,3),1);
    y1 = nodes(element(i,1),2); y2 = nodes(element(i,2),2); y3 = nodes(element(i,3),2);
    
    Ue = [U(4*(element(i,1)-1)+1:4*(element(i,1)-1)+4); U(4*(element(i,2)-1)+1:4*(element(i,2)-1)+4); ...
          U(4*(element(i,3)-1)+1:4*(element(i,3)-1)+4)];
    
    r1 = Ue(1); r2 = Ue(5); r3 = Ue(9);
    u1 = Ue(2); u2 = Ue(6); u3 = Ue(10);
    v1 = Ue(3); v2 = Ue(7); v3 = Ue(11);
    p1 = Ue(4); p2 = Ue(8); p3 = Ue(12);
    
    x = (x1+x2+x3)/3;
    y = (y1+y2+y3)/3;
    
    S1 = (x2*y3 - x3*y2)/(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2) - (y*(x2 - x3))/(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2) + (x*(y2 - y3))/(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2);
    S2 = (y*(x1 - x3))/(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2) - (x1*y3 - x3*y1)/(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2) - (x*(y1 - y3))/(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2);
    S3 = (x1*y2 - x2*y1)/(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2) - (y*(x1 - x2))/(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2) + (x*(y1 - y2))/(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2);

    u = u1*S1 + u2*S2 + u3*S3;
    v = v1*S1 + v2*S2 + v3*S3;
    p = p1*S1 + p2*S2 + p3*S3;
    r = r1*S1 + r2*S2 + r3*S3;
    
%     l1 = sqrt((x1-x2)^2+(y1-y2)^2);
%     l2 = sqrt((x3-x2)^2+(y3-y2)^2);
%     l3 = sqrt((x1-x3)^2+(y1-y3)^2);
%     L = min([l1 l2 l3]);
%     dt =CFL*L;%/sqrt(V^2+a^2);

    Err(i) = r3*((r3*(u^2*y1^2 + v^2*x1^2 + u^2*y2^2 + v^2*x2^2 - 2*v^2*x1*x2 - 2*u^2*y1*y2 - 2*u*v*x1*y1 + 2*u*v*x1*y2 + 2*u*v*x2*y1 - 2*u*v*x2*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r2*(u*y1 - v*x1 - u*y2 + v*x2)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r1*(u*y1 - v*x1 - u*y2 + v*x2)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*v1*(x2 - x3)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*v2*(x1 - x3)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*v3*(x1 - x2)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*u1*(y2 - y3)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*u2*(y1 - y3)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*u3*(y1 - y2)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - p1*((p2*((u^2*y3^2 + v^2*x3^2 + v^2*x1*x2 - v^2*x1*x3 - v^2*x2*x3 + u^2*y1*y2 - u^2*y1*y3 - u^2*y2*y3 - u*v*x1*y2 - u*v*x2*y1 + u*v*x1*y3 + u*v*x3*y1 + u*v*x2*y3 + u*v*x3*y2 - 2*u*v*x3*y3)/(2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (x1*x2 - x1*x3 - x2*x3 + y1*y2 - y1*y3 - y2*y3 + x3^2 + y3^2)/(2*r^2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))))/((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3)) + (p3*((u^2*y2^2 + v^2*x2^2 - v^2*x1*x2 + v^2*x1*x3 - v^2*x2*x3 - u^2*y1*y2 + u^2*y1*y3 - u^2*y2*y3 + u*v*x1*y2 + u*v*x2*y1 - u*v*x1*y3 - 2*u*v*x2*y2 - u*v*x3*y1 + u*v*x2*y3 + u*v*x3*y2)/(2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (x1*x2 - x1*x3 + x2*x3 + y1*y2 - y1*y3 + y2*y3 - x2^2 - y2^2)/(2*r^2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))))/((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3)) + (v3*(5*v*x2^2 + 5*u*x2*y1 - 5*v*x1*x2 - 5*u*x2*y2 - 5*u*x3*y1 + 5*v*x1*x3 + 5*u*x3*y2 - 5*v*x2*x3 + 7*p*r*v*x2^2 + 7*p*r*u*x1*y2 - 7*p*r*v*x1*x2 - 7*p*r*u*x1*y3 - 7*p*r*u*x2*y2 + 7*p*r*v*x1*x3 + 7*p*r*u*x2*y3 - 7*p*r*v*x2*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (v2*(5*v*x3^2 - 5*u*x2*y1 + 5*v*x1*x2 + 5*u*x3*y1 - 5*v*x1*x3 + 5*u*x2*y3 - 5*v*x2*x3 - 5*u*x3*y3 + 7*p*r*v*x3^2 - 7*p*r*u*x1*y2 + 7*p*r*v*x1*x2 + 7*p*r*u*x1*y3 - 7*p*r*v*x1*x3 + 7*p*r*u*x3*y2 - 7*p*r*v*x2*x3 - 7*p*r*u*x3*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u3*(5*u*y2^2 - 5*u*y1*y2 + 5*v*x1*y2 + 5*u*y1*y3 - 5*v*x1*y3 - 5*v*x2*y2 - 5*u*y2*y3 + 5*v*x2*y3 + 7*p*r*u*y2^2 - 7*p*r*u*y1*y2 + 7*p*r*v*x2*y1 + 7*p*r*u*y1*y3 - 7*p*r*v*x2*y2 - 7*p*r*v*x3*y1 - 7*p*r*u*y2*y3 + 7*p*r*v*x3*y2))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u2*(5*u*y3^2 + 5*u*y1*y2 - 5*v*x1*y2 - 5*u*y1*y3 + 5*v*x1*y3 - 5*u*y2*y3 + 5*v*x3*y2 - 5*v*x3*y3 + 7*p*r*u*y3^2 + 7*p*r*u*y1*y2 - 7*p*r*v*x2*y1 - 7*p*r*u*y1*y3 + 7*p*r*v*x3*y1 - 7*p*r*u*y2*y3 + 7*p*r*v*x2*y3 - 7*p*r*v*x3*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (p1*(x2^2 - 2*y2*y3 - 2*x2*x3 + x3^2 + y2^2 + y3^2 + r^2*u^2*y2^2 + r^2*v^2*x2^2 + r^2*u^2*y3^2 + r^2*v^2*x3^2 - 2*r^2*v^2*x2*x3 - 2*r^2*u^2*y2*y3 - 2*r^2*u*v*x2*y2 + 2*r^2*u*v*x2*y3 + 2*r^2*u*v*x3*y2 - 2*r^2*u*v*x3*y3))/(2*r^2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (v1*(7*p*r + 5)*(x2 - x3)*(u*y2 - v*x2 - u*y3 + v*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (u1*(7*p*r + 5)*(y2 - y3)*(u*y2 - v*x2 - u*y3 + v*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - r2*((r1*(u^2*y3^2 + v^2*x3^2 + v^2*x1*x2 - v^2*x1*x3 - v^2*x2*x3 + u^2*y1*y2 - u^2*y1*y3 - u^2*y2*y3 - u*v*x1*y2 - u*v*x2*y1 + u*v*x1*y3 + u*v*x3*y1 + u*v*x2*y3 + u*v*x3*y2 - 2*u*v*x3*y3))/(((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(2*x1*y2 - 2*x2*y1 - 2*x1*y3 + 2*x3*y1 + 2*x2*y3 - 2*x3*y2)) - (r2*(u^2*y1^2 + v^2*x1^2 + u^2*y3^2 + v^2*x3^2 - 2*v^2*x1*x3 - 2*u^2*y1*y3 - 2*u*v*x1*y1 + 2*u*v*x1*y3 + 2*u*v*x3*y1 - 2*u*v*x3*y3))/(((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(2*x1*y2 - 2*x2*y1 - 2*x1*y3 + 2*x3*y1 + 2*x2*y3 - 2*x3*y2)) + (v3*(r*v*x1^2 - r*u*x1*y1 + r*u*x2*y1 - r*v*x1*x2 + r*u*x1*y3 - r*v*x1*x3 - r*u*x2*y3 + r*v*x2*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u3*(r*u*y1^2 - r*v*x1*y1 - r*u*y1*y2 + r*v*x1*y2 - r*u*y1*y3 + r*v*x3*y1 + r*u*y2*y3 - r*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r3*(u*y1 - v*x1 - u*y2 + v*x2)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*v1*(x2 - x3)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*v2*(x1 - x3)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*u1*(y2 - y3)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*u2*(y1 - y3)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - r1*((r2*(u^2*y3^2 + v^2*x3^2 + v^2*x1*x2 - v^2*x1*x3 - v^2*x2*x3 + u^2*y1*y2 - u^2*y1*y3 - u^2*y2*y3 - u*v*x1*y2 - u*v*x2*y1 + u*v*x1*y3 + u*v*x3*y1 + u*v*x2*y3 + u*v*x3*y2 - 2*u*v*x3*y3))/(((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(2*x1*y2 - 2*x2*y1 - 2*x1*y3 + 2*x3*y1 + 2*x2*y3 - 2*x3*y2)) - (r1*(u^2*y2^2 + v^2*x2^2 + u^2*y3^2 + v^2*x3^2 - 2*v^2*x2*x3 - 2*u^2*y2*y3 - 2*u*v*x2*y2 + 2*u*v*x2*y3 + 2*u*v*x3*y2 - 2*u*v*x3*y3))/(((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(2*x1*y2 - 2*x2*y1 - 2*x1*y3 + 2*x3*y1 + 2*x2*y3 - 2*x3*y2)) + (v3*(r*v*x2^2 + r*u*x1*y2 - r*v*x1*x2 - r*u*x1*y3 - r*u*x2*y2 + r*v*x1*x3 + r*u*x2*y3 - r*v*x2*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u3*(r*u*y2^2 - r*u*y1*y2 + r*v*x2*y1 + r*u*y1*y3 - r*v*x2*y2 - r*v*x3*y1 - r*u*y2*y3 + r*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r3*(u*y1 - v*x1 - u*y2 + v*x2)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*v1*(x2 - x3)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*v2*(x1 - x3)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*u1*(y2 - y3)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*u2*(y1 - y3)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - v2*((v3*(49*p^2*x1^2 + 25*r^2*x1^2 + 25*u^2*y1^2 + 25*v^2*x1^2 - 49*p^2*x1*x2 - 49*p^2*x1*x3 + 49*p^2*x2*x3 - 25*r^2*x1*x2 - 25*r^2*x1*x3 + 25*r^2*x2*x3 - 25*v^2*x1*x2 - 25*v^2*x1*x3 + 25*v^2*x2*x3 - 25*u^2*y1*y2 - 25*u^2*y1*y3 + 25*u^2*y2*y3 - 50*u*v*x1*y1 + 25*u*v*x1*y2 + 25*u*v*x2*y1 + 25*u*v*x1*y3 + 25*u*v*x3*y1 - 25*u*v*x2*y3 - 25*u*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) - (u3*(49*p^2*x1*y1 - 49*p^2*x1*y2 - 49*p^2*x3*y1 + 49*p^2*x3*y2 + 25*r^2*x1*y1 - 25*r^2*x1*y2 - 25*r^2*x3*y1 + 25*r^2*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (v1*(49*p^2*x3^2 + 25*r^2*x3^2 + 25*u^2*y3^2 + 25*v^2*x3^2 + 49*p^2*x1*x2 - 49*p^2*x1*x3 - 49*p^2*x2*x3 + 25*r^2*x1*x2 - 25*r^2*x1*x3 - 25*r^2*x2*x3 + 25*v^2*x1*x2 - 25*v^2*x1*x3 - 25*v^2*x2*x3 + 25*u^2*y1*y2 - 25*u^2*y1*y3 - 25*u^2*y2*y3 - 25*u*v*x1*y2 - 25*u*v*x2*y1 + 25*u*v*x1*y3 + 25*u*v*x3*y1 + 25*u*v*x2*y3 + 25*u*v*x3*y2 - 50*u*v*x3*y3))/(((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(50*x1*y2 - 50*x2*y1 - 50*x1*y3 + 50*x3*y1 + 50*x2*y3 - 50*x3*y2)) - (v2*(49*p^2*x1^2 + 49*p^2*x3^2 + 25*r^2*x1^2 + 25*r^2*x3^2 + 25*u^2*y1^2 + 25*v^2*x1^2 + 25*u^2*y3^2 + 25*v^2*x3^2 - 98*p^2*x1*x3 - 50*r^2*x1*x3 - 50*v^2*x1*x3 - 50*u^2*y1*y3 - 50*u*v*x1*y1 + 50*u*v*x1*y3 + 50*u*v*x3*y1 - 50*u*v*x3*y3))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p3*(5*v*x1^2 - 5*u*x1*y1 + 5*u*x2*y1 - 5*v*x1*x2 + 5*u*x1*y3 - 5*v*x1*x3 - 5*u*x2*y3 + 5*v*x2*x3 + 7*p*r*v*x1^2 - 7*p*r*u*x1*y1 + 7*p*r*u*x1*y2 - 7*p*r*v*x1*x2 + 7*p*r*u*x3*y1 - 7*p*r*v*x1*x3 - 7*p*r*u*x3*y2 + 7*p*r*v*x2*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p1*(5*v*x3^2 - 5*u*x2*y1 + 5*v*x1*x2 + 5*u*x3*y1 - 5*v*x1*x3 + 5*u*x2*y3 - 5*v*x2*x3 - 5*u*x3*y3 + 7*p*r*v*x3^2 - 7*p*r*u*x1*y2 + 7*p*r*v*x1*x2 + 7*p*r*u*x1*y3 - 7*p*r*v*x1*x3 + 7*p*r*u*x3*y2 - 7*p*r*v*x2*x3 - 7*p*r*u*x3*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*r3*(x1 - x3)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*r2*(x1 - x3)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*r1*(x1 - x3)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (u1*(x1 - x3)*(y2 - y3)*(49*p^2 + 25*r^2))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u2*(x1 - x3)*(y1 - y3)*(49*p^2 + 25*r^2))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p2*(7*p*r + 5)*(x1 - x3)*(u*y1 - v*x1 - u*y3 + v*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - v1*((u3*(49*p^2*x2*y1 - 49*p^2*x2*y2 - 49*p^2*x3*y1 + 49*p^2*x3*y2 + 25*r^2*x2*y1 - 25*r^2*x2*y2 - 25*r^2*x3*y1 + 25*r^2*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (v3*(49*p^2*x2^2 + 25*r^2*x2^2 + 25*u^2*y2^2 + 25*v^2*x2^2 - 49*p^2*x1*x2 + 49*p^2*x1*x3 - 49*p^2*x2*x3 - 25*r^2*x1*x2 + 25*r^2*x1*x3 - 25*r^2*x2*x3 - 25*v^2*x1*x2 + 25*v^2*x1*x3 - 25*v^2*x2*x3 - 25*u^2*y1*y2 + 25*u^2*y1*y3 - 25*u^2*y2*y3 + 25*u*v*x1*y2 + 25*u*v*x2*y1 - 25*u*v*x1*y3 - 50*u*v*x2*y2 - 25*u*v*x3*y1 + 25*u*v*x2*y3 + 25*u*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (v2*(49*p^2*x3^2 + 25*r^2*x3^2 + 25*u^2*y3^2 + 25*v^2*x3^2 + 49*p^2*x1*x2 - 49*p^2*x1*x3 - 49*p^2*x2*x3 + 25*r^2*x1*x2 - 25*r^2*x1*x3 - 25*r^2*x2*x3 + 25*v^2*x1*x2 - 25*v^2*x1*x3 - 25*v^2*x2*x3 + 25*u^2*y1*y2 - 25*u^2*y1*y3 - 25*u^2*y2*y3 - 25*u*v*x1*y2 - 25*u*v*x2*y1 + 25*u*v*x1*y3 + 25*u*v*x3*y1 + 25*u*v*x2*y3 + 25*u*v*x3*y2 - 50*u*v*x3*y3))/(((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(50*x1*y2 - 50*x2*y1 - 50*x1*y3 + 50*x3*y1 + 50*x2*y3 - 50*x3*y2)) - (v1*(49*p^2*x2^2 + 49*p^2*x3^2 + 25*r^2*x2^2 + 25*r^2*x3^2 + 25*u^2*y2^2 + 25*v^2*x2^2 + 25*u^2*y3^2 + 25*v^2*x3^2 - 98*p^2*x2*x3 - 50*r^2*x2*x3 - 50*v^2*x2*x3 - 50*u^2*y2*y3 - 50*u*v*x2*y2 + 50*u*v*x2*y3 + 50*u*v*x3*y2 - 50*u*v*x3*y3))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p3*(5*v*x2^2 + 5*u*x1*y2 - 5*v*x1*x2 - 5*u*x1*y3 - 5*u*x2*y2 + 5*v*x1*x3 + 5*u*x2*y3 - 5*v*x2*x3 + 7*p*r*v*x2^2 + 7*p*r*u*x2*y1 - 7*p*r*v*x1*x2 - 7*p*r*u*x2*y2 - 7*p*r*u*x3*y1 + 7*p*r*v*x1*x3 + 7*p*r*u*x3*y2 - 7*p*r*v*x2*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p2*(5*v*x3^2 - 5*u*x1*y2 + 5*v*x1*x2 + 5*u*x1*y3 - 5*v*x1*x3 + 5*u*x3*y2 - 5*v*x2*x3 - 5*u*x3*y3 + 7*p*r*v*x3^2 - 7*p*r*u*x2*y1 + 7*p*r*v*x1*x2 + 7*p*r*u*x3*y1 - 7*p*r*v*x1*x3 + 7*p*r*u*x2*y3 - 7*p*r*v*x2*x3 - 7*p*r*u*x3*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*r3*(x2 - x3)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*r2*(x2 - x3)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*r1*(x2 - x3)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u1*(x2 - x3)*(y2 - y3)*(49*p^2 + 25*r^2))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (u2*(x2 - x3)*(y1 - y3)*(49*p^2 + 25*r^2))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p1*(7*p*r + 5)*(x2 - x3)*(u*y2 - v*x2 - u*y3 + v*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - v3*((u3*(49*p^2*x1*y1 - 49*p^2*x1*y2 - 49*p^2*x2*y1 + 49*p^2*x2*y2 + 25*r^2*x1*y1 - 25*r^2*x1*y2 - 25*r^2*x2*y1 + 25*r^2*x2*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) - (u2*(49*p^2*x1*y1 - 49*p^2*x2*y1 - 49*p^2*x1*y3 + 49*p^2*x2*y3 + 25*r^2*x1*y1 - 25*r^2*x2*y1 - 25*r^2*x1*y3 + 25*r^2*x2*y3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (u1*(49*p^2*x1*y2 - 49*p^2*x1*y3 - 49*p^2*x2*y2 + 49*p^2*x2*y3 + 25*r^2*x1*y2 - 25*r^2*x1*y3 - 25*r^2*x2*y2 + 25*r^2*x2*y3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (v2*(49*p^2*x1^2 + 25*r^2*x1^2 + 25*u^2*y1^2 + 25*v^2*x1^2 - 49*p^2*x1*x2 - 49*p^2*x1*x3 + 49*p^2*x2*x3 - 25*r^2*x1*x2 - 25*r^2*x1*x3 + 25*r^2*x2*x3 - 25*v^2*x1*x2 - 25*v^2*x1*x3 + 25*v^2*x2*x3 - 25*u^2*y1*y2 - 25*u^2*y1*y3 + 25*u^2*y2*y3 - 50*u*v*x1*y1 + 25*u*v*x1*y2 + 25*u*v*x2*y1 + 25*u*v*x1*y3 + 25*u*v*x3*y1 - 25*u*v*x2*y3 - 25*u*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (v1*(49*p^2*x2^2 + 25*r^2*x2^2 + 25*u^2*y2^2 + 25*v^2*x2^2 - 49*p^2*x1*x2 + 49*p^2*x1*x3 - 49*p^2*x2*x3 - 25*r^2*x1*x2 + 25*r^2*x1*x3 - 25*r^2*x2*x3 - 25*v^2*x1*x2 + 25*v^2*x1*x3 - 25*v^2*x2*x3 - 25*u^2*y1*y2 + 25*u^2*y1*y3 - 25*u^2*y2*y3 + 25*u*v*x1*y2 + 25*u*v*x2*y1 - 25*u*v*x1*y3 - 50*u*v*x2*y2 - 25*u*v*x3*y1 + 25*u*v*x2*y3 + 25*u*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (r2*(r*v*x1^2 - r*u*x1*y1 + r*u*x2*y1 - r*v*x1*x2 + r*u*x1*y3 - r*v*x1*x3 - r*u*x2*y3 + r*v*x2*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r1*(r*v*x2^2 + r*u*x1*y2 - r*v*x1*x2 - r*u*x1*y3 - r*u*x2*y2 + r*v*x1*x3 + r*u*x2*y3 - r*v*x2*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (v3*(49*p^2*x1^2 + 49*p^2*x2^2 + 25*r^2*x1^2 + 25*r^2*x2^2 + 25*u^2*y1^2 + 25*v^2*x1^2 + 25*u^2*y2^2 + 25*v^2*x2^2 - 98*p^2*x1*x2 - 50*r^2*x1*x2 - 50*v^2*x1*x2 - 50*u^2*y1*y2 - 50*u*v*x1*y1 + 50*u*v*x1*y2 + 50*u*v*x2*y1 - 50*u*v*x2*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (p2*(5*v*x1^2 - 5*u*x1*y1 + 5*u*x1*y2 - 5*v*x1*x2 + 5*u*x3*y1 - 5*v*x1*x3 - 5*u*x3*y2 + 5*v*x2*x3 + 7*p*r*v*x1^2 - 7*p*r*u*x1*y1 + 7*p*r*u*x2*y1 - 7*p*r*v*x1*x2 + 7*p*r*u*x1*y3 - 7*p*r*v*x1*x3 - 7*p*r*u*x2*y3 + 7*p*r*v*x2*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p1*(5*v*x2^2 + 5*u*x2*y1 - 5*v*x1*x2 - 5*u*x2*y2 - 5*u*x3*y1 + 5*v*x1*x3 + 5*u*x3*y2 - 5*v*x2*x3 + 7*p*r*v*x2^2 + 7*p*r*u*x1*y2 - 7*p*r*v*x1*x2 - 7*p*r*u*x1*y3 - 7*p*r*u*x2*y2 + 7*p*r*v*x1*x3 + 7*p*r*u*x2*y3 - 7*p*r*v*x2*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*r3*(x1 - x2)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p3*(7*p*r + 5)*(x1 - x2)*(u*y1 - v*x1 - u*y2 + v*x2))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - u2*((u3*(49*p^2*y1^2 + 25*r^2*y1^2 + 25*u^2*y1^2 + 25*v^2*x1^2 - 49*p^2*y1*y2 - 49*p^2*y1*y3 + 49*p^2*y2*y3 - 25*r^2*y1*y2 - 25*r^2*y1*y3 + 25*r^2*y2*y3 - 25*v^2*x1*x2 - 25*v^2*x1*x3 + 25*v^2*x2*x3 - 25*u^2*y1*y2 - 25*u^2*y1*y3 + 25*u^2*y2*y3 - 50*u*v*x1*y1 + 25*u*v*x1*y2 + 25*u*v*x2*y1 + 25*u*v*x1*y3 + 25*u*v*x3*y1 - 25*u*v*x2*y3 - 25*u*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) - (v3*(49*p^2*x1*y1 - 49*p^2*x2*y1 - 49*p^2*x1*y3 + 49*p^2*x2*y3 + 25*r^2*x1*y1 - 25*r^2*x2*y1 - 25*r^2*x1*y3 + 25*r^2*x2*y3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (u1*(49*p^2*y3^2 + 25*r^2*y3^2 + 25*u^2*y3^2 + 25*v^2*x3^2 + 49*p^2*y1*y2 - 49*p^2*y1*y3 - 49*p^2*y2*y3 + 25*r^2*y1*y2 - 25*r^2*y1*y3 - 25*r^2*y2*y3 + 25*v^2*x1*x2 - 25*v^2*x1*x3 - 25*v^2*x2*x3 + 25*u^2*y1*y2 - 25*u^2*y1*y3 - 25*u^2*y2*y3 - 25*u*v*x1*y2 - 25*u*v*x2*y1 + 25*u*v*x1*y3 + 25*u*v*x3*y1 + 25*u*v*x2*y3 + 25*u*v*x3*y2 - 50*u*v*x3*y3))/(((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(50*x1*y2 - 50*x2*y1 - 50*x1*y3 + 50*x3*y1 + 50*x2*y3 - 50*x3*y2)) - (u2*(49*p^2*y1^2 + 49*p^2*y3^2 + 25*r^2*y1^2 + 25*r^2*y3^2 + 25*u^2*y1^2 + 25*v^2*x1^2 + 25*u^2*y3^2 + 25*v^2*x3^2 - 98*p^2*y1*y3 - 50*r^2*y1*y3 - 50*v^2*x1*x3 - 50*u^2*y1*y3 - 50*u*v*x1*y1 + 50*u*v*x1*y3 + 50*u*v*x3*y1 - 50*u*v*x3*y3))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p3*(5*u*y1^2 - 5*v*x1*y1 - 5*u*y1*y2 + 5*v*x1*y2 - 5*u*y1*y3 + 5*v*x3*y1 + 5*u*y2*y3 - 5*v*x3*y2 + 7*p*r*u*y1^2 - 7*p*r*v*x1*y1 - 7*p*r*u*y1*y2 + 7*p*r*v*x2*y1 - 7*p*r*u*y1*y3 + 7*p*r*v*x1*y3 + 7*p*r*u*y2*y3 - 7*p*r*v*x2*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p1*(5*u*y3^2 + 5*u*y1*y2 - 5*v*x1*y2 - 5*u*y1*y3 + 5*v*x1*y3 - 5*u*y2*y3 + 5*v*x3*y2 - 5*v*x3*y3 + 7*p*r*u*y3^2 + 7*p*r*u*y1*y2 - 7*p*r*v*x2*y1 - 7*p*r*u*y1*y3 + 7*p*r*v*x3*y1 - 7*p*r*u*y2*y3 + 7*p*r*v*x2*y3 - 7*p*r*v*x3*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*r3*(y1 - y3)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*r2*(y1 - y3)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*r1*(y1 - y3)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (v1*(x2 - x3)*(y1 - y3)*(49*p^2 + 25*r^2))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (v2*(x1 - x3)*(y1 - y3)*(49*p^2 + 25*r^2))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (p2*(7*p*r + 5)*(y1 - y3)*(u*y1 - v*x1 - u*y3 + v*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - u1*((v3*(49*p^2*x1*y2 - 49*p^2*x1*y3 - 49*p^2*x2*y2 + 49*p^2*x2*y3 + 25*r^2*x1*y2 - 25*r^2*x1*y3 - 25*r^2*x2*y2 + 25*r^2*x2*y3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (u3*(49*p^2*y2^2 + 25*r^2*y2^2 + 25*u^2*y2^2 + 25*v^2*x2^2 - 49*p^2*y1*y2 + 49*p^2*y1*y3 - 49*p^2*y2*y3 - 25*r^2*y1*y2 + 25*r^2*y1*y3 - 25*r^2*y2*y3 - 25*v^2*x1*x2 + 25*v^2*x1*x3 - 25*v^2*x2*x3 - 25*u^2*y1*y2 + 25*u^2*y1*y3 - 25*u^2*y2*y3 + 25*u*v*x1*y2 + 25*u*v*x2*y1 - 25*u*v*x1*y3 - 50*u*v*x2*y2 - 25*u*v*x3*y1 + 25*u*v*x2*y3 + 25*u*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (u2*(49*p^2*y3^2 + 25*r^2*y3^2 + 25*u^2*y3^2 + 25*v^2*x3^2 + 49*p^2*y1*y2 - 49*p^2*y1*y3 - 49*p^2*y2*y3 + 25*r^2*y1*y2 - 25*r^2*y1*y3 - 25*r^2*y2*y3 + 25*v^2*x1*x2 - 25*v^2*x1*x3 - 25*v^2*x2*x3 + 25*u^2*y1*y2 - 25*u^2*y1*y3 - 25*u^2*y2*y3 - 25*u*v*x1*y2 - 25*u*v*x2*y1 + 25*u*v*x1*y3 + 25*u*v*x3*y1 + 25*u*v*x2*y3 + 25*u*v*x3*y2 - 50*u*v*x3*y3))/(((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(50*x1*y2 - 50*x2*y1 - 50*x1*y3 + 50*x3*y1 + 50*x2*y3 - 50*x3*y2)) - (u1*(49*p^2*y2^2 + 49*p^2*y3^2 + 25*r^2*y2^2 + 25*r^2*y3^2 + 25*u^2*y2^2 + 25*v^2*x2^2 + 25*u^2*y3^2 + 25*v^2*x3^2 - 98*p^2*y2*y3 - 50*r^2*y2*y3 - 50*v^2*x2*x3 - 50*u^2*y2*y3 - 50*u*v*x2*y2 + 50*u*v*x2*y3 + 50*u*v*x3*y2 - 50*u*v*x3*y3))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p3*(5*u*y2^2 - 5*u*y1*y2 + 5*v*x2*y1 + 5*u*y1*y3 - 5*v*x2*y2 - 5*v*x3*y1 - 5*u*y2*y3 + 5*v*x3*y2 + 7*p*r*u*y2^2 - 7*p*r*u*y1*y2 + 7*p*r*v*x1*y2 + 7*p*r*u*y1*y3 - 7*p*r*v*x1*y3 - 7*p*r*v*x2*y2 - 7*p*r*u*y2*y3 + 7*p*r*v*x2*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p2*(5*u*y3^2 + 5*u*y1*y2 - 5*v*x2*y1 - 5*u*y1*y3 + 5*v*x3*y1 - 5*u*y2*y3 + 5*v*x2*y3 - 5*v*x3*y3 + 7*p*r*u*y3^2 + 7*p*r*u*y1*y2 - 7*p*r*v*x1*y2 - 7*p*r*u*y1*y3 + 7*p*r*v*x1*y3 - 7*p*r*u*y2*y3 + 7*p*r*v*x3*y2 - 7*p*r*v*x3*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*r3*(y2 - y3)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r*r2*(y2 - y3)*(u*y1 - v*x1 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*r1*(y2 - y3)*(u*y2 - v*x2 - u*y3 + v*x3))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (v1*(x2 - x3)*(y2 - y3)*(49*p^2 + 25*r^2))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (v2*(x1 - x3)*(y2 - y3)*(49*p^2 + 25*r^2))/(50*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (p1*(7*p*r + 5)*(y2 - y3)*(u*y2 - v*x2 - u*y3 + v*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - p3*((p2*((u^2*y1^2 + v^2*x1^2 - v^2*x1*x2 - v^2*x1*x3 + v^2*x2*x3 - u^2*y1*y2 - u^2*y1*y3 + u^2*y2*y3 - 2*u*v*x1*y1 + u*v*x1*y2 + u*v*x2*y1 + u*v*x1*y3 + u*v*x3*y1 - u*v*x2*y3 - u*v*x3*y2)/(2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (x1*x2 + x1*x3 - x2*x3 + y1*y2 + y1*y3 - y2*y3 - x1^2 - y1^2)/(2*r^2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))))/((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3)) + (p1*((u^2*y2^2 + v^2*x2^2 - v^2*x1*x2 + v^2*x1*x3 - v^2*x2*x3 - u^2*y1*y2 + u^2*y1*y3 - u^2*y2*y3 + u*v*x1*y2 + u*v*x2*y1 - u*v*x1*y3 - 2*u*v*x2*y2 - u*v*x3*y1 + u*v*x2*y3 + u*v*x3*y2)/(2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (x1*x2 - x1*x3 + x2*x3 + y1*y2 - y1*y3 + y2*y3 - x2^2 - y2^2)/(2*r^2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))))/((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3)) + (v2*(5*v*x1^2 - 5*u*x1*y1 + 5*u*x2*y1 - 5*v*x1*x2 + 5*u*x1*y3 - 5*v*x1*x3 - 5*u*x2*y3 + 5*v*x2*x3 + 7*p*r*v*x1^2 - 7*p*r*u*x1*y1 + 7*p*r*u*x1*y2 - 7*p*r*v*x1*x2 + 7*p*r*u*x3*y1 - 7*p*r*v*x1*x3 - 7*p*r*u*x3*y2 + 7*p*r*v*x2*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (v1*(5*v*x2^2 + 5*u*x1*y2 - 5*v*x1*x2 - 5*u*x1*y3 - 5*u*x2*y2 + 5*v*x1*x3 + 5*u*x2*y3 - 5*v*x2*x3 + 7*p*r*v*x2^2 + 7*p*r*u*x2*y1 - 7*p*r*v*x1*x2 - 7*p*r*u*x2*y2 - 7*p*r*u*x3*y1 + 7*p*r*v*x1*x3 + 7*p*r*u*x3*y2 - 7*p*r*v*x2*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u2*(5*u*y1^2 - 5*v*x1*y1 - 5*u*y1*y2 + 5*v*x1*y2 - 5*u*y1*y3 + 5*v*x3*y1 + 5*u*y2*y3 - 5*v*x3*y2 + 7*p*r*u*y1^2 - 7*p*r*v*x1*y1 - 7*p*r*u*y1*y2 + 7*p*r*v*x2*y1 - 7*p*r*u*y1*y3 + 7*p*r*v*x1*y3 + 7*p*r*u*y2*y3 - 7*p*r*v*x2*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u1*(5*u*y2^2 - 5*u*y1*y2 + 5*v*x2*y1 + 5*u*y1*y3 - 5*v*x2*y2 - 5*v*x3*y1 - 5*u*y2*y3 + 5*v*x3*y2 + 7*p*r*u*y2^2 - 7*p*r*u*y1*y2 + 7*p*r*v*x1*y2 + 7*p*r*u*y1*y3 - 7*p*r*v*x1*y3 - 7*p*r*v*x2*y2 - 7*p*r*u*y2*y3 + 7*p*r*v*x2*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (p3*(x1^2 - 2*y1*y2 - 2*x1*x2 + x2^2 + y1^2 + y2^2 + r^2*u^2*y1^2 + r^2*v^2*x1^2 + r^2*u^2*y2^2 + r^2*v^2*x2^2 - 2*r^2*v^2*x1*x2 - 2*r^2*u^2*y1*y2 - 2*r^2*u*v*x1*y1 + 2*r^2*u*v*x1*y2 + 2*r^2*u*v*x2*y1 - 2*r^2*u*v*x2*y2))/(2*r^2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (v3*(7*p*r + 5)*(x1 - x2)*(u*y1 - v*x1 - u*y2 + v*x2))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (u3*(7*p*r + 5)*(y1 - y2)*(u*y1 - v*x1 - u*y2 + v*x2))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - p2*((p1*((u^2*y3^2 + v^2*x3^2 + v^2*x1*x2 - v^2*x1*x3 - v^2*x2*x3 + u^2*y1*y2 - u^2*y1*y3 - u^2*y2*y3 - u*v*x1*y2 - u*v*x2*y1 + u*v*x1*y3 + u*v*x3*y1 + u*v*x2*y3 + u*v*x3*y2 - 2*u*v*x3*y3)/(2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (x1*x2 - x1*x3 - x2*x3 + y1*y2 - y1*y3 - y2*y3 + x3^2 + y3^2)/(2*r^2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))))/((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3)) + (p3*((u^2*y1^2 + v^2*x1^2 - v^2*x1*x2 - v^2*x1*x3 + v^2*x2*x3 - u^2*y1*y2 - u^2*y1*y3 + u^2*y2*y3 - 2*u*v*x1*y1 + u*v*x1*y2 + u*v*x2*y1 + u*v*x1*y3 + u*v*x3*y1 - u*v*x2*y3 - u*v*x3*y2)/(2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (x1*x2 + x1*x3 - x2*x3 + y1*y2 + y1*y3 - y2*y3 - x1^2 - y1^2)/(2*r^2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))))/((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3)) + (v3*(5*v*x1^2 - 5*u*x1*y1 + 5*u*x1*y2 - 5*v*x1*x2 + 5*u*x3*y1 - 5*v*x1*x3 - 5*u*x3*y2 + 5*v*x2*x3 + 7*p*r*v*x1^2 - 7*p*r*u*x1*y1 + 7*p*r*u*x2*y1 - 7*p*r*v*x1*x2 + 7*p*r*u*x1*y3 - 7*p*r*v*x1*x3 - 7*p*r*u*x2*y3 + 7*p*r*v*x2*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (v1*(5*v*x3^2 - 5*u*x1*y2 + 5*v*x1*x2 + 5*u*x1*y3 - 5*v*x1*x3 + 5*u*x3*y2 - 5*v*x2*x3 - 5*u*x3*y3 + 7*p*r*v*x3^2 - 7*p*r*u*x2*y1 + 7*p*r*v*x1*x2 + 7*p*r*u*x3*y1 - 7*p*r*v*x1*x3 + 7*p*r*u*x2*y3 - 7*p*r*v*x2*x3 - 7*p*r*u*x3*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u3*(5*u*y1^2 - 5*v*x1*y1 - 5*u*y1*y2 + 5*v*x2*y1 - 5*u*y1*y3 + 5*v*x1*y3 + 5*u*y2*y3 - 5*v*x2*y3 + 7*p*r*u*y1^2 - 7*p*r*v*x1*y1 - 7*p*r*u*y1*y2 + 7*p*r*v*x1*y2 - 7*p*r*u*y1*y3 + 7*p*r*v*x3*y1 + 7*p*r*u*y2*y3 - 7*p*r*v*x3*y2))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (u1*(5*u*y3^2 + 5*u*y1*y2 - 5*v*x2*y1 - 5*u*y1*y3 + 5*v*x3*y1 - 5*u*y2*y3 + 5*v*x2*y3 - 5*v*x3*y3 + 7*p*r*u*y3^2 + 7*p*r*u*y1*y2 - 7*p*r*v*x1*y2 - 7*p*r*u*y1*y3 + 7*p*r*v*x1*y3 - 7*p*r*u*y2*y3 + 7*p*r*v*x3*y2 - 7*p*r*v*x3*y3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (p2*(x1^2 - 2*y1*y3 - 2*x1*x3 + x3^2 + y1^2 + y3^2 + r^2*u^2*y1^2 + r^2*v^2*x1^2 + r^2*u^2*y3^2 + r^2*v^2*x3^2 - 2*r^2*v^2*x1*x3 - 2*r^2*u^2*y1*y3 - 2*r^2*u*v*x1*y1 + 2*r^2*u*v*x1*y3 + 2*r^2*u*v*x3*y1 - 2*r^2*u*v*x3*y3))/(2*r^2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (v2*(7*p*r + 5)*(x1 - x3)*(u*y1 - v*x1 - u*y3 + v*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (u2*(7*p*r + 5)*(y1 - y3)*(u*y1 - v*x1 - u*y3 + v*x3))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2))) - u3*((v3*(49*p^2*x1*y1 - 49*p^2*x1*y2 - 49*p^2*x2*y1 + 49*p^2*x2*y2 + 25*r^2*x1*y1 - 25*r^2*x1*y2 - 25*r^2*x2*y1 + 25*r^2*x2*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) - (v2*(49*p^2*x1*y1 - 49*p^2*x1*y2 - 49*p^2*x3*y1 + 49*p^2*x3*y2 + 25*r^2*x1*y1 - 25*r^2*x1*y2 - 25*r^2*x3*y1 + 25*r^2*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (v1*(49*p^2*x2*y1 - 49*p^2*x2*y2 - 49*p^2*x3*y1 + 49*p^2*x3*y2 + 25*r^2*x2*y1 - 25*r^2*x2*y2 - 25*r^2*x3*y1 + 25*r^2*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (u2*(49*p^2*y1^2 + 25*r^2*y1^2 + 25*u^2*y1^2 + 25*v^2*x1^2 - 49*p^2*y1*y2 - 49*p^2*y1*y3 + 49*p^2*y2*y3 - 25*r^2*y1*y2 - 25*r^2*y1*y3 + 25*r^2*y2*y3 - 25*v^2*x1*x2 - 25*v^2*x1*x3 + 25*v^2*x2*x3 - 25*u^2*y1*y2 - 25*u^2*y1*y3 + 25*u^2*y2*y3 - 50*u*v*x1*y1 + 25*u*v*x1*y2 + 25*u*v*x2*y1 + 25*u*v*x1*y3 + 25*u*v*x3*y1 - 25*u*v*x2*y3 - 25*u*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (u1*(49*p^2*y2^2 + 25*r^2*y2^2 + 25*u^2*y2^2 + 25*v^2*x2^2 - 49*p^2*y1*y2 + 49*p^2*y1*y3 - 49*p^2*y2*y3 - 25*r^2*y1*y2 + 25*r^2*y1*y3 - 25*r^2*y2*y3 - 25*v^2*x1*x2 + 25*v^2*x1*x3 - 25*v^2*x2*x3 - 25*u^2*y1*y2 + 25*u^2*y1*y3 - 25*u^2*y2*y3 + 25*u*v*x1*y2 + 25*u*v*x2*y1 - 25*u*v*x1*y3 - 50*u*v*x2*y2 - 25*u*v*x3*y1 + 25*u*v*x2*y3 + 25*u*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (r2*(r*u*y1^2 - r*v*x1*y1 - r*u*y1*y2 + r*v*x1*y2 - r*u*y1*y3 + r*v*x3*y1 + r*u*y2*y3 - r*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (r1*(r*u*y2^2 - r*u*y1*y2 + r*v*x2*y1 + r*u*y1*y3 - r*v*x2*y2 - r*v*x3*y1 - r*u*y2*y3 + r*v*x3*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (u3*(49*p^2*y1^2 + 49*p^2*y2^2 + 25*r^2*y1^2 + 25*r^2*y2^2 + 25*u^2*y1^2 + 25*v^2*x1^2 + 25*u^2*y2^2 + 25*v^2*x2^2 - 98*p^2*y1*y2 - 50*r^2*y1*y2 - 50*v^2*x1*x2 - 50*u^2*y1*y2 - 50*u*v*x1*y1 + 50*u*v*x1*y2 + 50*u*v*x2*y1 - 50*u*v*x2*y2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(25*x1*y2 - 25*x2*y1 - 25*x1*y3 + 25*x3*y1 + 25*x2*y3 - 25*x3*y2)) + (p2*(5*u*y1^2 - 5*v*x1*y1 - 5*u*y1*y2 + 5*v*x2*y1 - 5*u*y1*y3 + 5*v*x1*y3 + 5*u*y2*y3 - 5*v*x2*y3 + 7*p*r*u*y1^2 - 7*p*r*v*x1*y1 - 7*p*r*u*y1*y2 + 7*p*r*v*x1*y2 - 7*p*r*u*y1*y3 + 7*p*r*v*x3*y1 + 7*p*r*u*y2*y3 - 7*p*r*v*x3*y2))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) + (p1*(5*u*y2^2 - 5*u*y1*y2 + 5*v*x1*y2 + 5*u*y1*y3 - 5*v*x1*y3 - 5*v*x2*y2 - 5*u*y2*y3 + 5*v*x2*y3 + 7*p*r*u*y2^2 - 7*p*r*u*y1*y2 + 7*p*r*v*x2*y1 + 7*p*r*u*y1*y3 - 7*p*r*v*x2*y2 - 7*p*r*v*x3*y1 - 7*p*r*u*y2*y3 + 7*p*r*v*x3*y2))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (r*r3*(y1 - y2)*(u*y1 - v*x1 - u*y2 + v*x2))/(2*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)) - (p3*(7*p*r + 5)*(y1 - y2)*(u*y1 - v*x1 - u*y2 + v*x2))/(10*r*((x1 - x3)*(y2 - y3) - (x2 - x3)*(y1 - y3))*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2)));
%     Err(i) = Err(i)*dt^2;

end

[~, e] = sort(Err);

e = e(end-round(length(Err)/100*ep):end);

nn = [1 2 3 1];
NJ = [];

for i = 1:length(e)
    n = e(i);
    
    if sum(find(NJ==n))==0
        x(1) = nodes(element(n,1),1); x(2) = nodes(element(n,2),1); x(3) = nodes(element(n,3),1);
        y(1) = nodes(element(n,1),2); y(2) = nodes(element(n,2),2); y(3) = nodes(element(n,3),2);

        L(1) = sqrt((y(2)-y(1))^2+(x(2)-x(1))^2);
        L(2) = sqrt((y(3)-y(2))^2+(x(3)-x(2))^2);
        L(3) = sqrt((y(3)-y(1))^2+(x(3)-x(1))^2);

        [~,l] = max(L);

        xn = mean([x(nn(l)),x(nn(l+1))]);
        yn = mean([y(nn(l)),y(nn(l+1))]);

        nodes2(end+1,:) = [xn yn];
        nNode = nNode+1;
        U2(end+1:end+4) = 0.5*[U(4*(element(n,nn(l))-1)+1)+U(4*(element(n,nn(l+1))-1)+1);  U(4*(element(n,nn(l))-1)+2)+U(4*(element(n,nn(l+1))-1)+2); ...
                              U(4*(element(n,nn(l))-1)+3)+U(4*(element(n,nn(l+1))-1)+3); U(4*(element(n,nn(l))-1)+4)+U(4*(element(n,nn(l+1))-1)+4) ];
           


        if l==1
            element2(n,:) = [element(n,1) nNode element(n,3)];
            element2(end+1,:) = [nNode element(n,2) element(n,3)];
        elseif l==2
            element2(n,:) = [element(n,1) nNode element(n,3)];
            element2(end+1,:) = [element(n,1) element(n,2) nNode];
        elseif l==3
            element2(n,:) = [nNode element(n,2) element(n,3)];
            element2(end+1,:) = [element(n,1) element(n,2) nNode ];
        end

        % finding the neighbor element
        n1 = element(n,nn(l));
        n2 = element(n,nn(l+1));

        nElm = size(element2,1);
        e1 = find(element2==n1); 
        clear E1
        for ne=1:length(e1)
            if e1(ne) <= nElm
                E1(ne) = e1(ne);
            elseif e1(ne) > nElm && e1(ne) <=2*nElm
                E1(ne) = e1(ne)-nElm;
            elseif e1(ne) > 2*nElm
                E1(ne) = e1(ne)-2*nElm;
            end
        end


        e2 = find(element2==n2);   
        clear E2
        for ne=1:length(e2)
            if e2(ne) <= nElm
                E2(ne) = e2(ne);
            elseif e2(ne) > nElm && e2(ne) <=2*nElm
                E2(ne) = e2(ne)-nElm;
            elseif e2(ne) > 2*nElm
                E2(ne) = e2(ne)-2*nElm;
            end
        end

        J = [];
        for ee = 1:length(E1)
            j = find(E1(ee)==E2,1);
            if ~isempty(j) && E2(j)~=n
                J = E2(j);                  % element j has the same edge
                break;
            end
        end

        if ~isempty(J)
            NJ(end+1) = J;
     
            e1 = find(element2(J,:)==n1);
            e2 = find(element2(J,:)==n2);

            if (e1==1 && e2 ==2) || (e1==2 && e2==1)
                elem1 = [element2(J,1) nNode element2(J,3)];
                elem2 = [nNode element2(J,2) element2(J,3)];
                element2(J,:) = elem1;
                element2(end+1,:) = elem2;
            elseif (e1==2 && e2 ==3) || (e1==3 && e2==2)
                elem1 = [element2(J,1) nNode element2(J,3)];
                elem2 = [element2(J,1) element2(J,2) nNode];
                element2(J,:) = elem1;
                element2(end+1,:) = elem2;
            elseif (e1==1 && e2 ==3) || (e1==3 && e2==1)   
                elem1 = [nNode element2(J,2) element2(J,3)];
                elem2 = [element2(J,1) element2(J,2) nNode];
                element2(J,:) = elem1;
                element2(end+1,:) = elem2;
            end
        end
    end
end
