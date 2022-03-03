function t = f_trigger(secs,thekeys)

    global counter;
    global i;
    global time_trigger_mr;
    global time_escape_mr;
    
    if thekeys == 't'
        time_trigger_mr(i,counter) = secs;
        counter = counter +1;
    elseif thekeys == 'e'
        t1 = GetSecs;
        time_escape_mr = secs - t1;
        sca
        ListenChar(0); %makes it so characters typed do show up in the command window
        ShowCursor(); %shows the cursor
        disp('E pressed')
    end
    return
end %end of func