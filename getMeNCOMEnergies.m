function [EKE,EPE,Ua,Va] = getMeNCOMEnergies(NCOMinput)
% NCOM input needs to be in char format
fileName = ['NCOM\' NCOMinput '.mat'];
load(fileName);

lon = eval([NCOMinput '.lon']);
lat = eval([NCOMinput '.lat']);
depth = eval([NCOMinput '.depth']);
t6 = eval([NCOMinput '.t6']);
t5 = eval([NCOMinput '.t5']);
t4 = eval([NCOMinput '.t4']);
u500 = eval([NCOMinput '.u500']);
v500 = eval([NCOMinput '.v500']);
u300 = eval([NCOMinput '.u300']);
v300 = eval([NCOMinput '.v300']);
u100 = eval([NCOMinput '.u100']);
v100 = eval([NCOMinput '.v100']);

% EKE calculation
u500a = u500 - nanmean(u500,3); v500a = v500 - nanmean(v500,3);
u300a = u300 - nanmean(u300,3); v300a = v300 - nanmean(v300,3);
u100a = u100 - nanmean(u100,3); v100a = v100 - nanmean(v100,3);

Ua = 1/3 * (u100a + u300a + u500a);
Va = 1/3 * (v100a + v300a + v500a);
EKE = 1/6 * ((abs(u500a + 1i.*v500a)).^2 + (abs(u300a + 1i.*v300a)).^2 + (abs(u100a + 1i.*v100a)).^2);

% EKE(Ua < 0) = -EKE(Ua < 0);

% EPE calculation
% isothermFlag = or(logical(t4 <= depth),isnan(t4));
% refDepth = zeros([length(lat(:,1)) length(lon(1,:))]);
% for ii = 1:length(lon(1,:))
%     for jj = 1:length(lat(:,1))
%         if sum(isothermFlag(jj,ii,:)) >= length(t4(1,1,:))
%             refDepth(jj,ii) = depth(jj,ii);
%         else
%             refDepth(jj,ii) = mode(round(t4(jj,ii,~isothermFlag(jj,ii,:))));
%         end
%         % fprintf(1,'%d of %d at %d/%d \n',length(lat(:,1))*(ii-1)+jj,length(lat(:,1))*length(lon(1,:)),ii,jj)
%     end
% end
% EPE = 0.5 * (NBh(-refDepth)).^2 .* (t4-refDepth).^2;
% end

isothermFlag = or(logical(t4 <= depth),isnan(t4));

refDepth = zeros([length(lat(:,1)) length(lon(1,:))]);
for ii = 1:length(lon(1,:))
    for jj = 1:length(lat(:,1))
        if sum(isothermFlag(jj,ii,:)) >= length(t4(1,1,:)) % if all is problematic
            refDepth(jj,ii) = depth(jj,ii);
        elseif sum(isothermFlag(jj,ii,:)) >= length(t4(1,1,:))/2  && sum(isothermFlag(jj,ii,:)) < length(t4(1,1,:)) % if more than half is problematic
            % length(t4(1,1,:)) - sum(isothermFlag(jj,ii,:)) 
            % length(t4(jj,ii,~isothermFlag(jj,ii,:)))
            % figure(100)
            % plot(t4(jj,ii,~isothermFlag(jj,ii)))
            refDepth(jj,ii) = round(min(t4(jj,ii,~isothermFlag(jj,ii,:)),[],"all")); %
        else
            refDepth(jj,ii) = mode(round(t4(jj,ii,~isothermFlag(jj,ii,:))));
        end
        % fprintf(1,'%d of %d at %d/%d \n',length(lat(:,1))*(ii-1)+jj,length(lat(:,1))*length(lon(1,:)),ii,jj)
    end
end
EPE = 0.5 * (NBh(-refDepth)).^2 .* (t4-refDepth).^2;
end