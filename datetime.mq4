//+------------------------------------------------------------------+
//|                                                    juliuspeh.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum generalsettings
  {
   gnsettings,//--- General Settings --
  };

input generalsettings general_settings=gnsettings; //--- NRP ---
                                                   //datetime current;
input datetime gtime="07.13.2018";// mm.dd.year(Strictly follow pattern)
datetime given_date;
int allert_day;
int allert_month;
int allert_year;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   given_date=gtime;
   allert_day=TimeDay(given_date);
   allert_month=TimeMonth(given_date);
   allert_year=TimeYear(given_date);
   Print("time is          "+allert_day,",",allert_month,",",allert_year);

// printf("The Month .....= "+current_month+" Year is.....= "+current_year+" day is.....= "+current_day);
   printf("here is tha value of the current time"+TimeCurrent());
//--- create timer
   EventSetTimer(60);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

//--- destroy timer
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   int current_day=TimeDay(TimeCurrent());
   int current_month=TimeMonth(TimeCurrent());
   int current_year=TimeYear(TimeCurrent());
   Print("Alert month is",allert_month);
   if(allert_month==3)
     {
      Print("fdbd");
      if(allert_day==31)
        {
         Print("allerttt");
         current_day=current_day+3;
        }
      if(allert_day==30)
        {
         current_day=current_day+2;
        }
      if(allert_day==29)
        {
         current_day=current_day+1;
        }
     }
   else if(allert_day==31)
     {
      current_day=current_day+1;
     }
   Print("Time Current      ",current_day,",",current_month,",",current_year);

   if(current_day==allert_day && current_month+1==allert_month && current_year==allert_year)
     {
      printf("Fuck youuu");
     }

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
