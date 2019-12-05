-- 1:
-- Skrifið Stored Procedure ElectedCourses
-- Kalla skal á ElectedCourses með nemendanúmeri og hann skilar til baka vali fyrir næstu önn.

-- ATHUGIÐ:
-- Það má alveg takmarka fjölda áfanga sem kerfið velur við t.d. 5 eða einhvern fjölda sem hentar ykkar hönnun.

-- ATTENTION:
-- ElectedCourses þarf að finna þessa áfanga útfrá óloknum áföngum. Skoða þarf hvaða áfangar koma
-- næst. Ef ekki er hægt með góðu móti að finna út hvaða áfangi kemru næst í röðinni þá er bara hægt
-- að velja random 

-- ACHTUNG:
-- Ekki þarf að kanna fall í núverandi áföngum(þeir áfangar sem nemandinn er í en hefur ekki klárað
-- þegar val fer fram).

-- ATTENZIONE:
-- Málið er eiginlega þetta:  Nemandinn er í X áföngum og búinn með Y áfanga.  Hvað getur hann tekið næst
delimiter $$
drop procedure if exists ElectedCourses $$
create procedure ElectedCourses()
begin

end ;
delimiter ;

-- 2:
-- Bætið við eða aðlagið klasasafnið ykkar(library) úr verkefni 4 þannig að þig getið prófað þessa virkni úr forriti
-- í viðbót við að testa þetta í grunninum sjálfum!
