clear all;clc;close all;

moc_tags = 1:14;

k_accs = zeros(1,length(moc_tags));

for imt = 1:length(moc_tags)
    moc_tag = moc_tags(imt);

    fname = ['Dataset/CMU_MOC_Cache/MOC_',num2str(moc_tag),'_kres.mat'];

    load(fname);

    k_accs(imt) = accuracy(1);
end

agg_accs = zeros(1,length(moc_tags));

for imt = 1:length(moc_tags)
    moc_tag = moc_tags(imt);

    fname = ['Dataset/CMU_MOC_Cache/MOC_',num2str(moc_tag),'_res_t0.4.mat'];

    load(fname);

    agg_accs(imt) = accuracy(1);
end

accs(1,:) = k_accs;
accs(2,:) = agg_accs;

bar(moc_tags, accs');
legend('K-Means', 'Temp-AC');