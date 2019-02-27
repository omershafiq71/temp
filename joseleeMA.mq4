//+------------------------------------------------------------------+
//|                                                    joseleeMA.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//---
/*extern string symbol_1=NULL;
extern ENUM_TIMEFRAMES timeframe_1=_Period;
input int ma_period_1=13;*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum movingaveragesettings
  {
   mov,//--- Moving Average Settings ---
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum generalsettings
  {
   gnsettings,//--- General Settings --

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum trailingPoint
  {
   tPoint,//--- Trailing Point Settings --

  };
input movingaveragesettings movingaverage_settings1=mov; //Moving Average 1
input int maPeriod1=13; //MA averaging period 
input int maShift1=0; // MA shift 
input ENUM_MA_METHOD maMethod1=2; // averaging method 
input ENUM_APPLIED_PRICE appliedPrice1=PRICE_CLOSE; // applied price 

input movingaveragesettings movingaverage_settings2=mov; //Moving Average 2
input int maPeriod2=36; //MA averaging period 
input int maShift2=0; // MA shift 
input ENUM_MA_METHOD maMethod2=2; // averaging method 
input ENUM_APPLIED_PRICE appliedPrice2=PRICE_CLOSE; // applied price

input movingaveragesettings movingaverage_settings3=mov; //Moving Average 3
input int maPeriod3=150; //MA averaging period 
input int maShift3=0; // MA shift 
input ENUM_MA_METHOD maMethod3=2; // averaging method 
input ENUM_APPLIED_PRICE appliedPrice3=PRICE_CLOSE; // applied price

input generalsettings general_settings=gnsettings; //--- JoseleeMA ---
input int reverseCandal=3;// Reverse Candal
input double lotSize=0.1;// Lot Size
input double takeProfit=200;// Take Profit
input double stopLoss=200;// Stop Loss
input int dist=100;// Distance
input int magic=12345;
//---
input trailingPoint tp=tPoint; // Trailing Point
input double trailPoint=50;
input int partialDistance=100; // Distance for partial close
input int partialPercentage=50; // Lot Percent to Partial Close
double partialLot=(partialPercentage*lotSize)/100;
datetime current;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

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
   int count=1;
   if(Time[0]!=current)
     {
      current=Time[0];
      // Print("New Candle");
      double ima1,ima2,ima3;
      ima1=iMA(Symbol(),0,maPeriod1,maShift1,maMethod1,appliedPrice1,1);
      ima2=iMA(Symbol(),0,maPeriod2,maShift2,maMethod2,appliedPrice2,1);
      ima3=iMA(Symbol(),0,maPeriod3,maShift3,maMethod3,appliedPrice3,1);
      //------------------------TO BUY--------------------------
      //---
      if(Ask>ima3)
        {
         Print("ASK IS GREATER THEN SMA3");
         if(ima1>ima2 && ima2>ima3)
           {
            if((ima1-ima2)/Point<=dist)
              {
               Print("IMA1 IS GREATER THEN IMA2 AND IMA2 IS GREATER THEN IMA3");

               for(int i=2;i<=reverseCandal+1;i++)
                 {
                  if(Open[i]>Close[i])
                    {
                     count++;
                     Print("COUNT="+count);
                    }
                 }
               if(count==reverseCandal)
                 {
                  Print("COUNT IS EQUAL TO REVERSE CANDAL");

                  if(Open[1]<Close[1])
                    {
                     Print("TIME TO BUY");

                     if(OrderSend(Symbol(),OP_BUY,lotSize,Ask,3,Ask-(stopLoss*Point),Ask+(takeProfit*Point),NULL,magic,0,Red)<0)
                       {
                        Print("Order Buy Could not send",GetLastError());

                       }

                    }

                 }
              }
           }

        }
      //////////////////////////////////Buy////////////////////////////////////
      if(Bid<ima3)
        {
         Print("Bid IS SMALLER THEN SMA3");
         if(ima1<ima2 && ima2<ima3)
           {
            if((ima2-ima1)/Point<=dist)
              {
               for(int i=2;i<=reverseCandal+1;i++)
                 {
                  if(Open[i]<Close[i])
                    {
                     count++;
                    }
                 }
               if(count==reverseCandal)
                 {
                  if(Open[1]>Close[1])
                    {
                     if(OrderSend(Symbol(),OP_SELL,lotSize,Bid,3,Bid+(stopLoss*Point),Bid-(takeProfit*Point),NULL,magic,0,Green)<0)
                       {
                        Print("Order Sell Could not send",GetLastError());
                       }

                    }

                 }

              }
           }
        }
      //---

     }
//---
///////////////////////////////////////-----------------------------Trailing Point-------------------------/////////////////////////////////////////////////
   for(int i=1;i<=OrdersTotal();i++)
     {
      OrderSelect(i,SELECT_BY_POS);

      if(OrderMagicNumber()==magic)
        {
         Print("-------------------------MAGIC NUMBER----------------------");

         if(OrderType()==OP_BUY)
           {
            Print("--------------------BUY TYPE-----------------------");

            if((Ask-OrderOpenPrice())/Point>=trailPoint)
              {
               Print("-------------BUY-------------------");
               if((Ask-(trailPoint*Point))>OrderStopLoss())
                 {
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),Ask-(trailPoint*Point),OrderTakeProfit(),OrderExpiration(),clrBlueViolet)>0)
                    {
                     Print("BUY Order Modified");
                    }
                 }
              }
            //+------------------------------------------------------------------+
            if((Ask-OrderOpenPrice())/Point>=partialDistance)
              {
               Print("#########################Partail Buy Order Closed#############################");

               if(OrderClose(OrderTicket(),partialLot,Bid,3,clrPink)>0)
                 {
                  Print("Successfully buy Order Closed");
                 }
              }

            //+------------------------------------------------------------------+

           }
         else if(OrderType()==OP_SELL)
           {

            Print("--------------------SELL TYPE-----------------------");

            if((OrderOpenPrice()-Bid)/Point>=trailPoint)
              {
               printf("-------------SELL-------------------");
               if((Bid+(trailPoint*Point))>OrderStopLoss())
                 {
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),Bid+(trailPoint*Point),OrderTakeProfit(),OrderExpiration(),clrBlueViolet)>0)
                    {
                     Print("SELL Order Modified");
                    }
                 }
              }
            //+------------------------------------------------------------------+

            if((OrderOpenPrice()-Bid)/Point>=partialDistance)
              {
               Print("#########################Partail SELL Order Closed#############################");
               if(OrderClose(OrderTicket(),partialLot,Ask,3,clrGray)>0)
                 {
                  Print("Successfully Sell Order Closed");
                 }
              }
            //+------------------------------------------------------------------+

           }
        }
     }
//---

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
