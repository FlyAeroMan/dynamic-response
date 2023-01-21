function dutchRollResults = DutchRollCalc(latRoots)
% DutchRollCalc - a function to calculate the natural frequency and damping
% ratio of the dutch period dynamic mode
% FORMAT: dutchRollResults = DutchRollCalc(latRoots)

% Now... which root do we want? The dutch roll roots are the two
% oscillatory roots with non-zero imaginary components. The other roots are
% the roll mode and spiral mode respectivly. Here we find the two roots
% with the imaginary values that are the same in magnitude
for itr = 1:length(latRoots)
    if imag(latRoots(itr)) ~= 0
        break
    end
end
% the only oscillatory root is the dutch roll, and they are complex
% conjugates, therefore find one and you know the other
DutchRoot = latRoots(itr);
RealComponent = real(DutchRoot);
ImaginaryComponent = abs(imag(DutchRoot));

%calculate the naturan frequency (rad/s) and damping ratio (unitless)
NaturalFrequency = sqrt(RealComponent^2 + ImaginaryComponent^2);
DampingRatio = -RealComponent/NaturalFrequency;

dutchRollResults = [NaturalFrequency, DampingRatio];
end