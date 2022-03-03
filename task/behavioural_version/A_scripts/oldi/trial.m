function [counter] = trigger(trial, counter)

     t1 = GetSecs;
    [keyIsDown,t2,keyCode] = KbCheck; 
     if (keyCode(KbName('t'))==1)
           time_trigger_mr(trial,counter) = t2-t1 ;
           counter = counter +1;
     end

end