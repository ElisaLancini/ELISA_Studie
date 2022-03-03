function breakpoint % Break trial? if not get trigger %
activeKeys = [KbName('e')];
RestrictKeysForKbCheck(activeKeys);

     global time_escape_mr;
     t1 = GetSecs;
     [keyIsDown,t2,keyCode] = KbCheck; 
     if (keyCode(KbName('e'))==1)
           time_escape_mr = t2-t1;
           sca
     end
     RestrictKeysForKbCheck;
     ListenChar(0);
     return
end