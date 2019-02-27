//+------------------------------------------------------------------+
//|                                                Demetri_Ussmi.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Kenny Technologies Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                   ENUM HEADAERS                                               |
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
   gn_settings,//--- General Settings --

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum stochastic_Oscillator
  {
   SOsettings,//--- Stochastic Oscillator --

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum trailingPoint
  {
   tPoint,//--- Trailing Point Settings --

  };

//+------------------------------------------------------------------+
//|                      MOVING AVERAGE 1                                            |
//+------------------------------------------------------------------+

input movingaveragesettings movingaverage_settings1=mov; //Moving Average 1
input int ma_Period1=3; //MA averaging period 
input int ma_Shift1=0; // MA shift 
input ENUM_MA_METHOD ma_Method1=MODE_EMA; // averaging method 
input ENUM_APPLIED_PRICE applied_Price1=PRICE_CLOSE; // applied price 
//+------------------------------------------------------------------+
//|                      MOVING AVERAGE 2                                            |
//+------------------------------------------------------------------+

input movingaveragesettings movingaverage_settings2=mov; //Moving Average 2
input int ma_Period2=6; //MA averaging period 
input int ma_Shift2=0; // MA shift 
input ENUM_MA_METHOD ma_Method2=MODE_EMA; // averaging method 
input ENUM_APPLIED_PRICE applied_Price2=PRICE_CLOSE; // applied price
//+------------------------------------------------------------------+
//|                      MOVING AVERAGE 3                                            |
//+------------------------------------------------------------------+

input movingaveragesettings movingaverage_settings3=mov; //Moving Average 3
input int ma_Period3=50; //MA averaging period 
input int ma_Shift3=0; // MA shift 
input ENUM_MA_METHOD ma_Method3=MODE_EMA; // averaging method 
input ENUM_APPLIED_PRICE applied_Price3=PRICE_CLOSE; // applied price

//+------------------------------------------------------------------+
//|                    STOCHASTIC OSCILLATOR                                            |
//+------------------------------------------------------------------+
input stochastic_Oscillator SO_settings=SOsettings; //--- Demtri EA ---
input int k_period=14; //K Period%
input int slowing=3; //Showing
input int d_period=3; //D Period
input ENUM_STO_PRICE price_field=STO_CLOSECLOSE; //Price Field
input ENUM_MA_METHOD ma_method=MODE_LWMA; //Linear Weighted
//+------------------------------------------------------------------+
//|                      GENERAL SETTING                                             |
//+------------------------------------------------------------------+
input generalsettings general_settings=gn_settings; //--- Demtri EA ---
input double lot_Size=0.1;// Lot Size
input double take_Profit=500;// Take Profit
input double stop_Loss=130;// Stop Loss
input int magic=12345;
//+------------------------------------------------------------------+
//|                      Trailing Stop                                             |
//+------------------------------------------------------------------+
input trailingPoint tp=tPoint; // Trailing Point
input double trail_Point=50;
input int partial_Distance=100; // Distance for partial close
//input int partialPercentage=50; // Lot Percent to Partial Close
//double partialLot=(partialPercentage*lotSize)/100;
//input ENUM_TIMEFRAMES time_frame=PERIOD_M5; //Time Period
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
datetime current;
int b_count=0;
int s_count=0;
//+------------------------------------------------------------------+
//|                                                                  |
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
   s_count=0;
   b_count=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      OrderSelect(i,SELECT_BY_POS);
      if(OrderMagicNumber()==magic)
        {
         if(OrderType()==OP_BUY)
           {
            b_count++;
           }
         if(OrderType()==OP_SELL)
           {
            s_count++;
           }

        }
     }
   if(Time[0]!=current)
     {
      current=Time[0];
      double ima1,ima2,ima3;
      ima1=iMA(Symbol(),0,ma_Period1,ma_Shift1,ma_Method1,applied_Price1,1);
      ima2=iMA(Symbol(),0,ma_Period2,ma_Shift2,ma_Method2,applied_Price2,1);
      ima3=iMA(Symbol(),0,ma_Period3,ma_Shift3,ma_Method3,applied_Price3,1);
      double ima1_1=iMA(Symbol(),0,ma_Period1,ma_Shift1,ma_Method1,applied_Price1,2);
      double ima2_2=iMA(Symbol(),0,ma_Period2,ma_Shift2,ma_Method2,applied_Price2,2);
      double ima3_3=iMA(Symbol(),0,ma_Period3,ma_Shift3,ma_Method3,applied_Price3,2);
      double sto=iStochastic(Symbol(),Period(),k_period,d_period,slowing,ma_method,price_field,MODE_MAIN,1);
      if(ima1>ima3 && ima2>ima3)
        {
         Print("Complex IF 1");
         if(ima1_1<=ima3_3 || ima2_2<=ima3_3)
           {
            Print("Complex IF 2");
            if(sto>=50.0000)
              {
               Print("STO IF");
               if(b_count==0)
                 {
                  if(OrderSend(Symbol(),OP_BUY,lot_Size,Ask,3,Ask-(stop_Loss*Point),Ask+(take_Profit*Point),NULL,magic,0,Green)>0)
                    {
                     Print("Order Buy Send Succssfully");
                    }
                  else
                    {
                     Print("ERROR in Buy order"+GetLastError());

                    }
                 }
               else
                 {
                  Print("Buy Order Already Placed");
                 }

              }
           }

        }
      if(ima1<ima3 && ima2<ima3)
        {
         Print("Complex IF 1");
         if(ima1_1>=ima3_3 || ima2_2>=ima3_3)
           {
            Print("Complex IF 2");
            if(sto<50.0000)
              {

               if(s_count==0)
                 {
                  if(OrderSend(Symbol(),OP_SELL,lot_Size,Bid,3,Bid+(stop_Loss*Point),Bid-(take_Profit*Point),NULL,magic,0,Red)>0)
                    {
                     Print("Order SELL Send Succssfully");
                    }
                  else
                    {
                     Print("ERROR in Buy order"+GetLastError());
                    }
                 }
               else
                 {
                  Print("Sell Order Already Placed");
                 }
              }
           }

        }
     }
///////////////////////////////////////-----------------------------Trailing Point-------------------------/////////////////////////////////////////////////
   for(int i=0;i<OrdersTotal();i++)
     {
      OrderSelect(i,SELECT_BY_POS);

      if(OrderMagicNumber()==magic)
        {
         Print("-------------------------MAGIC NUMBER----------------------");

         if(OrderType()==OP_BUY)
           {
            Print("--------------------BUY TYPE-----------------------");

            if((Ask-OrderOpenPrice())/Point>=trail_Point)
              {
               Print("-------------BUY-------------------");
               if((Ask-(trail_Point*Point))>OrderStopLoss())
                 {
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),Ask-(trail_Point*Point),OrderTakeProfit(),OrderExpiration(),clrBlueViolet)>0)
                    {
                     Print("BUY Order Modified");
                    }
                 }
              }
            //+------------------------------------------------------------------+
 
            //+------------------------------------------------------------------+

           }
         else if(OrderType()==OP_SELL)
           {

            Print("--------------------SELL TYPE-----------------------");

            if((OrderOpenPrice()-Bid)/Point>=trail_Point)
              {
               printf("-------------SELL-------------------");
               if((Bid+(trail_Point*Point))<OrderStopLoss())
                 {
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),Bid+(trail_Point*Point),OrderTakeProfit(),OrderExpiration(),clrBlueViolet)>0)
                    {
                     Print("SELL Order Modified");
                    }
                 }
              }
            //+------------------------------------------------------------------+

            //+------------------------------------------------------------------+

           }
        }
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
