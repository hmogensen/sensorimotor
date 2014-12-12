function av_setup_listeners(obj)
if ~isempty(obj.main_channel)
    addlistener(obj.main_channel,'signal','PostSet',@(~,~) main_channel_signal_listener(obj));
else
    addlistener(obj,'main_channel','PostSet',@(~,~) main_channel_listener(obj));
end

    function main_channel_listener(objhandle)
        addlistener(objhandle.main_channel,'signal','PostSet',@main_channel_signal_listener);
    end

    function main_channel_signal_listener(objhandle)
        signal = objhandle.main_channel.signal;
        if isempty(signal)
            objhandle.amplitude = [];
        else
            ampls = signal.get_ampls(objhandle.tmin,objhandle.tmax);
            if ~ampls.n
                objhandle.amplitude = [];
            elseif isempty(objhandle.amplitude)
                objhandle.amplitude = ampls.get(1);
            elseif ampls.contains(objhandle.amplitude)
                objhandle.amplitude = objhandle.amplitude;
            elseif sc_contains(ampls.values('tag'),objhandle.amplitude.tag)
                objhandle.amplitude = ampls.get('tag',objhandle.amplitude.tag);
            else
                objhandle.amplitude = ampls.get(1);
            end
        end
    end
end