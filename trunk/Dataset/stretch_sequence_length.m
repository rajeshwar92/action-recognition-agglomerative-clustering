function [sseq] = stretch_sequence_length(seq, sfactor)

sseq = inf(ceil(size(seq,1)*sfactor), size(seq,2));
sseq(1,:) = seq(1,:);
sseq(size(sseq,1),:) = seq(size(seq,1),:);

for i = 1:size(seq,1)
    sseq(ceil(i*sfactor),:) = seq(i,:);
end

for i = 2:size(sseq,1)
    if (sseq(i,:) == inf)
        % next value that is known
        idx = -1;
        for ni = i:size(sseq,1)
            if (sseq(ni,:) ~= inf)
                idx = ni;
                break;
            end
        end
        
        % if there is such value, after i, that is known
        if idx ~= -1
            len = idx-i+1;
            diff = sseq(idx,:)-sseq(i-1,:);
            for ni = i:idx
                t = (ni-i+1) / len;
                sseq(ni,:) = sseq(i-1,:) + t*diff;
            end
        end
    end
end