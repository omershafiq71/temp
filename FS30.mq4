//+------------------------------------------------------------------+
//|                                                         FS30.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_buffers 2       // Number of buffers
#property indicator_color1 Red     // Color of the 1st line
#property indicator_color2 Blue      // Color of the 2nd line
double Buf_2[],Buf_3[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum generalsettings
  {
   gnsettings,//--- General Settings --

  };
input generalsettings general_settings=gnsettings; //--- NRP ---
input double lotSize=0.1;// Lot Size
input double takeProfit=200;// Take Profit
input double stopLoss=200;// Stop Loss
input int breakEvenDist=100;// Distance
input int lockPoints=5;// Lock Points
input int magic=12345;// Magic Number
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
 /*  SetIndexBuffer(0,Buf_0);         // Assigning an array to a buffer
                                    // SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);// Line style
   SetIndexBuffer(1,Buf_1);         // Assigning an array to a buffer
   */                                 // SetIndexStyle(1,DRAW_LINE,STYLE_DOT,1);// Line style
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
//---
   if(Time[0]!=current)
     {
/* string name=ObjectName(0);
      color prince=ObjectGet(name,OBJPROP_COLOR);
      if(prince=='clrRed')
        {
         if(OrderSend(Symbol(),OP_SELL,lotSize,Bid,3,Bid+(stopLoss*Point),Bid-(takeProfit*Point),NULL,magic,0,Green)>0)
           {
            Print("Order Sell  send",GetLastError());
           }
        }
      else if(prince=='clrLime')
        {
         if(OrderSend(Symbol(),OP_BUY,lotSize,Ask,3,Ask-(stopLoss*Point),Ask+(takeProfit*Point),NULL,magic,0,Red)>0)
           {
            Print("Order Buy send",GetLastError());

           }

        }
*/
      current=Time[0];

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
