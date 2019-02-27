//+------------------------------------------------------------------+
//|                                                    juliuspeh.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Legacy EA."
#property link      "www.autofxacademy.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                   |
//+------------------------------------------------------------------+
enum lotSizeSetting
  {
   lot1,//--- Lot Size Settings ---
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum HedgingSetting
  {
   hedge,//--- Hedging Criteria ---
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum TargetProfit
  {
   Tprofit,//--- Target Profit ---
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum TargetLoss
  {
   Tloss,//--- Target Loss --

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum closingOfOrders
  {
   closeOrder,//--- Closing Of Orders ---
  };
//+------------------------------------------------------------------+
//|                  Pivot Point                                     |
//+------------------------------------------------------------------+
enum temp // Pivot Type
  {
   Floor,
   Woodie,
  };
//+------------------------------------------------------------------+
//|                  Simultaneous Setting                                             |
//+------------------------------------------------------------------+
enum simultaneoussettings
  {
   dual,//--- Simultaneous Buy and Sell Orders ---
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum maxhedgeposition
  {
   a=3,// 3
   b=5,// 5
   c=7,// 7
   d=9,// 9
  };
//+------------------------------------------------------------------+
//|                      SL ON TRADES                                            |
//+------------------------------------------------------------------+
enum SL_ON_TRADES
  {
   a1=4,// 4
   b1=6,// 6
   c1=8,// 8
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum FALSE_BUCKET
  {
   Loss_Amount,// Loss Amount 
   SL_Trailing,// SL Trailing
  };
//+------------------------------------------------------------------+
//|                      Target Loss Option                          |
//+------------------------------------------------------------------+
enum target_loss_option
  {
   amount_loss,//Loss Amount
   percentage_loss,//Loss Percentage
   trade_loss,//SL On Trades

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
enum LableColor
  {
   Lcolor,//--- Label Color ---
  };
//+------------------------------------------------------------------+
//|                 LOT SIZE SETTING                                               
//+------------------------------------------------------------------+

input lotSizeSetting lotSize_settings1=lot1; //Lot Size Setting
input bool fixed_lot_size=True; //EA Fixed lot size 
input double lot_size=0.1;//Lot Size
input double lot_size_increment=0.01;//Lot Size Increment
input double Account_Balance_Increment=100;//Account Balance Increment
double lot=lot_size; // EA Lot  IF FLAG IS FALSE USE THIS
double actual_buy_lot_buy_sequence=0.01;
double actual_sell_lot_buy_sequence=0.01;
double actual_lot_buy_Sequence;
int initial_balance=0.0;
double new_buy_lot_size_buy_sequence;
double new_sell_lot_size_buy_sequence;
//---
double actual_buy_lot_sell_sequence=0.01;
double actual_sell_lot_sell_sequence=0.01;
double actual_lot_sell_Sequence;
double new_buy_lot_size_sell_sequence;
double new_sell_lot_size_sell_sequence;
//---
double lot_buy=lot;
double lot_sell=lot;
//---
//+------------------------------------------------------------------+
//|                  HEDGING CRITERIA                                                
//+------------------------------------------------------------------+
input HedgingSetting hedge_settings=hedge; //Hedging Settings
int   max_hedging_position;// Max Hedging Positions
input maxhedgeposition maxhedge=a; //Max Hedging Positions
input int step_for_next_entry=500;//Step For Next Entery (in Points)
input double first_hedge_lot=1.0;// First Hedge Lot
input double next_hedge_lot=2.0;// Next Hedge Lot 
input int negative_step=1000;// Negative Step (in Points)
input bool flat_lot=false;// Flat Lot 
                          //IF TRUE DO NOT MULTIPLY AFTER N ORDER
input int N_Order=3;// N Order
int n_buy_order_buy_sequence=1;
int n_sell_order_buy_sequence=1;
//---
int n_buy_order_sell_sequence=1;
int n_sell_order_sell_sequence=1;
//+------------------------------------------------------------------+
//|                  Target Profit                                                 
//+------------------------------------------------------------------+
input TargetProfit target_profit=Tprofit; //Target Profit
input bool fixed_profit_target=True; //Auto Target Profit
input double fixed_profit=10;//Fixed Profit 
                             //IF FLAG IS TRUE
double percentage_target;
double actual_tp=10;
double total_profit_for_increment=0;
//IF FLAG IS FALSE

//+------------------------------------------------------------------+
//|                  Target Loss                                     |
//+------------------------------------------------------------------+
input TargetLoss target_loss=Tloss; //Target Loss
input target_loss_option loss_option=amount_loss;//Loss Option
input double loss_amount=0.0;//Loss Amount($)
input double loss_percent=0.00; //Stop Loss Percentage
input bool flag_close_on_loss=false;//Close EA on Loss Percent
double l_percent;
//+------------------------------------------------------------------+
//|                        SL on Trades  Variables                   |
//+------------------------------------------------------------------+
double bucket_stop_loss_buy_sequence=99;
double bucket_stop_loss_sell_sequence=99;
int order_type_buy_sequence=3;
int order_type_sell_sequence=3;
//+------------------------------------------------------------------+
//|                      SL ON TRADES OPTIONS                        |
//+------------------------------------------------------------------+
input SL_ON_TRADES new_sl_on_trad=a1; // SL on Trades 
input FALSE_BUCKET false_bucket=Loss_Amount; //False Bucket
//---
int total_orders_buy_sequence=0;
int num_buy_order_buy_sequence=0;
int num_sell_order_buy_sequence=0;
//---
int total_orders_sell_sequence=0;
int num_sell_order_sell_sequence=0;
int num_buy_order_sell_sequence=0;
//---
double open_latest_level_sell_buy_sequence;
double open_latest_level_buy_buy_sequence;
//---
double open_latest_level_sell_sell_sequence;
double open_latest_level_buy_sell_sequence;
//---
int new_latest_basket_order_buy_sequence=3;
int new_latest_basket_order_sell_sequence=3;
//---
int level_sell_sequence=0;
int level_buy_sequence=0;
//---
int count_4_buy_sequence=-1;
int count_4_sell_sequence=-1;
//---
bool flag_in_combination=false;
bool flag_in_combination_sell_sequence=false;
//---
int old_no_comb_num_sell_buy_sequence=0;
int old_no_comb_num_buy_buy_sequence=0;
//---
int new_no_comb_num_sell_buy_sequence=0;
int new_no_comb_num_buy_buy_sequence=0;
//---
int old_no_comb_num_sell_sell_sequence=0;
int old_no_comb_num_buy_sell_sequence=0;
//---
int new_no_comb_num_sell_sell_sequence=0;
int new_no_comb_num_buy_sell_sequence=0;
//---
int trigger_close_buy_sequence=3;
int trigger_close_sell_sequence=3;
//+------------------------------------------------------------------+
//|                 Closing Of Orders                                                
//+------------------------------------------------------------------+
input closingOfOrders closing_order=closeOrder; //Close Order Settings
input bool stop_order=False;//Auto Stop Order 
bool stop_order1=stop_order;
//IF TRUE DONT OPEN NEW ORDERS
//+------------------------------------------------------------------+
//|                 Expiry Date Seting                                               
//+------------------------------------------------------------------+
datetime gtime="2012.04.04"; //Expiry Date
datetime given_date;
int allert_day;
int allert_month;
int allert_year;
bool expiry_alert=false;
//+------------------------------------------------------------------+
//|                 Pivot Variables                                  |
//+------------------------------------------------------------------+
input temp func=Floor; //Pivot Type
double Pivot;
input ENUM_TIMEFRAMES time=PERIOD_D1;//Time Frame for pivot
//+------------------------------------------------------------------+
//|                 Simultaneous Setting                             |
//+------------------------------------------------------------------+
input simultaneoussettings simul=dual;//---Simultaneous Trading at Pivot
input bool flag_simultaneousTrading=false;// Allow Simultaneous Trading
//+------------------------------------------------------------------+
//|                     General Setting                              |
//+------------------------------------------------------------------+
input generalsettings general_settings=gnsettings; //--- General Setting ---
input int magic_for_sell_sequence=1234;// Magic Number of EA
input int magic_for_buy_sequence=1235;// Magic Number of EA

bool profit_check_buy_sequence=false;
bool profit_check_sell_sequence=false;

//+------------------------------------------------------------------+
//|                    Code Variables                                |
//+------------------------------------------------------------------+
bool flag_for_buy_first_step=false;//if true first buy order sequence is started
//---
bool flag_for_sell_first_step=false;//if true first sell order sequence is started
bool flag_basket_sequence=false;//if true squence for first basket is currently on going
//---
bool flag_basket_sequence_buy_sequence=false;//if true squence for first basket is currently on going
bool flag_basket_sequence_sell_sequence=false;//if true squence for first basket is currently on going

//---
double first_buy_open_price=0;
double first_sell_open_price=0;
//---
int latest_OrderType_buy_sequence=3;
int latest_OrderType_sell_sequence=3;
//---
datetime latest_Order_time_buy_sequence;
datetime latest_buy_Order_time_buy_sequence;
datetime latest_sell_Order_time_buy_sequence;
//---
datetime latest_Order_time_sell_sequence;
datetime latest_buy_Order_time_sell_sequence;
datetime latest_sell_Order_time_sell_sequence;
//---

//---
int latest_sell_trade_index_buy_sequence;//gives the index of latest sell trade      for buy sequence
int latest_buy_trade_index_buy_sequence;//gives the index of lates buy trade         for buy sequence
//---
int latest_sell_trade_index_sell_sequence;//gives the index of latest sell trade     for sell sequence
int latest_buy_trade_index_sell_sequence;//gives the index of lates buy trade        for sell sequence

int max_hedging_count_buy_sequence=0;
int max_hedging_count_sell_sequence=0;

double buy_sequence_array[9]={};
double sell_sequence_array[9]={};
//+------------------------------------------------------------------+
//|                       EA Name  Lable Initialization                                         |
//+------------------------------------------------------------------+
//---  parameters of the script
long              chart_ID=0;      // chart's ID
string            name="Label_name";             // label name
int               sub_window=0;            // subwindow index
int               x=30;                      // X coordinate
int               y=30;                      // Y coordinate
ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER; // chart corner for anchoring
string            text_label="Amplify EA";             // text
string            font="Arial";             // font
//+------------------------------------------------------------------+
//|                    Label color input                                              |
//+------------------------------------------------------------------+
int               font_size=10;             // font size
input LableColor  label_color=Lcolor; //Label Text Color
input color       InpColor=clrRed;//Text Color
double            angle=0.0;                // text slope
ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER; // anchor type
bool              back=false;               // in the background
bool              selection=false;          // highlight to move
bool              hidden=true;              // hidden in the object list
long              z_order=0;               // priority for mouse click
//+------------------------------------------------------------------+
//|                     Total Trades Label                          |
//+------------------------------------------------------------------+
string            name_label_trades="Label_trades";             // label name
string            text_label_trades="Orders Open :";             // text
int               x_trades_label=30;                      // X coordinate
int               y_trades_label=60;                      // Y coordinate

//+------------------------------------------------------------------+
//|                     Total buy Trades Label                          |
//+------------------------------------------------------------------+
string            name_label_trades_buy="Label_trades_buy";             // label name
string            text_label_trades_buy=" Buy";             // text
int               x_trades_label_buy=30;                      // X coordinate
int               y_trades_label_buy=90;                      // Y coordinate
//+------------------------------------------------------------------+
//|                     Total Sell Trades Label                          |
//+------------------------------------------------------------------+
string            name_label_trades_sell="Label_trades_sell";             // label name
string            text_label_trades_sell=" Sell";             // text
int               x_trades_label_sell=30;                      // X coordinate
int               y_trades_label_sell=120;                      // Y coordinate

//+------------------------------------------------------------------+
//|                      Total Profit Label                          |
//+------------------------------------------------------------------+
string            name_label_profit="Label_profit";             // label name
string            text_label_profit="P/L ($): $";             // text
int               x_profit_label=30;                      // X coordinate
int               y_profit_label=150;                      // Y coordinate
//+------------------------------------------------------------------+
//|                      Total History Profit Label                          |
//+------------------------------------------------------------------+
string            name_label_profit_history="Label_profit_history";             // label name
string            text_label_profit_history="Total Profits so far : $";             // text
int               x_profit_label_history=30;                      // X coordinate
int               y_profit_label_history=180;                      // Y coordinate

//+------------------------------------------------------------------+
//|               Total Trades and Total Profit         |
//+------------------------------------------------------------------+
int total_trades_buy=0;
int total_trades_sell=0;
float total_profit=0;
float total_profit_history=0;
string text="ON";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int check1=0;
int check2=0;
bool history_State=false;
bool selected=false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   max_hedging_position=maxhedge;
   Label_Create(name,text_label,x,y);
   Label_Create(name_label_trades,text_label_trades,x_trades_label,y_trades_label);
   Label_Create(name_label_trades_buy,text_label_trades_buy,x_trades_label_buy,y_trades_label_buy);
   Label_Create(name_label_trades_sell,text_label_trades_sell,x_trades_label_sell,y_trades_label_sell);

   Label_Create(name_label_profit,text_label_profit,x_profit_label,y_profit_label);
   Label_Create(name_label_profit_history,text_label_profit_history,x_profit_label_history,y_profit_label_history);

   Button_Create();
   initial_balance=AccountBalance();
   given_date=gtime;
   allert_day=TimeDay(given_date);
   allert_month=TimeMonth(given_date);
   allert_year=TimeYear(given_date);

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
   ObjectDelete("button");
   ObjectDelete("Label_name");
   ObjectDelete("Label_trades");
   ObjectDelete("Label_trades_buy");
   ObjectDelete("Label_trades_sell");
   ObjectDelete("Label_profit");
   ObjectDelete("Label_profit_history");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   Total_Trades_Profits();
   ObjectSetString(Symbol(),"button",OBJPROP_TEXT,text);
   button_press();

   if(stop_order1==false)
     {
      if(OrdersTotal()==0 && flag_simultaneousTrading==false)
        {
         for(int i=0;i<9;i++)
           {
            buy_sequence_array[i]=0;
            sell_sequence_array[i]=0;
           }
         old_no_comb_num_sell_buy_sequence=0;
         old_no_comb_num_buy_buy_sequence=0;
         old_no_comb_num_sell_sell_sequence=0;
         old_no_comb_num_buy_sell_sequence=0;
         trigger_close_buy_sequence=3;
         trigger_close_sell_sequence=3;
         level_buy_sequence=0;
         level_sell_sequence=0;
         flag_in_combination=true;
         flag_in_combination_sell_sequence=true;
         order_type_buy_sequence=3;
         order_type_sell_sequence=3;
         bucket_stop_loss_buy_sequence=99;
         bucket_stop_loss_sell_sequence=99;
         max_hedging_count_buy_sequence=1;
         max_hedging_count_sell_sequence=1;
         flag_basket_sequence=false;
         n_buy_order_buy_sequence=1;
         n_sell_order_buy_sequence=1;
         //---
         n_buy_order_sell_sequence=1;
         n_sell_order_sell_sequence=1;
         //---
         flag_for_buy_first_step=false;
         flag_for_sell_first_step=false;

         if(total_profit_for_increment>=Account_Balance_Increment || total_profit_for_increment<=-1*(Account_Balance_Increment))
           {
            int y=AccountBalance();
            int x=(y-initial_balance)/Account_Balance_Increment;
            lot=lot_size+NormalizeDouble((x*lot_size_increment),2);
            total_profit_for_increment=0;
           }
         percentage_target=fixed_profit*(AccountBalance()/initial_balance);
         l_percent=(loss_percent*AccountBalance())/100;
        }
      if(BuyOrderExistBuySequence()==false && SellOrderExistBuySequence()==false && flag_simultaneousTrading==true)
        {
         if(total_profit_for_increment>=Account_Balance_Increment || total_profit_for_increment<=-1*(Account_Balance_Increment))
           {
            int y=AccountBalance();
            int x=(y-initial_balance)/Account_Balance_Increment;
            lot_buy=lot_size+NormalizeDouble((x*lot_size_increment),2);
            total_profit_for_increment=0;
           }

         percentage_target=fixed_profit*(AccountBalance()/initial_balance);
         l_percent=(loss_percent*AccountBalance())/100;
         Print("------------------------------------Buy Seuqence Started---------------------------",HedgingCriteriaBuySequence(0));
         for(int i=0;i<9;i++)
           {
            buy_sequence_array[i]=0;
           }
         old_no_comb_num_sell_buy_sequence=0;
         old_no_comb_num_buy_buy_sequence=0;
         level_buy_sequence=0;
         flag_in_combination=true;
         trigger_close_buy_sequence=3;
         order_type_buy_sequence=3;
         bucket_stop_loss_buy_sequence=99;
         n_buy_order_buy_sequence=1;
         n_sell_order_buy_sequence=1;
         flag_for_buy_first_step=false;
         flag_basket_sequence=true;
         max_hedging_count_buy_sequence=1;
         if(OrderSend(Symbol(),OP_BUY,HedgingCriteriaBuySequence(0),Ask,5,0,0,NULL,magic_for_buy_sequence,0,Green)>0)
           {
            OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES);
            if(OrderMagicNumber()==magic_for_buy_sequence)
              {
               first_buy_open_price=OrderOpenPrice();
               buy_sequence_array[max_hedging_count_buy_sequence-1]=first_buy_open_price;
               flag_for_buy_first_step=true;
               n_buy_order_buy_sequence++;
               max_hedging_count_buy_sequence++;
              }
           }
        }
      if(BuyOrderExistSellSequence()==false && SellOrderExistSellSequence()==false && flag_simultaneousTrading==true)
        {
         if(total_profit_for_increment>=Account_Balance_Increment || total_profit_for_increment<=-1*(Account_Balance_Increment))
           {
            int y=AccountBalance();
            int x=(y-initial_balance)/Account_Balance_Increment;
            lot_sell=lot_size+NormalizeDouble((x*lot_size_increment),2);
            total_profit_for_increment=0;
           }
         percentage_target=fixed_profit*(AccountBalance()/initial_balance);
         l_percent=(loss_percent*AccountBalance())/100;
         Print("------------------------------------Sell Seuqence Started---------------------------");
         for(int i=0;i<9;i++)
           {
            sell_sequence_array[i]=0;
           }
         old_no_comb_num_sell_sell_sequence=0;
         old_no_comb_num_buy_sell_sequence=0;
         bucket_stop_loss_sell_sequence=99;
         trigger_close_sell_sequence=3;
         level_sell_sequence=0;
         flag_in_combination_sell_sequence=true;
         order_type_sell_sequence=3;
         n_buy_order_sell_sequence=1;
         n_sell_order_sell_sequence=1;
         flag_for_sell_first_step=false;
         flag_basket_sequence=true;
         max_hedging_count_sell_sequence=1;
         if(OrderSend(Symbol(),OP_SELL,HedgingCriteriaSellSequence(1),Bid,5,0,0,NULL,magic_for_sell_sequence,0,clrWhite)>0)
           {
            Print("First Order of Sell");
            OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES);
            if(OrderMagicNumber()==magic_for_sell_sequence)
              {
               first_sell_open_price=OrderOpenPrice();
               sell_sequence_array[max_hedging_count_sell_sequence-1]=first_sell_open_price;
               flag_for_sell_first_step=true;
               n_sell_order_sell_sequence++;
               max_hedging_count_sell_sequence++;
              }
           }
        }

      //+------------------------------------------------------------------+
      //|                       START                                      |
      //+------------------------------------------------------------------+
      if(flag_basket_sequence==false)
        {
         initialte();
        }
     }
//+------------------------------------------------------------------+
//|                      Buy Sequence                                |
//+------------------------------------------------------------------+
   if(max_hedging_count_buy_sequence<=max_hedging_position)
     {
      if(flag_for_buy_first_step==true)
        {
         buy_sequence();
        }
     }
//+------------------------------------------------------------------+
//|                      Sell Sequence                               |
//+------------------------------------------------------------------+
   if(max_hedging_count_sell_sequence<=max_hedging_position)
     {
      if(flag_for_sell_first_step==true)
        {
         sell_sequence();
        }
     }
   if(loss_option==trade_loss)
     {
      if(flag_in_combination==false)
        {
         if(false_bucket==Loss_Amount)
           {
            order_close_Buy_Sequence();
           }
         else if(false_bucket==SL_Trailing)
           {
            close_on_SLOnTrades_buy_sequence();
           }
        }

      if(flag_in_combination_sell_sequence==false)
        {
         if(false_bucket==Loss_Amount)
           {
            order_close_Sell_Sequence();
           }
         else if(false_bucket==SL_Trailing)
           {
            close_on_SLOnTrades_sell_sequence();

           }
        }

      if(flag_in_combination==true)
        {
         if(false_bucket==SL_Trailing)
           {
            if(bucket_stop_loss_buy_sequence!=99)
              {
               close_on_SLOnTrades_buy_sequence();
              }
           }
         else if(false_bucket==Loss_Amount)
           {
            order_close_Buy_Sequence();
           }
        }

      if(flag_in_combination_sell_sequence==true)
        {
         if(false_bucket==SL_Trailing)
           {
            if(bucket_stop_loss_sell_sequence!=99)
              {
               close_on_SLOnTrades_sell_sequence();
              }
           }
         else if(false_bucket==Loss_Amount)
           {
            order_close_Sell_Sequence();
           }
        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else
     {
      order_close_Buy_Sequence();
      order_close_Sell_Sequence();
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
double pivot_value()
  {
   if(func==Floor)
     {
      return((iHigh(Symbol(),time,1)+iLow(Symbol(),time,1)+iClose(Symbol(),time,1))/3);
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(func==Woodie)
     {
      return((iHigh(Symbol(),time,1)+iLow(Symbol(),time,1)+2*(iClose(Symbol(),time,1)))/4);
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else
     {
      return((iHigh(Symbol(),time,1)+iLow(Symbol(),time,1)+iClose(Symbol(),time,1))/3);
     }
  }
//+------------------------------------------------------------------+
//|                             Initialte                            |
//+------------------------------------------------------------------+
void initialte()
  {
  if(Bid>pivot_value())// for sequence where first trade is buy
     {
      if(OrderSend(Symbol(),OP_BUY,HedgingCriteriaBuySequence(0),Ask,5,0,0,NULL,magic_for_buy_sequence,0,Green)>0)
        {
         OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES);
         first_buy_open_price=OrderOpenPrice();
         buy_sequence_array[max_hedging_count_buy_sequence-1]=first_buy_open_price;
         flag_basket_sequence=true;
         flag_for_buy_first_step=true;
         n_buy_order_buy_sequence++;
         max_hedging_count_buy_sequence++;
        }

     }
//---

   if(Bid<pivot_value())// for sequence where first trade is sell
     {
      if(OrderSend(Symbol(),OP_SELL,HedgingCriteriaSellSequence(1),Bid,5,0,0,NULL,magic_for_sell_sequence,0,Red)>0)
        {
         OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES);
         first_sell_open_price=OrderOpenPrice();
         sell_sequence_array[max_hedging_count_sell_sequence-1]=first_sell_open_price;
         flag_basket_sequence=true;
         flag_for_sell_first_step=true;
         n_sell_order_sell_sequence++;
         max_hedging_count_sell_sequence++;

        }
     }

  }
//+------------------------------------------------------------------+
//|                     Buy Sequence                                 |
//+------------------------------------------------------------------+
void buy_sequence()
  {
//abuse_checker_buy_orders_buy_sequence();
   latest_OrderType_buy_sequence=3;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_for_buy_first_step==true)
     {
      Buy_Order_Latest();
      Sell_Order_Latest();

      if(latest_buy_Order_time_buy_sequence>latest_sell_Order_time_buy_sequence)
        {
         latest_OrderType_buy_sequence=0;                               //latest order was of buy
        }
      else
        {
         latest_OrderType_buy_sequence=1;                               //latest order was of sell
        }
      //-----------------------------------------------------------------------------------------------------------------------------------
      if(latest_OrderType_buy_sequence==0)////////////////////////////ORDER BUY OR SELL        IN THIS CASE BUY ORDER////////////////////////////(I)
        {
         Buy_Order_Latest();

         if(OrderSelect(latest_buy_trade_index_buy_sequence,SELECT_BY_POS,MODE_TRADES)==true)
           {
           }

         if(((Ask-OrderOpenPrice())/Point)>=step_for_next_entry)
           {
            if(OrderMagicNumber()==magic_for_buy_sequence)
              {
               if(OrderSend(Symbol(),OP_BUY,HedgingCriteriaBuySequence(0),Ask,5,0,0,NULL,magic_for_buy_sequence,0,Green)>0)
                 {
                  n_buy_order_buy_sequence++;
                  if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                    {
                     if(OrderMagicNumber()==magic_for_buy_sequence)
                       {
                        buy_sequence_array[max_hedging_count_buy_sequence-1]=OrderOpenPrice();
                        order_type_buy_sequence=OrderType();
                        new_latest_basket_order_buy_sequence=OrderType();
                        if(loss_option==trade_loss)
                          {
                           SL_Trades_buy_sequence();
                          }

                       }
                    }
                  max_hedging_count_buy_sequence++;

                 }
              }

           }
         else
           {
            //////////////////////////////////////SELL ORDER EXIST/////////////////////////
            if(SellOrderExistBuySequence()==true)
              {
               Sell_Order_Latest();///////////////////////////////////////////////////////////////////////////////////////////////////////(b)

               if(OrderSelect(latest_sell_trade_index_buy_sequence,SELECT_BY_POS,MODE_TRADES)==true)
                 {

                 }

               if(((OrderOpenPrice()-Bid)/Point)>=step_for_next_entry)
                 {
                  if(OrderMagicNumber()==magic_for_buy_sequence)
                    {
                     if(OrderSend(Symbol(),OP_SELL,HedgingCriteriaBuySequence(1),Bid,5,0,0,NULL,magic_for_buy_sequence,0,Red)>0)
                       {
                        n_sell_order_buy_sequence++;
                        if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                          {
                           if(OrderMagicNumber()==magic_for_buy_sequence)
                             {
                              buy_sequence_array[max_hedging_count_buy_sequence-1]=OrderOpenPrice();
                              order_type_buy_sequence=OrderType();
                              new_latest_basket_order_buy_sequence=OrderType();
                              if(loss_option==trade_loss)
                                {
                                 SL_Trades_buy_sequence();
                                }

                             }
                          }
                        max_hedging_count_buy_sequence++;
                       }
                    }

                 }

              }
            else if(SellOrderExistBuySequence()==false)/////////////////////////////////////////////////////////////////////////////////////////////(c)
              {

               if(((first_buy_open_price-Bid)/Point)>=negative_step)
                 {
                  if(OrderSend(Symbol(),OP_SELL,HedgingCriteriaBuySequence(1),Bid,5,0,0,NULL,magic_for_buy_sequence,0,Red)>0)
                    {
                     n_sell_order_buy_sequence++;

                     if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                       {
                        if(OrderMagicNumber()==magic_for_buy_sequence)
                          {
                           buy_sequence_array[max_hedging_count_buy_sequence-1]=OrderOpenPrice();
                           order_type_buy_sequence=OrderType();
                           new_latest_basket_order_buy_sequence=OrderType();
                           if(loss_option==trade_loss)
                             {
                              SL_Trades_buy_sequence();
                             }

                          }
                       }
                     max_hedging_count_buy_sequence++;
                    }

                 }
              }
           }
        }

      //-----------------------------------------------------------------------------------------------------------------------------------
      else if(latest_OrderType_buy_sequence==1)//////////////////////////////////////////////////////////////////////////////////////(II)
        {
         Sell_Order_Latest();

         if(OrderSelect(latest_sell_trade_index_buy_sequence,SELECT_BY_POS,MODE_TRADES)==true)
           {
           }

         if(((OrderOpenPrice()-Bid)/Point)>=step_for_next_entry)
           {
            if(OrderMagicNumber()==magic_for_buy_sequence)
              {
               if(OrderSend(Symbol(),OP_SELL,HedgingCriteriaBuySequence(1),Bid,5,0,0,NULL,magic_for_buy_sequence,0,Red)>0)
                 {
                  n_sell_order_buy_sequence++;

                  if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                    {
                     if(OrderMagicNumber()==magic_for_buy_sequence)
                       {
                        buy_sequence_array[max_hedging_count_buy_sequence-1]=OrderOpenPrice();
                        order_type_buy_sequence=OrderType();
                        new_latest_basket_order_buy_sequence=OrderType();
                        if(loss_option==trade_loss)
                          {
                           SL_Trades_buy_sequence();
                          }

                       }
                    }
                  max_hedging_count_buy_sequence++;
                 }
              }
           }
         else
           {
            Buy_Order_Latest();////////////////////////////////////////////////////////////////////////////////////////////////////(D)

            if(OrderSelect(latest_buy_trade_index_buy_sequence,SELECT_BY_POS,MODE_TRADES)==true)
              {
              }

            if(((Ask-OrderOpenPrice())/Point)>=step_for_next_entry)
              {
               if(OrderMagicNumber()==magic_for_buy_sequence)
                 {
                  if(OrderSend(Symbol(),OP_BUY,HedgingCriteriaBuySequence(0),Ask,5,0,0,NULL,magic_for_buy_sequence,0,Green)>0)
                    {
                     n_buy_order_buy_sequence++;

                     if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                       {
                        if(OrderMagicNumber()==magic_for_buy_sequence)
                          {
                           buy_sequence_array[max_hedging_count_buy_sequence-1]=OrderOpenPrice();
                           order_type_buy_sequence=OrderType();
                           new_latest_basket_order_buy_sequence=OrderType();
                           if(loss_option==trade_loss)
                             {
                              SL_Trades_buy_sequence();
                             }
                          }
                       }
                     max_hedging_count_buy_sequence++;
                    }
                 }
              }
           }
        }

     }
  }
//+------------------------------------------------------------------+
//|                     SELL ORDER FUNCTION                          |
//+------------------------------------------------------------------+
void Sell_Order_Latest()
  {

   int sell_latest_recent_buy_sequence=0;
   int sell_latest_recent_sell_sequence=0;

   bool sell_flag_recent_buy_sequence=false;
   bool sell_flag_recent_sell_sequence=false;
   latest_sell_trade_index_buy_sequence=0;
   latest_sell_trade_index_sell_sequence=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(OrdersTotal()>0)
     {
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
           {
            if(OP_SELL==OrderType())
              {
               if(OrderMagicNumber()==magic_for_buy_sequence)
                 {
                  sell_latest_recent_buy_sequence=i;
                  sell_flag_recent_buy_sequence=true;
                 }
               if(OrderMagicNumber()==magic_for_sell_sequence)
                 {
                  sell_latest_recent_sell_sequence=i;
                  sell_flag_recent_sell_sequence=true;
                 }
              }
           }

        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(sell_flag_recent_buy_sequence==true)
     {
      if(OrderSelect(sell_latest_recent_buy_sequence,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderMagicNumber()==magic_for_buy_sequence)
           {
            latest_sell_trade_index_buy_sequence=sell_latest_recent_buy_sequence;
            latest_sell_Order_time_buy_sequence=OrderOpenTime();

           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(sell_flag_recent_sell_sequence==true)
     {
      if(OrderSelect(sell_latest_recent_sell_sequence,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderMagicNumber()==magic_for_sell_sequence)
           {
            latest_sell_trade_index_sell_sequence=sell_latest_recent_sell_sequence;
            latest_sell_Order_time_sell_sequence=OrderOpenTime();
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                        Buy Order Latest                          |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void Buy_Order_Latest()
  {

   int buy_latest_recent_buy_sequence=0;
   int buy_latest_recent_sell_sequence=0;

// int buy_latest_from_history=0;
   bool flag_recent_buy_sequence=false;
   bool flag_recent_sell_sequence=false;

   latest_buy_trade_index_buy_sequence=0;
   latest_buy_trade_index_sell_sequence=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(OrdersTotal()>0)
     {
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
           {
            if(OP_BUY==OrderType())
              {
               if(OrderMagicNumber()==magic_for_buy_sequence)
                 {
                  buy_latest_recent_buy_sequence=i;
                  flag_recent_buy_sequence=true;
                 }

               if(OrderMagicNumber()==magic_for_sell_sequence)
                 {
                  buy_latest_recent_sell_sequence=i;
                  flag_recent_sell_sequence=true;

                 }
              }
           }
        }
      if(flag_recent_buy_sequence==true)
        {
         if(OrderSelect(buy_latest_recent_buy_sequence,SELECT_BY_POS,MODE_TRADES)==true)
           {
            if(OrderMagicNumber()==magic_for_buy_sequence)
              {
               latest_buy_trade_index_buy_sequence=buy_latest_recent_buy_sequence;
               latest_buy_Order_time_buy_sequence=OrderOpenTime();
              }
           }
        }
      if(flag_recent_sell_sequence==true)
        {
         if(OrderSelect(buy_latest_recent_sell_sequence,SELECT_BY_POS,MODE_TRADES)==true)
           {
            if(OrderMagicNumber()==magic_for_sell_sequence)
              {
               latest_buy_trade_index_sell_sequence=buy_latest_recent_sell_sequence;
               latest_buy_Order_time_sell_sequence=OrderOpenTime();
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                       Buy Order Exist                            |
//+------------------------------------------------------------------+

bool BuyOrderExistBuySequence()
  {
   bool flag_buy_order_exist_buy_sequence=false;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY)
           {
            if(OrderMagicNumber()==magic_for_buy_sequence)
              {
               flag_buy_order_exist_buy_sequence=true;
              }
           }

        }

     }

   return flag_buy_order_exist_buy_sequence;
  }
//---
bool BuyOrderExistSellSequence()
  {
   bool flag_buy_order_exist_sell_sequence=false;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY)
           {
            if(OrderMagicNumber()==magic_for_sell_sequence)
              {
               flag_buy_order_exist_sell_sequence=true;
              }
           }

        }

     }

   return flag_buy_order_exist_sell_sequence;
  }
//+------------------------------------------------------------------+
//|                         SELL ORDER FUNCTION                      |
//+------------------------------------------------------------------+

bool SellOrderExistBuySequence()
  {
   bool flag_sell_order_exist_buy_sequence=false;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_SELL)
           {
            if(OrderMagicNumber()==magic_for_buy_sequence)
              {
               flag_sell_order_exist_buy_sequence=true;
              }
           }

        }

     }

   return flag_sell_order_exist_buy_sequence;
  }
//---
bool SellOrderExistSellSequence()
  {
   bool flag_sell_order_exist_sell_sequence=false;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_SELL)
           {
            if(OrderMagicNumber()==magic_for_sell_sequence)
              {
               flag_sell_order_exist_sell_sequence=true;
              }
           }

        }

     }

   return flag_sell_order_exist_sell_sequence;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                      Sell Sequence                                            |
//+------------------------------------------------------------------+
void sell_sequence()
  {
   if(flag_for_sell_first_step==true)
     {
      latest_OrderType_sell_sequence=3;
      Buy_Order_Latest();
      Sell_Order_Latest();
      if(latest_buy_Order_time_sell_sequence>latest_sell_Order_time_sell_sequence)
        {
         latest_OrderType_sell_sequence=0;                               //latest order was of buy
        }
      else
        {
         latest_OrderType_sell_sequence=1;                               //latest order was of sell
        }
      //-----------------------------------------------------------------------------------------------------------------------------------
      if(latest_OrderType_sell_sequence==1)
        {
         Sell_Order_Latest();

         if(OrderSelect(latest_sell_trade_index_sell_sequence,SELECT_BY_POS,MODE_TRADES)==true)
           {
           }

         if(((OrderOpenPrice()-Bid)/Point)>=step_for_next_entry)
           {
            if(OrderMagicNumber()==magic_for_sell_sequence)
              {
               if(OrderSend(Symbol(),OP_SELL,HedgingCriteriaSellSequence(1),Bid,5,0,0,NULL,magic_for_sell_sequence,0,clrWhite)>0)
                 {
                  n_sell_order_sell_sequence++;
                  if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                    {
                     if(OrderMagicNumber()==magic_for_sell_sequence)
                       {
                        sell_sequence_array[max_hedging_count_sell_sequence-1]=OrderOpenPrice();

                        order_type_sell_sequence=OrderType();
                        new_latest_basket_order_sell_sequence=OrderType();
                        if(loss_option==trade_loss)
                          {
                           SL_Trades_sell_sequence();
                          }

                       }
                    }
                  max_hedging_count_sell_sequence++;
                 }
              }
           }
         else/////////////////////////////////////////////////////////////////////////////////////////////////////////////////(E)
           {
            //////////////////////////////////////Buy ORDER EXIST/////////////////////////
            if(BuyOrderExistSellSequence()==true)
              {
               Buy_Order_Latest();///////////////////////////////////////////////////////////////////////////////////////////////////////(b)

               if(OrderSelect(latest_buy_trade_index_sell_sequence,SELECT_BY_POS,MODE_TRADES)==true)
                 {

                 }

               if(((Ask-OrderOpenPrice())/Point)>=step_for_next_entry)
                 {
                  if(OrderMagicNumber()==magic_for_sell_sequence)
                    {
                     if(OrderSend(Symbol(),OP_BUY,HedgingCriteriaSellSequence(0),Ask,5,0,0,NULL,magic_for_sell_sequence,0,clrBlue)>0)
                       {
                        n_buy_order_sell_sequence++;
                        if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                          {
                           if(OrderMagicNumber()==magic_for_sell_sequence)
                             {
                              sell_sequence_array[max_hedging_count_sell_sequence-1]=OrderOpenPrice();
                              order_type_sell_sequence=OrderType();
                              new_latest_basket_order_sell_sequence=OrderType();
                              if(loss_option==trade_loss)
                                {
                                 SL_Trades_sell_sequence();
                                }

                             }
                          }
                        max_hedging_count_sell_sequence++;
                       }
                    }
                 }

              }
            else if(BuyOrderExistSellSequence()==false)/////////////////////////////////////////////////////////////////////////////////////////////(f)
              {

               if(((Ask-first_sell_open_price)/Point)>=negative_step)
                 {

                  if(OrderSend(Symbol(),OP_BUY,HedgingCriteriaSellSequence(0),Ask,5,0,0,NULL,magic_for_sell_sequence,0,clrBlue)>0)
                    {
                     n_buy_order_sell_sequence++;
                     if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                       {
                        if(OrderMagicNumber()==magic_for_sell_sequence)
                          {
                           sell_sequence_array[max_hedging_count_sell_sequence-1]=OrderOpenPrice();
                           order_type_sell_sequence=OrderType();
                           new_latest_basket_order_sell_sequence=OrderType();
                           if(loss_option==trade_loss)
                             {
                              SL_Trades_sell_sequence();
                             }

                          }
                       }
                     max_hedging_count_sell_sequence++;

                    }
                 }

              }
           }
        }
      else if(latest_OrderType_sell_sequence==0)
        {
         Buy_Order_Latest();

         if(OrderSelect(latest_buy_trade_index_sell_sequence,SELECT_BY_POS,MODE_TRADES)==true)
           {
           }

         if(((Ask-OrderOpenPrice())/Point)>=step_for_next_entry)
           {

            if(OrderMagicNumber()==magic_for_sell_sequence)
              {
               if(OrderSend(Symbol(),OP_BUY,HedgingCriteriaSellSequence(0),Ask,5,0,0,NULL,magic_for_sell_sequence,0,clrBlue)>0)
                 {
                  n_buy_order_sell_sequence++;
                  if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                    {
                     if(OrderMagicNumber()==magic_for_sell_sequence)
                       {
                        sell_sequence_array[max_hedging_count_sell_sequence-1]=OrderOpenPrice();
                        order_type_sell_sequence=OrderType();
                        new_latest_basket_order_sell_sequence=OrderType();
                        if(loss_option==trade_loss)
                          {
                           SL_Trades_sell_sequence();
                          }

                       }
                    }
                  max_hedging_count_sell_sequence++;
                 }
              }
           }
         else
           {
            Sell_Order_Latest();////////////////////////////////////////////////////////////////////////////////////////////////////(D)

            if(OrderSelect(latest_sell_trade_index_sell_sequence,SELECT_BY_POS,MODE_TRADES)==true)
              {
              }

            if(((OrderOpenPrice()-Bid)/Point)>=step_for_next_entry)
              {
               if(OrderMagicNumber()==magic_for_sell_sequence)
                 {
                  if(OrderSend(Symbol(),OP_SELL,HedgingCriteriaSellSequence(1),Bid,5,0,0,NULL,magic_for_sell_sequence,0,clrWhite)>0)
                    {
                     n_sell_order_sell_sequence++;
                     if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS,MODE_TRADES))
                       {
                        if(OrderMagicNumber()==magic_for_sell_sequence)
                          {
                           sell_sequence_array[max_hedging_count_sell_sequence-1]=OrderOpenPrice();
                           order_type_sell_sequence=OrderType();
                           new_latest_basket_order_sell_sequence=OrderType();
                           if(loss_option==trade_loss)
                             {
                              SL_Trades_sell_sequence();
                             }

                          }
                       }
                     max_hedging_count_sell_sequence++;
                    }
                 }

              }

           }
        }
     }
  }
//+------------------------------------------------------------------+
double HedgingCriteriaBuySequence(int l)
  {
   if(fixed_lot_size==false)
     {
      if(flag_simultaneousTrading==true)
        {
         actual_lot_buy_Sequence=lot_buy;
        }
      else if(flag_simultaneousTrading==false)
        {
         actual_lot_buy_Sequence=lot;
        }
     }
//+------------------------------------------------------------------+

   else if(fixed_lot_size==true)
     {
      actual_lot_buy_Sequence=lot_size;
     }
//////////////////////////////////////////////////////////////FOR BUY//////////////////////////////
   if(l==0)
     {
      if(n_buy_order_buy_sequence==1)
        {
         actual_buy_lot_buy_sequence=actual_lot_buy_Sequence;

        }
      if(N_Order==1)
        {
         return actual_lot_buy_Sequence;
        }
      if(N_Order==2 && n_buy_order_buy_sequence!=1)
        {
         return actual_lot_buy_Sequence*first_hedge_lot;

        }
      else if(n_buy_order_buy_sequence==2)
        {
         actual_buy_lot_buy_sequence=actual_lot_buy_Sequence*first_hedge_lot;
        }
      else if(n_buy_order_buy_sequence==3)
        {
         actual_buy_lot_buy_sequence=actual_lot_buy_Sequence*next_hedge_lot;
         new_buy_lot_size_buy_sequence=actual_buy_lot_buy_sequence;
        }
      else if(n_buy_order_buy_sequence>3 && n_buy_order_buy_sequence<=N_Order)
        {
         new_buy_lot_size_buy_sequence=(new_buy_lot_size_buy_sequence*next_hedge_lot);
         actual_buy_lot_buy_sequence=new_buy_lot_size_buy_sequence;
         return new_buy_lot_size_buy_sequence;

        }
      else if(n_buy_order_buy_sequence>N_Order)
        {
         if(flat_lot==true)
           {

            return new_buy_lot_size_buy_sequence;
           }
         else if(flat_lot==false)
           {
            new_buy_lot_size_buy_sequence=(actual_buy_lot_buy_sequence*next_hedge_lot);
            return new_buy_lot_size_buy_sequence;
           }
        }
      return actual_buy_lot_buy_sequence;
     }
///////////////////////////////////////////////////FOR SELL////////////////////////////////////////
   if(l==1)
     {
      if(n_sell_order_buy_sequence==1)
        {
         actual_sell_lot_buy_sequence=actual_lot_buy_Sequence;
        }
      if(N_Order==1)
        {
         return actual_lot_buy_Sequence;
        }
      if(N_Order==2 && n_sell_order_buy_sequence!=1)
        {
         return actual_lot_buy_Sequence*first_hedge_lot;
        }
      else if(n_sell_order_buy_sequence==2)
        {
         actual_sell_lot_buy_sequence=(actual_lot_buy_Sequence*first_hedge_lot);
        }

      else if(n_sell_order_buy_sequence==3)
        {
         actual_sell_lot_buy_sequence=(actual_lot_buy_Sequence*next_hedge_lot);
         new_sell_lot_size_buy_sequence=actual_sell_lot_buy_sequence;
        }
      else if(n_sell_order_buy_sequence>3 && n_sell_order_buy_sequence<=N_Order)
        {

         new_sell_lot_size_buy_sequence=(new_sell_lot_size_buy_sequence*next_hedge_lot);
         actual_sell_lot_buy_sequence=new_sell_lot_size_buy_sequence;
         return new_sell_lot_size_buy_sequence;

        }
      else if(n_sell_order_buy_sequence>N_Order)
        {
         if(flat_lot==true)
           {
            return new_sell_lot_size_buy_sequence;
           }
         else if(flat_lot==false)
           {
            new_sell_lot_size_buy_sequence=(actual_sell_lot_buy_sequence*next_hedge_lot);
            return new_sell_lot_size_buy_sequence;
           }
        }
      return actual_sell_lot_buy_sequence;
     }
   return actual_lot_buy_Sequence;

  }
//+------------------------------------------------------------------+
//|                         Hedging Criteria (II)                                         |
//+------------------------------------------------------------------+
double HedgingCriteriaSellSequence(int l)
  {
   if(fixed_lot_size==false)
     {
      if(flag_simultaneousTrading==true)
        {
         actual_lot_sell_Sequence=lot_sell;
        }
      else if(flag_simultaneousTrading==false)
        {
         actual_lot_sell_Sequence=lot;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else if(fixed_lot_size==true)
     {
      actual_lot_sell_Sequence=(lot_size);
     }
//////////////////////////////////////////////////////////////FOR BUY//////////////////////////////
   if(l==0)
     {
      if(n_buy_order_sell_sequence==1)
        {
         actual_buy_lot_sell_sequence=actual_lot_sell_Sequence;
        }
      if(N_Order==1)
        {
         return actual_lot_sell_Sequence;
        }
      if(N_Order==2 && n_buy_order_sell_sequence!=1)
        {
         return actual_lot_sell_Sequence*first_hedge_lot;
        }
      else if(n_buy_order_sell_sequence==2)
        {
         actual_buy_lot_sell_sequence=(actual_lot_sell_Sequence*first_hedge_lot);
        }
      else if(n_buy_order_sell_sequence==3)
        {
         actual_buy_lot_sell_sequence=(actual_lot_sell_Sequence*next_hedge_lot);
         new_buy_lot_size_sell_sequence=actual_buy_lot_sell_sequence;
        }
      else if(n_buy_order_sell_sequence>3 && n_buy_order_sell_sequence<=N_Order)
        {
         new_buy_lot_size_sell_sequence=(new_buy_lot_size_sell_sequence*next_hedge_lot);
         actual_buy_lot_sell_sequence=new_buy_lot_size_sell_sequence;
         return new_buy_lot_size_sell_sequence;

        }
      else if(n_buy_order_sell_sequence>N_Order)
        {
         if(flat_lot==true)
           {

            return new_buy_lot_size_sell_sequence;
           }
         else if(flat_lot==false)
           {
            new_buy_lot_size_sell_sequence=(actual_buy_lot_sell_sequence*next_hedge_lot);
            return new_buy_lot_size_sell_sequence;
           }
        }
      return actual_buy_lot_sell_sequence;
     }
///////////////////////////////////////////////////FOR SELL////////////////////////////////////////
   if(l==1)
     {
      if(n_sell_order_sell_sequence==1)
        {
         actual_sell_lot_sell_sequence=actual_lot_sell_Sequence;
        }
      if(N_Order==1)
        {
         return actual_lot_sell_Sequence;
        }
      if(N_Order==2 && n_sell_order_sell_sequence!=1)
        {
         return actual_lot_sell_Sequence*first_hedge_lot;
        }
      else if(n_sell_order_sell_sequence==2)
        {
         actual_sell_lot_sell_sequence=(actual_lot_sell_Sequence*first_hedge_lot);
        }

      else if(n_sell_order_sell_sequence==3)
        {
         actual_sell_lot_sell_sequence=(actual_lot_sell_Sequence*next_hedge_lot);
         new_sell_lot_size_sell_sequence=actual_sell_lot_sell_sequence;
        }
      else if(n_sell_order_sell_sequence>3 && n_sell_order_sell_sequence<=N_Order)
        {

         new_sell_lot_size_sell_sequence=(new_sell_lot_size_sell_sequence*next_hedge_lot);
         actual_sell_lot_sell_sequence=new_sell_lot_size_sell_sequence;
         return new_sell_lot_size_sell_sequence;

        }
      else if(n_sell_order_sell_sequence>N_Order)
        {
         if(flat_lot==true)
           {
            return new_sell_lot_size_sell_sequence;
           }
         else if(flat_lot==false)
           {
            new_sell_lot_size_sell_sequence=(actual_sell_lot_sell_sequence*next_hedge_lot);
            return new_sell_lot_size_sell_sequence;
           }
        }
      return actual_sell_lot_sell_sequence;
     }
   return actual_lot_sell_Sequence;

  }
//+------------------------------------------------------------------+
double Target_Profit()
  {
   actual_tp=(fixed_profit);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(fixed_profit_target==false)
     {
      actual_tp=(fixed_profit);
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else if(fixed_profit_target==true)
     {
      actual_tp=(percentage_target);
     }
   return actual_tp;
  }
//+------------------------------------------------------------------+
double Target_Loss()
  {
   if(loss_option==percentage_loss)
     {
      return l_percent;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else if(loss_option!=percentage_loss)
     {
      return loss_amount;
     }
   return l_percent;
  }
//+------------------------------------------------------------------+
//|                         Order Close Buy Sequence                 |
//+------------------------------------------------------------------+
void order_close_Buy_Sequence()
  {
   profit_check_buy_sequence=false;
   double current_profit=0;
//Print("/////////////////////////////////////////////////////////////");
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderMagicNumber()==magic_for_buy_sequence)
           {
            current_profit=current_profit+OrderProfit();
           }
        }
     }

   current_profit=NormalizeDouble(current_profit,2);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

   if(current_profit>=Target_Profit() || current_profit<=-1*(Target_Loss()))
     {
      flag_for_buy_first_step=false;
      profit_check_buy_sequence=true;
      total_profit_for_increment=total_profit_for_increment+current_profit;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else
     {
      profit_check_buy_sequence=false;

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(profit_check_buy_sequence==true)
     {

      for(int j=OrdersTotal()-1;j>=0;j--)
        {
         if(OrderSelect(j,SELECT_BY_POS)==true)
           {
            if(OrderMagicNumber()==magic_for_buy_sequence)
              {
               if(OrderType()==OP_BUY)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                 }
               else if(OrderType()==OP_SELL)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                 }
              }
           }
        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_close_on_loss==true && current_profit<=-1*(Target_Loss()))
     {
      Alert("Leagacy EA Clossed");
      stop_order1=true;
     }
  }
//+------------------------------------------------------------------+
//|                  Order Close Sell Sequence                       |
//+------------------------------------------------------------------+
void order_close_Sell_Sequence()
  {
   profit_check_sell_sequence=false;
   double current_profit=0;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderMagicNumber()==magic_for_sell_sequence)
           {
            current_profit=NormalizeDouble(current_profit+OrderProfit(),2);
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(current_profit>=Target_Profit() || current_profit<=-1*(Target_Loss()))
     {
      flag_for_sell_first_step=false;
      profit_check_sell_sequence=true;
      total_profit_for_increment=total_profit_for_increment+current_profit;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else
     {
      profit_check_sell_sequence=false;

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(profit_check_sell_sequence==true)
     {
      for(int j=OrdersTotal()-1;j>=0;j--)
        {
         if(OrderSelect(j,SELECT_BY_POS)==true)
           {
            if(OrderMagicNumber()==magic_for_sell_sequence)
              {
               if(OrderType()==OP_BUY)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                 }
               else if(OrderType()==OP_SELL)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                 }
              }
           }
        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_close_on_loss==true && current_profit<=-1*(Target_Loss()))
     {
      Alert("Leagacy EA Clossed");
      stop_order1=true;
     }
  }
//+------------------------------------------------------------------+
void expiry_announce()
  {
   int current_day=TimeDay(TimeCurrent());
   int current_month=TimeMonth(TimeCurrent());
   int current_year=TimeYear(TimeCurrent());
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(allert_month==3)
     {

      if(allert_day==31)
        {

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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else if(allert_day==31)
     {
      current_day=current_day+1;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(current_day==allert_day && current_month+1==allert_month && current_year==allert_year)
     {
      if(expiry_alert==false)
        {
         Alert("EA is going to be expired in 1 Month from today");
         expiry_alert=true;
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(current_day==allert_day && current_month==allert_month && current_year==allert_year)
     {
      stop_order1=true;
     }

  }
//+------------------------------------------------------------------+
bool Button_Create()
  {
   if(!ObjectCreate(Symbol(),"button",OBJ_BUTTON,0,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create the button! Error code = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(Symbol(),"button",OBJPROP_XDISTANCE,125);
   ObjectSetInteger(Symbol(),"button",OBJPROP_YDISTANCE,30);
//--- set button size
   ObjectSetInteger(Symbol(),"button",OBJPROP_XSIZE,100);
   ObjectSetInteger(Symbol(),"button",OBJPROP_YSIZE,40);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(Symbol(),"button",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
//--- set the text
   ObjectSetString(Symbol(),"button",OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(Symbol(),"button",OBJPROP_FONT,"Arail");
//--- set font size
   ObjectSetInteger(Symbol(),"button",OBJPROP_FONTSIZE,10);
//--- set text color
   ObjectSetInteger(Symbol(),"button",OBJPROP_COLOR,clrBlack);
//--- set background color
   ObjectSetInteger(Symbol(),"button",OBJPROP_BGCOLOR,clrWhite);
//--- set border color
   ObjectSetInteger(Symbol(),"button",OBJPROP_BORDER_COLOR,clrBlue);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(Symbol(),"button",OBJPROP_BACK,false);
//--- set button state
   ObjectSetInteger(Symbol(),"button",OBJPROP_STATE,false);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(Symbol(),"button",OBJPROP_SELECTABLE,false);
   ObjectSetInteger(Symbol(),"button",OBJPROP_SELECTED,false);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(Symbol(),"button",OBJPROP_HIDDEN,true);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(Symbol(),"button",OBJPROP_ZORDER,0);
//--- successful execution
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Total_Trades_Profits()
  {
   total_profit=0;
   total_trades_buy=0;
   total_trades_sell=0;
   total_profit_history=0;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderMagicNumber()==magic_for_buy_sequence)
           {
            if(OrderType()==OP_BUY)
              {
               total_profit=OrderProfit()+total_profit;
               total_trades_buy++;
              }
            if(OrderType()==OP_SELL)
              {
               total_profit=OrderProfit()+total_profit;
               total_trades_sell++;
              }
           }
         else if(OrderMagicNumber()==magic_for_sell_sequence)
           {
            if(OrderType()==OP_BUY)
              {
               total_profit=OrderProfit()+total_profit;
               total_trades_buy++;
              }
            if(OrderType()==OP_SELL)
              {
               total_profit=OrderProfit()+total_profit;
               total_trades_sell++;
              }
           }
        }
     }
   for(int i=0;i<OrdersHistoryTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
        {
         if(OrderMagicNumber()==magic_for_buy_sequence || OrderMagicNumber()==magic_for_sell_sequence)
           {
            total_profit_history=total_profit_history+OrderProfit();
           }
        }
     }
   ObjectSetString(Symbol(),name_label_profit,OBJPROP_TEXT,text_label_profit+total_profit);
   ObjectSetString(Symbol(),name_label_profit_history,OBJPROP_TEXT,text_label_profit_history+total_profit_history);
   ObjectSetString(Symbol(),name_label_trades_buy,OBJPROP_TEXT,total_trades_buy+text_label_trades_buy);
   ObjectSetString(Symbol(),name_label_trades_sell,OBJPROP_TEXT,total_trades_sell+text_label_trades_sell);

  }
//+------------------------------------------------------------------+
void button_press()
  {
//--- State of the button - pressed or not
   history_State=selected;
   selected=ObjectGetInteger(0,"button",OBJPROP_STATE);
//--- If the button is pressed

   if(selected)
     {
      if(history_State==false)
        {
         if(text=="ON")
           {
            Print("CHECKED");
            check1++;
            check2=0;
           }
         else if(text=="OFF")
           {
            check1=0;
            check2++;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else // Button is not pressed
     {
      if(history_State==true)
        {
         if(text=="ON")
           {
            Print("Not Checked");
            check1++;
            check2=0;
           }
         else if(text=="OFF")
           {
            check1=0;
            check2++;
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(check1==1)
     {
      int result=MessageBox("Do you want to close the EA?","EA Terminate",1);
      MessageBox("Do you want to close the EA?","EA Terminate",1);
      if(result==1)
        {
         stop_order1=true;
         text="OFF";
        }
      else if(result==2)
        {
         stop_order1=false;
         text="ON";
        }
      check1=0;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(check2==1)
     {

      int result=MessageBox("Do you want to Start the EA?","EA Start",1);
      if(result==1)
        {
         stop_order1=false;
         text="ON";
        }
      else if(result==2)
        {
         stop_order1=true;
         text="OFF";
        }
      check2=0;
     }

  }
//+------------------------------------------------------------------+
bool Label_Create(string name,string text_label,int x,int y)
  {
//--- reset the error value
   ResetLastError();
//--- create a text label
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text_label);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,InpColor);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|                     SLL On Trades Buy Sequence                                             |
//+------------------------------------------------------------------+

void SLonTrades_buy_sequence()
  {
   if(max_hedging_count_buy_sequence==max_hedging_position+1)
     {
      double last_order_price=buy_sequence_array[maxhedge-1];
      double greatest_distance=last_order_price-buy_sequence_array[0];
      if(greatest_distance<0)
        {
         greatest_distance=-1*greatest_distance;
        }
      int greatest_i=99;
      for(int i=0;i<maxhedge;i++)
        {
         double temp1=buy_sequence_array[i]-last_order_price;
         if(temp1<0)
           {
            temp1=-1*(temp1);
           }
         if(temp1>=greatest_distance)
           {
            greatest_distance=temp1;
            greatest_i=i;
           }
        }
      bucket_stop_loss_buy_sequence=buy_sequence_array[greatest_i];
      close_on_SLOnTrades_buy_sequence();

     }
  }
//+------------------------------------------------------------------+
//|              SL On Trades Sell Squence                           |
//+------------------------------------------------------------------+
void SLonTrades_sell_sequence()
  {
   if(max_hedging_count_sell_sequence==max_hedging_position+1)
     {
      double last_order_price=sell_sequence_array[maxhedge-1];

      double greatest_distance=last_order_price-sell_sequence_array[0];
      if(greatest_distance<0)
        {
         greatest_distance=-1*greatest_distance;
        }

      int greatest_i=99;
      for(int i=0;i<maxhedge;i++)
        {
         double temp1=sell_sequence_array[i]-last_order_price;
         if(temp1<0)
           {
            temp1=-1*(temp1);
           }
         if(temp1>=greatest_distance)
           {
            greatest_distance=temp1;
            greatest_i=i;
           }
        }
      bucket_stop_loss_sell_sequence=sell_sequence_array[greatest_i];
      close_on_SLOnTrades_sell_sequence();

     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                     Close SL Buy Sequence                        |
//+------------------------------------------------------------------+
void close_on_SLOnTrades_buy_sequence()
  {
   Print("Bucket SL is ",bucket_stop_loss_buy_sequence);
   Print("--------------------------------hala oya-------------------------------");
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(order_type_buy_sequence==0)
     {

      if(trigger_close_buy_sequence==2)
        {
         if(Bid>=bucket_stop_loss_buy_sequence)
           {
            for(int j=OrdersTotal()-1;j>=0;j--)
              {
               if(OrderSelect(j,SELECT_BY_POS)==true)
                 {
                  if(OrderMagicNumber()==magic_for_buy_sequence)
                    {
                     if(OrderType()==OP_BUY)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                       }
                     else if(OrderType()==OP_SELL)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                       }
                    }
                 }
              }
           }
        }
      else
        {

         if(Bid<=bucket_stop_loss_buy_sequence)
           {
            for(int j=OrdersTotal()-1;j>=0;j--)
              {
               if(OrderSelect(j,SELECT_BY_POS)==true)
                 {
                  if(OrderMagicNumber()==magic_for_buy_sequence)
                    {
                     if(OrderType()==OP_BUY)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                       }
                     else if(OrderType()==OP_SELL)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                       }
                    }
                 }
              }
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(order_type_buy_sequence==1)
     {
      if(trigger_close_buy_sequence==1)
        {
         if(Ask<=bucket_stop_loss_buy_sequence)
           {
            for(int j=OrdersTotal()-1;j>=0;j--)
              {
               if(OrderSelect(j,SELECT_BY_POS)==true)
                 {
                  if(OrderMagicNumber()==magic_for_buy_sequence)
                    {
                     if(OrderType()==OP_BUY)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                       }
                     else if(OrderType()==OP_SELL)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                       }
                    }
                 }
              }
           }
        }
      else if(Ask>=bucket_stop_loss_buy_sequence)
        {
         for(int j=OrdersTotal()-1;j>=0;j--)
           {
            if(OrderSelect(j,SELECT_BY_POS)==true)
              {
               if(OrderMagicNumber()==magic_for_buy_sequence)
                 {
                  if(OrderType()==OP_BUY)
                    {
                     OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                    }
                  else if(OrderType()==OP_SELL)
                    {
                     OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                    }
                 }
              }
           }
        }
     }

//+------------------------------------------------------------------+
//|                        Closs on TP                               |
//+------------------------------------------------------------------+
   profit_check_buy_sequence=false;
   double current_profit=0;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderMagicNumber()==magic_for_buy_sequence)
           {
            current_profit=current_profit+OrderProfit();
           }
        }
     }

   current_profit=NormalizeDouble(current_profit,2);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(current_profit>=Target_Profit())
     {
      flag_for_buy_first_step=false;
      profit_check_buy_sequence=true;
      total_profit_for_increment=total_profit_for_increment+current_profit;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else
     {
      profit_check_buy_sequence=false;

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(profit_check_buy_sequence==true)
     {

      for(int j=OrdersTotal()-1;j>=0;j--)
        {
         if(OrderSelect(j,SELECT_BY_POS)==true)
           {
            if(OrderMagicNumber()==magic_for_buy_sequence)
              {
               if(OrderType()==OP_BUY)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                 }
               else if(OrderType()==OP_SELL)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                 }
              }
           }
        }

     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|        Close SL SELL Sequence                                    
//+------------------------------------------------------------------+

void close_on_SLOnTrades_sell_sequence()
  {
   if(order_type_sell_sequence==0)
     {
      if(trigger_close_sell_sequence==2)
        {
         if(Bid>=bucket_stop_loss_sell_sequence)
           {
            for(int j=OrdersTotal()-1;j>=0;j--)
              {
               if(OrderSelect(j,SELECT_BY_POS)==true)
                 {
                  if(OrderMagicNumber()==magic_for_sell_sequence)
                    {
                     if(OrderType()==OP_BUY)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                       }
                     else if(OrderType()==OP_SELL)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                       }
                    }
                 }
              }
           }
        }
      else
        {
         if(Bid<=bucket_stop_loss_sell_sequence)
           {
            for(int j=OrdersTotal()-1;j>=0;j--)
              {
               if(OrderSelect(j,SELECT_BY_POS)==true)
                 {
                  if(OrderMagicNumber()==magic_for_sell_sequence)
                    {
                     if(OrderType()==OP_BUY)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                       }
                     else if(OrderType()==OP_SELL)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                       }
                    }
                 }
              }
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(order_type_sell_sequence==1)
     {
      if(trigger_close_sell_sequence==1)
        {
         if(Ask<=bucket_stop_loss_sell_sequence)
           {
            for(int j=OrdersTotal()-1;j>=0;j--)
              {
               if(OrderSelect(j,SELECT_BY_POS)==true)
                 {
                  if(OrderMagicNumber()==magic_for_sell_sequence)
                    {
                     if(OrderType()==OP_BUY)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                       }
                     else if(OrderType()==OP_SELL)
                       {
                        OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                       }
                    }
                 }
              }
           }
        }

      else if(Ask>=bucket_stop_loss_sell_sequence)
        {
         for(int j=OrdersTotal()-1;j>=0;j--)
           {
            if(OrderSelect(j,SELECT_BY_POS)==true)
              {
               if(OrderMagicNumber()==magic_for_sell_sequence)
                 {
                  if(OrderType()==OP_BUY)
                    {
                     OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                    }
                  else if(OrderType()==OP_SELL)
                    {
                     OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                    }
                 }
              }
           }
        }
     }
//+------------------------------------------------------------------+
//|                           Close on Profit                        |
//+------------------------------------------------------------------+
   profit_check_sell_sequence=false;
   double current_profit=0;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderMagicNumber()==magic_for_sell_sequence)
           {
            current_profit=NormalizeDouble(current_profit+OrderProfit(),2);
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(current_profit>=Target_Profit())
     {
      flag_for_sell_first_step=false;
      profit_check_sell_sequence=true;
      total_profit_for_increment=total_profit_for_increment+current_profit;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else
     {
      profit_check_sell_sequence=false;

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(profit_check_sell_sequence==true)
     {
      for(int j=OrdersTotal()-1;j>=0;j--)
        {
         if(OrderSelect(j,SELECT_BY_POS)==true)
           {
            if(OrderMagicNumber()==magic_for_sell_sequence)
              {
               if(OrderType()==OP_BUY)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Bid,5,clrOrange);
                 }
               else if(OrderType()==OP_SELL)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Ask,5,clrOrange);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                            Total Buy and sell                                      |
//+------------------------------------------------------------------+
void total_buy_sell_orders_Buy_Sequence()
  {
   num_buy_order_buy_sequence=0;
   num_sell_order_buy_sequence=0;
   total_orders_buy_sequence=0;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber()==magic_for_buy_sequence)
           {
            total_orders_buy_sequence++;
            if(OrderType()==OP_BUY)
              {
               num_buy_order_buy_sequence++;
              }
            else if(OrderType()==OP_SELL)
              {
               num_sell_order_buy_sequence++;
              }
           }
        }
     }

  }
//---
void total_buy_sell_Sell_Sequence()
  {
   num_buy_order_sell_sequence=0;
   num_sell_order_sell_sequence=0;
   total_orders_sell_sequence=0;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber()==magic_for_sell_sequence)
           {
            total_orders_sell_sequence++;
            if(OrderType()==OP_BUY)
              {
               num_buy_order_sell_sequence++;
              }
            else if(OrderType()==OP_SELL)
              {
               num_sell_order_sell_sequence++;
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                     SL ON BUY SEQUENCE                                             |
//+------------------------------------------------------------------+
void SL_Trades_buy_sequence()
  {
   double temp_openprice_for_sl=0;
   total_buy_sell_orders_Buy_Sequence();
   Print("SL_Trades buy sequence",total_orders_buy_sequence);
   Print("Value of Count ",count_4_buy_sequence);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(total_orders_buy_sequence==new_sl_on_trad-2)
     {
      if(new_sl_on_trad==4)
        {
         Print("2 orders has beem placed");
         if(num_buy_order_buy_sequence==1 && num_sell_order_buy_sequence==1)
           {
            Print("1 buy and 1 sell");
            count_4_buy_sequence=11;
            flag_in_combination=true;
           }
         else if(num_buy_order_buy_sequence==0 && num_sell_order_buy_sequence==2)
           {
            Print("0 buy and 2 sell");
            count_4_buy_sequence=2;
            flag_in_combination=true;
            if(new_latest_basket_order_buy_sequence==0)
              {
               Print("Place SL on Next BUY");
              }
           }
         else if(num_buy_order_buy_sequence==2 && num_sell_order_buy_sequence==0)
           {
            Print("2 buy and 0 sell");
            count_4_buy_sequence=20;
            flag_in_combination=true;
            if(new_latest_basket_order_buy_sequence==1)
              {
               Print("Place SL on Next Sell");
              }
           }
         else
           {
            flag_in_combination=false;
           }
        }
      else if(new_sl_on_trad==6)
        {
         Print("4 Orders has been placed");
         if(num_buy_order_buy_sequence==2 && num_sell_order_buy_sequence==2)
           {
            flag_in_combination=true;
            count_4_buy_sequence=11;
           }
         else if(num_buy_order_buy_sequence==1 && num_sell_order_buy_sequence==3)
           {
            count_4_buy_sequence=2;
            flag_in_combination=true;
            if(new_latest_basket_order_buy_sequence==0)
              {
               Print("Place SL on Next BUY");
              }
           }

         else if(num_buy_order_buy_sequence==3 && num_sell_order_buy_sequence==1)
           {
            Print("3 buy 1 sell");
            flag_in_combination=true;
            count_4_buy_sequence=20;
            if(new_latest_basket_order_buy_sequence==1)
              {
               Print("Place SL on Next Sell");
              }
           }
         else
           {
            flag_in_combination=false;

           }
        }
      else if(new_sl_on_trad==8)
        {
         if(num_buy_order_buy_sequence==3 && num_sell_order_buy_sequence==3)
           {
            count_4_buy_sequence=11;
            flag_in_combination=true;
           }
         else if(num_buy_order_buy_sequence==2 && num_sell_order_buy_sequence==4)
           {
            count_4_buy_sequence=2;
            flag_in_combination=true;
            if(new_latest_basket_order_buy_sequence==0)
              {
               Print("Place SL on Next BUY");
              }
           }
         else if(num_buy_order_buy_sequence==4 && num_sell_order_buy_sequence==2)
           {
            count_4_buy_sequence=20;
            flag_in_combination=true;
            if(new_latest_basket_order_buy_sequence==1)
              {
               Print("Place SL on Next Sell");
              }
           }
         else
           {
            flag_in_combination=false;
           }

        }
      else
        {
         Print("dfgdf");
         flag_in_combination=false;

        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if((count_4_buy_sequence==11 || count_4_buy_sequence==2 || count_4_buy_sequence==20) && total_orders_buy_sequence==new_sl_on_trad-1)
     {
      Print("Latest Order is",new_latest_basket_order_buy_sequence);
      if(new_latest_basket_order_buy_sequence==0 && (count_4_buy_sequence==11))
        {
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber()==magic_for_buy_sequence)
                 {
                  if(OrderType()==OP_SELL)
                    {
                     temp_openprice_for_sl=OrderOpenPrice();
                    }

                 }

              }

           }
         trigger_close_buy_sequence=1;
         Print("Place SL On Next Sell at ",(temp_openprice_for_sl-(step_for_next_entry*Point)));
         bucket_stop_loss_buy_sequence=(temp_openprice_for_sl-(step_for_next_entry*Point));
        }
      else if(new_latest_basket_order_buy_sequence==1 && (count_4_buy_sequence==20))
        {
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber()==magic_for_buy_sequence)
                 {
                  if(OrderType()==OP_SELL)
                    {
                     temp_openprice_for_sl=OrderOpenPrice();
                    }

                 }

              }

           }
         trigger_close_buy_sequence=1;
         Print("Place SL On Next Sell at ",(temp_openprice_for_sl-(step_for_next_entry*Point)));
         bucket_stop_loss_buy_sequence=(temp_openprice_for_sl-(step_for_next_entry*Point));
        }
      else if(new_latest_basket_order_buy_sequence==0 && (count_4_buy_sequence==2))
        {
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber()==magic_for_buy_sequence)
                 {
                  if(OrderType()==OP_BUY)
                    {
                     temp_openprice_for_sl=OrderOpenPrice();

                    }
                 }
              }
           }
         trigger_close_buy_sequence=2;
         Print("Place SL On Next Buy at ",temp_openprice_for_sl+(step_for_next_entry*Point));
         bucket_stop_loss_buy_sequence=temp_openprice_for_sl+(step_for_next_entry*Point);
        }
      else if(new_latest_basket_order_buy_sequence==1 && (count_4_buy_sequence==11))
        {
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber()==magic_for_buy_sequence)
                 {
                  if(OrderType()==OP_BUY)
                    {
                     temp_openprice_for_sl=OrderOpenPrice();

                    }
                 }
              }
           }
         trigger_close_buy_sequence=2;
         Print("Place SL On Next Buy at ",temp_openprice_for_sl+(step_for_next_entry*Point));
         bucket_stop_loss_buy_sequence=temp_openprice_for_sl+(step_for_next_entry*Point);
        }
      else
        {
         Print("fgdfg");
         flag_in_combination=false;

        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if((count_4_buy_sequence==11 || count_4_buy_sequence==2 || count_4_buy_sequence==20) && total_orders_buy_sequence==new_sl_on_trad)
     {
      int temp_n_sell=0;
      int temp_n_buy=0;
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderMagicNumber()==magic_for_buy_sequence)
              {
               if(OrderType()==OP_BUY)
                 {
                  temp_n_buy++;
                 }
               if(OrderType()==OP_SELL)
                 {
                  temp_n_sell++;
                 }
              }

           }

        }
      if(flag_in_combination==true)
        {
         if((temp_n_buy>temp_n_sell))
           {
            if((temp_n_buy-temp_n_sell)>1)
              {
               flag_in_combination=false;
              }
           }
         if((temp_n_buy<temp_n_sell))
           {
            if((temp_n_sell-temp_n_buy)>1)
              {
               flag_in_combination=false;
              }
           }
        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_in_combination==false)
     {
      Print("No7 combination");
      if(false_bucket==SL_Trailing)
        {
         Print("Num of sell orders are ",num_sell_order_buy_sequence);
         Print("Num of buy orders are ",num_buy_order_buy_sequence);
         if(num_sell_order_buy_sequence>num_buy_order_buy_sequence)
           {
            Print("Abuse from sell side");
            abuse_checker_sell_orders_buy_sequence();
            int temp_level=1;
            for(int i=0;i<OrdersTotal();i++)
              {
               if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(OrderMagicNumber()==magic_for_buy_sequence)
                    {
                     if(OrderType()==OP_SELL)
                       {
                        if(temp_level==level_buy_sequence)
                          {
                           open_latest_level_sell_buy_sequence=OrderOpenPrice();
                           Print("SL will be placed at ",open_latest_level_sell_buy_sequence);
                           bucket_stop_loss_buy_sequence=open_latest_level_sell_buy_sequence;
                          }
                        temp_level++;
                       }

                    }

                 }
              }

           }
         else if(num_buy_order_buy_sequence>num_sell_order_buy_sequence)
           {
            Print("Abuse from buy sidess");
            abuse_checker_buy_orders_buy_sequence();
            Print("old no num comb buy buy",old_no_comb_num_buy_buy_sequence);
            Print("Level buy sequence ",level_buy_sequence);
            int temp_level=1;
            for(int i=0;i<OrdersTotal();i++)
              {
               if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(OrderMagicNumber()==magic_for_buy_sequence)
                    {
                     if(OrderType()==OP_BUY)
                       {
                        if(temp_level==level_buy_sequence)
                          {
                           open_latest_level_buy_buy_sequence=OrderOpenPrice();
                           Print("SL will be placed at ",open_latest_level_buy_buy_sequence);
                           bucket_stop_loss_buy_sequence=open_latest_level_buy_buy_sequence;
                          }
                        //  old_no_comb_num_buy_buy_sequence=temp_level;
                        temp_level++;
                       }

                    }

                 }
              }

           }
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                      SL On Sell Sequence                         |
//+------------------------------------------------------------------+
void SL_Trades_sell_sequence()
  {
   double temp_openprice_for_sl=0;
   total_buy_sell_Sell_Sequence();
   Print("SL_Trades sell sequence",total_orders_sell_sequence);
   Print("Value of Count ",count_4_sell_sequence);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(total_orders_sell_sequence==new_sl_on_trad-2)
     {
      if(new_sl_on_trad==4)
        {
         Print("2 orders has beem placed");
         if(num_buy_order_sell_sequence==1 && num_sell_order_sell_sequence==1)
           {
            Print("1 buy and 1 sell");
            count_4_sell_sequence=11;
            flag_in_combination_sell_sequence=true;
           }
         else if(num_buy_order_sell_sequence==0 && num_sell_order_sell_sequence==2)
           {
            Print("0 buy and 2 sell");
            count_4_sell_sequence=2;
            flag_in_combination_sell_sequence=true;
            if(new_latest_basket_order_sell_sequence==0)
              {
               Print("Place SL on Next BUY");
              }
           }
         else if(num_buy_order_sell_sequence==2 && num_sell_order_sell_sequence==0)
           {
            Print("2 buy and 0 sell");
            count_4_sell_sequence==20;
            flag_in_combination_sell_sequence=true;
            if(new_latest_basket_order_sell_sequence==1)
              {
               Print("Place SL on Next Sell");
              }
           }
         else
           {
            flag_in_combination_sell_sequence=false;
           }
        }
      else if(new_sl_on_trad==6)
        {
         Print("4 Orders has been placed");
         if(num_buy_order_sell_sequence==2 && num_sell_order_sell_sequence==2)
           {
            flag_in_combination_sell_sequence=true;
            count_4_sell_sequence=11;
           }
         else if(num_buy_order_sell_sequence==1 && num_sell_order_sell_sequence==3)
           {
            count_4_sell_sequence=2;
            flag_in_combination_sell_sequence=true;
           }

         else if(num_buy_order_sell_sequence==3 && num_sell_order_sell_sequence==1)
           {
            Print("3 buy 1 sell");
            flag_in_combination_sell_sequence=true;
            count_4_sell_sequence=20;
           }
         else
           {
            flag_in_combination_sell_sequence=false;
           }
        }
      else if(new_sl_on_trad==8)
        {
         if(num_buy_order_sell_sequence==3 && num_sell_order_sell_sequence==3)
           {
            count_4_sell_sequence=11;
            flag_in_combination_sell_sequence=true;
           }
         else if(num_buy_order_sell_sequence==2 && num_sell_order_sell_sequence==4)
           {
            count_4_sell_sequence=2;
            flag_in_combination_sell_sequence=true;

           }
         else if(num_buy_order_sell_sequence==4 && num_sell_order_sell_sequence==2)
           {
            count_4_sell_sequence=20;
            flag_in_combination_sell_sequence=true;
           }
         else
           {
            flag_in_combination_sell_sequence=false;
           }

        }
      else
        {
         Print("dfgdf");
         flag_in_combination_sell_sequence=false;

        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if((count_4_sell_sequence==11 || count_4_sell_sequence==2 || count_4_sell_sequence==20) && total_orders_sell_sequence==new_sl_on_trad-1)
     {
      Print("Latest Order is",new_latest_basket_order_sell_sequence);
      if(new_latest_basket_order_sell_sequence==0 && (count_4_sell_sequence==11))
        {
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber()==magic_for_sell_sequence)
                 {
                  if(OrderType()==OP_SELL)
                    {
                     temp_openprice_for_sl=OrderOpenPrice();

                    }

                 }

              }

           }
         trigger_close_sell_sequence=1;
         Print("Place SL On Next Sell at ",(temp_openprice_for_sl-(step_for_next_entry*Point)));
         bucket_stop_loss_sell_sequence=(temp_openprice_for_sl-(step_for_next_entry*Point));
        }
      else if(new_latest_basket_order_sell_sequence==1 && (count_4_sell_sequence==20))
        {
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber()==magic_for_sell_sequence)
                 {
                  if(OrderType()==OP_SELL)
                    {
                     temp_openprice_for_sl=OrderOpenPrice();

                    }

                 }

              }

           }
         trigger_close_sell_sequence=1;
         Print("Place SL On Next Sell at ",(temp_openprice_for_sl-(step_for_next_entry*Point)));
         bucket_stop_loss_sell_sequence=(temp_openprice_for_sl-(step_for_next_entry*Point));
        }
      else if(new_latest_basket_order_sell_sequence==0 && (count_4_sell_sequence==2))
        {
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber()==magic_for_sell_sequence)
                 {
                  if(OrderType()==OP_BUY)
                    {
                     temp_openprice_for_sl=OrderOpenPrice();
                    }
                 }
              }
           }
         trigger_close_sell_sequence=2;
         Print("Place SL On Next Buy at ",temp_openprice_for_sl+(step_for_next_entry*Point));
         bucket_stop_loss_sell_sequence=(temp_openprice_for_sl+(step_for_next_entry*Point));
         Print("Buck sl is ",bucket_stop_loss_sell_sequence);
        }
      else if(new_latest_basket_order_sell_sequence==1 && (count_4_sell_sequence==11))
        {
         for(int i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderMagicNumber()==magic_for_sell_sequence)
                 {
                  if(OrderType()==OP_BUY)
                    {
                     temp_openprice_for_sl=OrderOpenPrice();

                    }
                 }
              }
           }
         trigger_close_sell_sequence=2;
         Print("Place SL On Next Buy at ",temp_openprice_for_sl+(step_for_next_entry*Point));
         bucket_stop_loss_sell_sequence=temp_openprice_for_sl+(step_for_next_entry*Point);
        }
      else
        {
         Print("fgdfg");
         flag_in_combination_sell_sequence=false;

        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if((count_4_sell_sequence==11 || count_4_sell_sequence==2 || count_4_sell_sequence==20) && total_orders_sell_sequence==new_sl_on_trad)
     {
      int temp_n_sell=0;
      int temp_n_buy=0;
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderMagicNumber()==magic_for_sell_sequence)
              {
               if(OrderType()==OP_BUY)
                 {
                  temp_n_buy++;
                 }
               if(OrderType()==OP_SELL)
                 {
                  temp_n_sell++;
                 }
              }

           }

        }
      if(flag_in_combination_sell_sequence==true)
        {
         if((temp_n_buy>temp_n_sell))
           {
            if((temp_n_buy-temp_n_sell)>1)
              {
               flag_in_combination_sell_sequence=false;
              }
           }
         if((temp_n_buy<temp_n_sell))
           {
            if((temp_n_sell-temp_n_buy)>1)
              {
               flag_in_combination_sell_sequence=false;
              }
           }
        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_in_combination_sell_sequence==false)
     {
      Print("No7 combination sell sequence");
      if(false_bucket==SL_Trailing)
        {
         Print("Num of sell orders are ",num_sell_order_sell_sequence);
         Print("Num of buy orders are ",num_buy_order_sell_sequence);
         if(num_sell_order_sell_sequence>num_buy_order_sell_sequence)
           {
            Print("Abuse from sell side");
            abuse_checker_sell_orders_sell_sequence();
            int temp_level=1;
            for(int i=0;i<OrdersTotal();i++)
              {
               if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(OrderMagicNumber()==magic_for_sell_sequence)
                    {
                     if(OrderType()==OP_SELL)
                       {
                        if(temp_level==level_sell_sequence)
                          {
                           open_latest_level_sell_sell_sequence=OrderOpenPrice();
                           Print("SL will be placed at ",open_latest_level_sell_sell_sequence);
                           bucket_stop_loss_sell_sequence=open_latest_level_sell_sell_sequence;
                          }
                        // old_no_comb_num_sell_sell_sequence=temp_level;
                        temp_level++;
                       }

                    }

                 }
              }

           }
         else if(num_buy_order_sell_sequence>num_sell_order_sell_sequence)
           {
            Print("Abuse from buy side");
            abuse_checker_buy_orders_sell_sequence();
            int temp_level=1;
            for(int i=0;i<OrdersTotal();i++)
              {
               if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(OrderMagicNumber()==magic_for_sell_sequence)
                    {
                     if(OrderType()==OP_BUY)
                       {
                        if(temp_level==level_sell_sequence)
                          {
                           open_latest_level_buy_sell_sequence=OrderOpenPrice();
                           Print("SL will be placed at ",open_latest_level_buy_sell_sequence);
                           bucket_stop_loss_sell_sequence=open_latest_level_buy_sell_sequence;
                          }
                        // old_no_comb_num_buy_sell_sequence=temp_level;
                        temp_level++;
                       }

                    }

                 }
              }

           }
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void abuse_checker_buy_orders_buy_sequence()
  {
   new_no_comb_num_buy_buy_sequence=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_in_combination==false)
     {
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderMagicNumber()==magic_for_buy_sequence && OrderType()==OP_BUY)
              {
               new_no_comb_num_buy_buy_sequence++;
              }
           }

        }
      if(new_no_comb_num_buy_buy_sequence!=old_no_comb_num_buy_buy_sequence)
        {
         old_no_comb_num_buy_buy_sequence=new_no_comb_num_buy_buy_sequence;
         level_buy_sequence++;
        }
     }

  }
//+------------------------------------------------------------------+
void abuse_checker_sell_orders_buy_sequence()
  {
   new_no_comb_num_sell_buy_sequence=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_in_combination==false)
     {
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderMagicNumber()==magic_for_buy_sequence && OrderType()==OP_SELL)
              {
               new_no_comb_num_buy_buy_sequence++;
              }
           }

        }
      if(new_no_comb_num_buy_buy_sequence!=old_no_comb_num_buy_buy_sequence)
        {
         level_buy_sequence++;
        }
     }

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                             Sell sequence                                     |
//+------------------------------------------------------------------+

void abuse_checker_buy_orders_sell_sequence()
  {
   new_no_comb_num_buy_sell_sequence=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_in_combination_sell_sequence==false)
     {
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderMagicNumber()==magic_for_sell_sequence && OrderType()==OP_BUY)
              {
               new_no_comb_num_buy_sell_sequence++;
              }
           }

        }
      if(new_no_comb_num_buy_sell_sequence!=old_no_comb_num_buy_sell_sequence)
        {
         old_no_comb_num_buy_sell_sequence=new_no_comb_num_buy_sell_sequence;
         level_sell_sequence++;
        }
     }

  }
//+------------------------------------------------------------------+
void abuse_checker_sell_orders_sell_sequence()
  {
   new_no_comb_num_sell_sell_sequence=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_in_combination_sell_sequence==false)
     {
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
           {
            if(OrderMagicNumber()==magic_for_sell_sequence && OrderType()==OP_SELL)
              {
               new_no_comb_num_buy_sell_sequence++;
              }
           }

        }
      if(new_no_comb_num_buy_sell_sequence!=old_no_comb_num_buy_sell_sequence)
        {
         level_sell_sequence++;
        }
     }

  }
//+------------------------------------------------------------------+
