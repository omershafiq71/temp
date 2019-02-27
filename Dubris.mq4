//+------------------------------------------------------------------+
//|                                                       Dubris.mq4 |
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

enum EMASettings
  {
   ema,//---Exponential Moving Average---
  };
input EMASettings ma=ema;
input int EMA_Period=20;             //EMA Period
input int EMA_shift=0;       //EMA Shift
input  ENUM_APPLIED_PRICE EMA_applied_price=PRICE_CLOSE;  //EMA Applied Price
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum SMASettings
  {
   sma,//---Simple Moving Average---
  };

input SMASettings _ma=sma;
input int SMA_Period=20;             //SMA Period
input int SMA_Shift=0;            //SMA Shift
input  ENUM_APPLIED_PRICE SMA_applied_price=PRICE_CLOSE;  //SMA Applied Price
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum RSISettings
  {
   rsi,//---RSI--- 
  };
input RSISettings _rsi=rsi;
input int RSI_Period=4;           //RSI Period
input ENUM_APPLIED_PRICE RSI_AppliedPrice=PRICE_CLOSE;     //RSI Applied Price
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum GeneralSettings
  {
   generalSettings,//---General Settings--- 
  };
input GeneralSettings _general=generalSettings;
input int trailing_stop=15; // Trailing Stop Points/Pips
input int magicNumber=123;       //Magic Number
input double takeProfit = 500;      //Take Profit
input double stopLoss = 500;        //StopLose
input double lotSize=1;           //LotSize
input int Range=50;        //RSI Range

string Text;
datetime current;
//+------------------------------------------------------------------+
//|                  Trailing Point                      |
//+------------------------------------------------------------------+
void traling_stop_func()
  {
  Print("rfref");
   for(int i=1; i<=OrdersTotal(); i++) // Cycle searching in orders
     {
      if(OrderSelect(i-1,SELECT_BY_POS)==true)  // If the next is available
        {                                       // Analysis of orders:
         int Tip=OrderType();                   // Order type
         if((OrderSymbol()!=Symbol() || Tip>1) && (OrderMagicNumber()!=magicNumber))
            continue;// The order is not "ours"
         double SL=OrderStopLoss();             // SL of the selected order
         //----------------------------------------------------------------------
         double TP    =OrderTakeProfit();    // TP of the selected order
         double Price =OrderOpenPrice();     // Price of the selected order
         int    Ticket=OrderTicket();        // Ticket of the selected order
         double TS=trailing_stop;             // Initial value
         bool   Ans=False;
         //-------------------------------------------------------------------
         bool Modify=false;                  // Not to be modified
         switch(Tip)                         // By order type
           {
            case 0 :                         // Order Buy
               if(NormalizeDouble(SL,Digits)<// If it is lower than we want
                  NormalizeDouble(Bid-TS*Point,Digits) && (Bid>=(OrderOpenPrice()+TS*Point))) //
                 {
                  SL=Bid-TS*Point;           // then modify it
                  Text="Buy ";               // Text for Buy 
                  Ans=OrderModify(Ticket,Price,SL,TP,0,clrGreen);//Modify it!
                  Modify=true;               // To be modified
                 }
            break;                           // Exit 'switch'
            case 1 :                         // Order Sell
               if((NormalizeDouble(SL,Digits)>// If it is higher than we want
                  NormalizeDouble(Ask+TS*Point,Digits)
                  || (NormalizeDouble(SL,Digits)==0)) && (Ask<=(OrderOpenPrice()-TS*Point)))//or equal to zero
                 {
                  SL=Ask+TS*Point;           // then modify it
                  Text="Sell ";              // Text for Sell 
                  Ans=OrderModify(Ticket,Price,SL,TP,0,clrGreen);//Modify it!
                  Modify=true;               // To be modified
                 }
           }                                 // End of 'switch'
         if(Modify==false) // If it is not modified
            break;                           // Exit 'while'
         //-------------------------------------------------------------------
         if(Ans==true) // Got it! :)
           {
            Alert("Order ",Text,Ticket," is modified:)");
            break;                           // From modification cycle.
           }
         //-------------------------------------------------------------------      
         Print("Order Modify Error: "+GetLastError()); // Failed :(
         //----------------------------------------------------------------------
        }                                       // End of order analysis
     }
  }                                      // End of order search
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
   traling_stop_func();
   if(Time[0]!=current)
     {
      current=Time[0];

      double ema20= iMA(Symbol(),Period(),EMA_Period,EMA_shift,MODE_EMA,EMA_applied_price,1);
      double sma20= iMA(Symbol(),Period(),SMA_Period,SMA_Shift,MODE_SMA,EMA_applied_price,1);
      double prev_ema20=iMA(Symbol(),Period(),EMA_Period,EMA_shift,MODE_EMA,EMA_applied_price,2);
      //Print("Candle 2 Value of EMA10==========>>>>>>>>>>>>>>"+prev_ema20);
      double prev_sma20=iMA(Symbol(),Period(),SMA_Period,SMA_Shift,MODE_SMA,SMA_applied_price,2);
      //Print("Candle 2 Value of EMA21==========>>>>>>>>>>>>>>"+prev_sma20);
      double RSIValue=iRSI(Symbol(),Period(),RSI_Period,RSI_AppliedPrice,1);

      if(prev_ema20<=prev_sma20 && ema20>sma20)
        {
         //Print("Sell  Condition--------->>>>");
         // double RSIValue=iRSI(Symbol(),Period(),RSI_Period,RSI_AppliedPrice,1);
         // Print("----------------------------------->RSI Value for Buy: ------>"+RSIValue);
         if(RSIValue>Range)
           {
            if(OrderSend(Symbol(),OP_BUY,lotSize,Ask,5,Ask-(stopLoss*Point),Ask+(takeProfit*Point),NULL,magicNumber,0,clrBlue)<0)
              {
               Print("Order Could not send",GetLastError());
              }
           }
        }
      else if(prev_ema20>=prev_sma20 && ema20<sma20)
        {
         //Print("Buy COndition Meeet----------------------------->>>>>>s");
         //  Print("----------------------------------->RSI Value for Buy: ------>"+RSIValue);
         if(RSIValue<Range)
           {
            OrderSend(Symbol(),OP_SELL,lotSize,Bid,5,Bid+(stopLoss*Point),Bid-(takeProfit*Point),NULL,magicNumber,0,clrRed);
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

//+------------------------------------------------------------------+
