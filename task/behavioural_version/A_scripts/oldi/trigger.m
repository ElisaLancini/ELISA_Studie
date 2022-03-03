function trigger
activeKeys = [KbName('t')];
RestrictKeysForKbCheck(activeKeys);

     global counter;
     global i;
     global time_trigger_mr;
    [keyIsDown,t2,keyCode] = KbCheck; 
     if (keyCode(KbName('t'))==1)
           value =  t2;
           disp(value);
           time_trigger_mr(i,counter) = value;
           counter = counter +1;
     end 
     return
end