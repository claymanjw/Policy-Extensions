function NSTEXT:WEEKNUMOFYEAR() : NSTEXT
  -- Example of code that get week number according to ISO8601
 -- Get day of a week at year beginning 
--(tm can be any date and will be forced to 1st of january same year)
-- return 1=mon 7=sun

local function getYearBeginDayOfWeek(tm)
  local yearBegin = os.time{year=os.date("*t",tm).year,month=1,day=1}
  local yearBeginDayOfWeek = tonumber(os.date("%w",yearBegin))
  -- sunday correct from 0 -> 7
  if(yearBeginDayOfWeek == 0) then yearBeginDayOfWeek = 7 end
  return yearBeginDayOfWeek
end

-- tm: date (as retruned fro os.time)
-- returns basic correction to be add for counting number of week
--  weekNum = math.floor((dayOfYear + returnedNumber) / 7) + 1 
-- (does not consider correctin at begin and end of year) 
local function getDayAdd(tm)
  local yearBeginDayOfWeek = getYearBeginDayOfWeek(tm)
  local dayAdd
  if(yearBeginDayOfWeek < 5 ) then
    -- first day is week 1
    dayAdd = (yearBeginDayOfWeek - 2)
  else 
    -- first day is week 52 or 53
    dayAdd = (yearBeginDayOfWeek - 9)
  end  
  return dayAdd
end
-- tm is date as returned from os.time()
-- return week number in year based on ISO8601 
-- (week with 1st thursday since Jan 1st (including) is considered as Week 1)
-- (if Jan 1st is Fri,Sat,Sun then it is part of week number from last year -> 52 or 53) 
local function getWeekNumberOfYear(tm)
  local dayOfYear = os.date("%j",tm)
  local dayAdd = getDayAdd(tm)
  local dayOfYearCorrected = dayOfYear + dayAdd
  if(dayOfYearCorrected < 0) then
    -- week of last year - decide if 52 or 53
    local lastYearBegin = os.time{year=os.date("*t",tm).year-1,month=1,day=1}
    local lastYearEnd = os.time{year=os.date("*t",tm).year-1,month=12,day=31}
    dayAdd = getDayAdd(lastYearBegin)
    dayOfYear = dayOfYear + os.date("%j",lastYearEnd)
    dayOfYearCorrected = dayOfYear + dayAdd
  end  
  local weekNum = math.floor((dayOfYearCorrected) / 7) + 1
  if( (dayOfYearCorrected > 0) and weekNum == 53) then
    -- check if it is not considered as part of week 1 of next year
    local nextYearBegin = os.time{year=os.date("*t",tm).year+1,month=1,day=1}
    local yearBeginDayOfWeek = getYearBeginDayOfWeek(nextYearBegin)
    if(yearBeginDayOfWeek < 5 ) then
      weekNum = 1
    end  
  end  
  return weekNum
end
return getWeekNumberOfYear(tm)
end