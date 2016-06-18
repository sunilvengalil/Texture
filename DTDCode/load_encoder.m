function enc = load_encoder(encPath)
    enc = load(encPath,'-mat');
    if (isstr(enc.extractorFn))
      enc.extractorFn = str2func(enc.extractorFn);
    end
end