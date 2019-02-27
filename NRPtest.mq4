//+------------------------------------------------------------------+
//|                                                      NRPtest.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
datetime current;
ENUM_OBJECT arrow_obj;
int obj_total;
int flag=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

//long var = ObjectGetInteger(NULL,"SBNR arrows:1529380800",OBJPROP_TYPE,0);
//Print("VALUE OF VAR"+var);
//--- create timer

   EventSetTimer(60);
   obj_total = ObjectsTotal();
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
//---=
   if(obj_total != ObjectsTotal())
   {
      obj_total = ObjectsTotal();
      datetime latest = 0;
      int index = 0;
      for(int i=0;i<ObjectsTotal();i++)
      {
         if(ObjectGetInteger(0,ObjectName(0,i),OBJPROP_TIME) > latest)
         {
            latest = ObjectGetInteger(0,ObjectName(0,i),OBJPROP_TIME);
            index = i;
         }
         
      }
      Print("Object Name: "+ObjectName(0,index));
      Print("Object Time: "+latest); 
   } 
   
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
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
