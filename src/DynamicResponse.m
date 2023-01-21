% DynamicResponse - Intended for use with VSPAero Stability Analysis,
% calculates the dynamic response of the aircraft given the required
% non-dimensional static derivatives and control derivatives. User selects
% a .stab file from VSPAero, and this code does the rest. See README for
% more details.

% Copyright (C) 2023  Kale Macormic
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program. If not, see <https://www.gnu.org/licenses/>.

% January 17, 2023 10:56:12 PM CST -- Init Version (Kale Macormic)
% January 20, 2023 09:30:55 PM CST -- Implemented Roll Calcs into
%                                     LateralRoots (Kale Macormic)
% [next version here]

% NOTICE: This source code is Copyright (C) 2023  Kale Macormic and is
% intended for small RC aircraft use only. If you obtain this
% document in error destroy it immediately.

% initialize environment
clear all
close all
clc

% Read in the .stab file the user selects & ask for inertia matrix
allData = ReadStabFile;

% Longitudinal Modes-------------------------------------------------------

% Calculate Characteristic Equation Roots
%longRoots = LongitudinalRoots(allData);

% Calculate Phugoid Damping Ratio and Frequency
%phugoidResults = PhugoidCalc(longRoots);

% Calculate Short Period Damping Ratio and Frequency
%shortPeriodResults = ShortPeriodCalc(longRoots);

% Lateral Modes------------------------------------------------------------

% Calculate Characteristic Equation Roots
[latRoots,rollControlEffectivness,rollTimeConstant] = ...
    LateralRoots(allData);

% Calculate Dutch Roll Damping Ratio and Frequency
%dutchRollResults = DutchRollCalc(latRoots);

% Calculate Spiral Time to double amplitude
%spiralResults = SpiralCalc(latRoots);

% Data Output--------------------------------------------------------------

% Output Data to a file and/or Excel make pretty plots, etc.
%OutPutResults(allData, longRoots, phugoidResults, shortPeriodResults, ...
%    latRoots, dutchRollResults, spiralResults, rollTimeConstant, ...
%    rollControlEffectivness);