clear all; clc; close all;

moc_tags = 1:14;

accs = zeros(1,length(moc_tags));

for imt = 1:length(moc_tags)
    moc_tag = moc_tags(imt);

    fname = ['Dataset/CMU_MOC_Cache/MOC_',num2str(moc_tag),'_kres.mat'];

    load(fname);

    accs(imt) = accuracy(1);
end


bar(moc_tags, accs);
xlabel('CMU Sequence');
ylabel('Accuracy');

mn = mean(accs)
md = median(accs)