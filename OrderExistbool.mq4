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
   lot,//--- Lot Size Settings ---
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
enum closingOfOrders
  {
   closeOrder,//--- Closing Of Orders ---
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ExpiryDate
  {
   expiryDate,//--- Expiry Date ---
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
//|                                                                  |
//+------------------------------------------------------------------+
enum generalsettings
  {
   gnsettings,//--- General Settings --

  };
//+------------------------------------------------------------------+
//|                 LOT SIZE SETTING                                               
//+------------------------------------------------------------------+

input lotSizeSetting lotSize_settings1=lot; //Lot Size Setting
input bool fixed_lot_size=True; //EA Fixed lot size 
input double lot_size=0.01;//Lot Size
double lot=0.01*(AccountBalance()/3); // EA Lot  IF FLAG IS FALSE USE THIS
double actual_buy_lot=0.01;
double actual_sell_lot=0.01;
double actual_lot;
//+------------------------------------------------------------------+
//|                  HEDGING CRITERIA                                                
//+------------------------------------------------------------------+
input HedgingSetting hedge_settings=hedge; //Hedging Settings
input int max_hedging_position=100;// Max Hedging Positions
input int step_for_next_entry=500;//Step For Next Entery (in Points)
input double first_hedge_lot=1.0;// First Hedge Lot
input double next_hedge_lot=2.0;// Next Hedge Lot 
input int negative_step=1000;// Negative Step (in Points)
input bool flat_lot=false;// Flat Lot 
                          //IF TRUE DO NOT MULTIPLY AFTER N ORDER
input int N_Order=3;// N Order
int n_buy_order=0;
int n_sell_order=0;
//+------------------------------------------------------------------+
//|                  Target Profit                                                 
//+------------------------------------------------------------------+
input TargetProfit target_profit=Tprofit; //Target Profit
input bool fixed_profit_target=True; //Auto Target Profit
input double fixed_profit=5;//Fixed Profit IF FLAG IS TRUE
double percentage_target=fixed_profit*(AccountBalance()/5000);
double actual_tp=10;
//IF FLAG IS FALSE
//+------------------------------------------------------------------+
//|                 Closing Of Orders                                                
//+------------------------------------------------------------------+
input closingOfOrders closing_order=closeOrder; //Close Order Settings
input bool stop_order=False;//Auto Stop Order 
                            //IF TRUE DONT OPEN NEW ORDERS
//+------------------------------------------------------------------+
//|                 Expiry Date Seting                                               
//+------------------------------------------------------------------+
input ExpiryDate expiry_date=expiryDate; //Expiray Date
input datetime date;//Date for Expiry
//+------------------------------------------------------------------+
//|                 Pivot Variables                                  |
//+------------------------------------------------------------------+
input temp func=Floor; //Pivot Type
double Pivot;
input ENUM_TIMEFRAMES time=PERIOD_D1;//Time Frame for pivot
//+------------------------------------------------------------------+
//|                     General Setting                              |
//+------------------------------------------------------------------+
input generalsettings general_settings=gnsettings; //--- General Setting ---
input int magic=12345;
bool profit_check=false;

//+------------------------------------------------------------------+
//|                    Code Variables                                |
//+------------------------------------------------------------------+
bool flag_for_buy_first_step=false;//if true first buy order sequence is started
//---
bool flag_for_sell_first_step=false;//if true first sell order sequence is started
bool flag_basket_sequence=false;//if true squence for first basket is currently on going
//---
double first_buy_open_price=0;
double first_sell_open_price=0;
//---
int latest_OrderType=3;
datetime latest_Order_time;
datetime latest_buy_Order_time;
datetime latest_sell_Order_time;
//---
bool flag_latest_sell_history=false;//true if latest sell order is in history trades
bool flag_latest_buy_history=false; //true if latest buy order is in history trades
//---
int latest_sell_trade_index;//gives the index of latest sell trade
int latest_buy_trade_index;//gives the index of lates buy trade
int max_hedging_count=0;
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
   if(max_hedging_count<=max_hedging_position && stop_order==false)
     {
      Alert("New Backet Started");
      if(OrdersTotal()==0)
        {
         Print("Order are 0");
         flag_basket_sequence=false;
         n_buy_order=0;
         n_sell_order=0;
         flag_for_buy_first_step=false;
         flag_for_sell_first_step=false;
        }
   
      //+------------------------------------------------------------------+
      //|                       START                                           |
      //+------------------------------------------------------------------+
      if(flag_basket_sequence==false)
        {
         if(Ask>pivot_value())// for sequence where first trade is buy
           {
            if(OrderSend(Symbol(),OP_BUY,HedgingCriteria(0),Ask,3,0,0,NULL,magic,0,Green)>0)
              {
               OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
               first_buy_open_price=OrderOpenPrice();
               flag_basket_sequence=true;
               flag_for_buy_first_step=true;
               n_buy_order++;
               max_hedging_count++;
              }

           }
         //---

         else if(Bid<pivot_value())// for sequence where first trade is sell
           {
            if(OrderSend(Symbol(),OP_SELL,HedgingCriteria(1),Bid,3,0,0,NULL,magic,0,Red)>0)
              {
               OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
               first_sell_open_price=OrderOpenPrice();
               flag_basket_sequence=true;
               flag_for_sell_first_step=true;
               n_sell_order++;
               max_hedging_count++;

              }

           }
        }

      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      if(flag_for_buy_first_step==true)
        {
         buy_sequence();
        }
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      else if(flag_for_sell_first_step==true)
        {
         sell_sequence();
        }
      order_close();
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
//|                     Buy Sequence                                 |
//+------------------------------------------------------------------+
void buy_sequence()
  {
   latest_OrderType=3;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_for_buy_first_step==true)
     {
      Print("Buy Sequence started");
      Buy_Order_Latest();
      Sell_Order_Latest();
      if(latest_buy_Order_time>latest_sell_Order_time)
        {
         latest_OrderType=0;                               //latest order was of buy
        }
      else
        {
         latest_OrderType=1;                               //latest order was of sell
        }
      //-----------------------------------------------------------------------------------------------------------------------------------
      if(latest_OrderType==0)////////////////////////////ORDER BUY OR SELL        IN THIS CASE BUY ORDER////////////////////////////(I)
        {
         Buy_Order_Latest();
         //Print("Latest Order was ||||||||||||| buy with the time ",latest_buy_Order_time);
         // Print("Value of  flag latest buy history is",flag_latest_buy_history);
         if(flag_latest_buy_history==true)
           {
            if(OrderSelect(latest_buy_trade_index,SELECT_BY_POS,MODE_HISTORY)==true)////////////////////////////////////////////////////(a)
              {
               // Print("Order Buy is Selected from Previous Orders (a)");
              }
           }
         else if(flag_latest_buy_history==false)
           {
            if(OrderSelect(latest_buy_trade_index,SELECT_BY_POS,MODE_TRADES)==true)
              {
               //  Print("Order is Selected from Recent Orders (a)");
              }
           }
         if(((Ask-OrderOpenPrice())/Point)>=500)
           {
            //Print("Place Buy Order Here(a)");
            if(OrderSend(Symbol(),OP_BUY,HedgingCriteria(0),Ask,3,0,0,NULL,magic,0,Green)>0)
              {
               n_buy_order++;
               //  Print("N Buy is",n_buy_order);
               max_hedging_count++;

              }

           }
         else
           {
            //////////////////////////////////////SELL ORDER EXIST/////////////////////////
            if(SellOrderExist()==true)
              {
               Sell_Order_Latest();///////////////////////////////////////////////////////////////////////////////////////////////////////(b)
               if(flag_latest_sell_history==false)
                 {
                  if(OrderSelect(latest_sell_trade_index,SELECT_BY_POS,MODE_TRADES)==true)
                    {

                     //Print("Sell Ordered is Selected from Recent (b)");
                    }
                 }
               else if(flag_latest_sell_history==true)
                 {
                  if(OrderSelect(latest_sell_trade_index,SELECT_BY_POS,MODE_HISTORY)==true)
                    {
                     // Print("Sell Order is Slected from History (b)");
                    }

                 }
               if(((OrderOpenPrice()-Bid)/Point)>=500)
                 {
                  // Print("Sell Order Will be places here (b)");
                  if(OrderSend(Symbol(),OP_SELL,HedgingCriteria(1),Bid,3,0,0,NULL,magic,0,Red)>0)
                    {
                     n_sell_order++;
                     //   Print("N SELL ORDER",n_sell_order);
                     max_hedging_count++;

                    }

                 }

              }
            else if(SellOrderExist()==false)/////////////////////////////////////////////////////////////////////////////////////////////(c)
              {

               if(((first_buy_open_price-Bid)/Point)>=1000)
                 {

                  // Print("Place First ssell order here"); ////////////////////////////////First sale Order wil be placed here
                  if(OrderSend(Symbol(),OP_SELL,HedgingCriteria(1),Bid,3,0,0,NULL,magic,0,Red)>0)
                    {
                     n_sell_order++;
                     //  Print("N SELL ORDER",n_sell_order);
                     max_hedging_count++;

                    }

                 }
              }
           }
        }

      //-----------------------------------------------------------------------------------------------------------------------------------
      //-----------------------------------------------------------------------------------------------------------------------------------

      //-----------------------------------------------------------------------------------------------------------------------------------
      else if(latest_OrderType==1)//////////////////////////////////////////////////////////////////////////////////////(II)
        {
         Sell_Order_Latest();
         // Print("Latest Order was of sell with the time ",latest_sell_Order_time);
         if(flag_latest_sell_history==false)/////////////////////////////////////////////////////////////////////////////////////(C)
           {
            if(OrderSelect(latest_sell_trade_index,SELECT_BY_POS,MODE_TRADES)==true)
              {
               //Print("Sell Order is Selected from Recent(C)");
              }
           }
         else if(flag_latest_sell_history==true)
           {
            if(OrderSelect(latest_sell_trade_index,SELECT_BY_POS,MODE_HISTORY)==true)
              {
               //     Print("Sell Order IS Selected from History(C)");
              }
           }
         if(((OrderOpenPrice()-Bid)/Point)>=500)
           {
            //    Print("Sell Order Will be placed here(C)");
            if(OrderSend(Symbol(),OP_SELL,HedgingCriteria(1),Bid,3,0,0,NULL,magic,0,Red)>0)
              {
               n_sell_order++;
               //    Print("N SELL ORDER",n_sell_order);
               max_hedging_count++;

              }
           }
         else
           {
            Buy_Order_Latest();////////////////////////////////////////////////////////////////////////////////////////////////////(D)
            if(flag_latest_buy_history==true)
              {
               if(OrderSelect(latest_buy_trade_index,SELECT_BY_POS,MODE_HISTORY)==true)
                 {
                  //      Print("Buy Order is selected from History ( D )");
                 }
              }
            else if(flag_latest_buy_history==false)
              {
               if(OrderSelect(latest_buy_trade_index,SELECT_BY_POS,MODE_TRADES)==true)
                 {
                  //        Print("Buy Order is Selected from Recent ( D )");
                 }
              }
            if(((Ask-OrderOpenPrice())/Point)>=500)
              {
               if(OrderSend(Symbol(),OP_BUY,HedgingCriteria(0),Ask,3,0,0,NULL,magic,0,Green)>0)
                 {
                  n_buy_order++;
                  //    Print("N Buy is",n_buy_order);
                  max_hedging_count++;
                 }
              }
           }
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                     SELL ORDER FUNCTION                          |
//+------------------------------------------------------------------+
void Sell_Order_Latest()
  {
   flag_latest_sell_history=false;
   int sell_latest_recent=0;
   int sell_latest_from_history=0;
   bool sell_flag_recent=false;
   bool sell_flag_history=false;
   latest_sell_trade_index=0;
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
               sell_latest_recent=i;
               sell_flag_recent=true;
              }
           }

        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else
     {
      for(int i=0;i<OrdersHistoryTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
           {
            if(OP_SELL==OrderType())
              {
               sell_flag_history=true;
               sell_latest_from_history=i;
              }
           }

        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(sell_flag_recent==true && sell_flag_history==true)
     {
      if(OrderSelect(sell_latest_recent,SELECT_BY_POS,MODE_TRADES)==true && OrderSelect(sell_latest_from_history,SELECT_BY_POS,MODE_HISTORY)==true)
        {
         OrderSelect(sell_latest_recent,SELECT_BY_POS,MODE_TRADES);
         datetime sell_recent_time=OrderOpenTime();
         OrderSelect(sell_latest_from_history,SELECT_BY_POS,MODE_HISTORY);
         datetime sell_history_time=OrderOpenTime();
         if(sell_history_time>sell_recent_time)
           {
            // Print("Latest Sell from Histroy Order's Time is ==========>>>>",sell_history_time);
            latest_sell_trade_index=sell_latest_from_history;
            flag_latest_sell_history=true;
            latest_sell_Order_time=sell_history_time;
           }
         else
           {
            //Print("Latest Sell from Recent Order's Time is ==========>>>>",sell_recent_time);
            latest_sell_trade_index=sell_latest_recent;
            flag_latest_sell_history=false;
            latest_sell_Order_time=sell_recent_time;
           }
        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else if(sell_flag_recent==true)
     {
      if(OrderSelect(sell_latest_recent,SELECT_BY_POS,MODE_TRADES)==true)
        {

         //  Print("Latest Sell from Recent Order's Time is ==========>>>>",OrderOpenTime());
         latest_sell_trade_index=sell_latest_recent;
         flag_latest_sell_history=false;
         latest_sell_Order_time=OrderOpenTime();

        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else if(sell_flag_history==true)
     {
      if(OrderSelect(sell_latest_from_history,SELECT_BY_POS,MODE_HISTORY)==true)
        {
         // Print("Latest Sell from History Order's Time is ==========>>>>",OrderOpenTime());
         latest_sell_trade_index=sell_latest_from_history;
         flag_latest_sell_history=true;
         latest_sell_Order_time=OrderOpenTime();
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                        Buy Order Latest                          |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void Buy_Order_Latest()
  {
   flag_latest_buy_history=false;
   int buy_latest_recent=0;
   int buy_latest_from_history=0;
   bool flag_recent=false;
   bool flag_history=false;
   latest_buy_trade_index=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(OrdersTotal()>0)
     {
      Print("Buy Order in true for orders total");
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
           {
            //  Print("Buy Order latest is now selecting");
            if(OP_BUY==OrderType())
              {
               //  Print("Buy Order latest is selected");

               buy_latest_recent=i;
               flag_recent=true;
              }
           }

        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else
     {
      for(int i=0;i<OrdersHistoryTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
           {
            if(OP_BUY==OrderType())
              {
               flag_history=true;
               buy_latest_from_history=i;
              }
           }

        }
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(flag_recent==true && flag_history==true)
     {
      if(OrderSelect(buy_latest_recent,SELECT_BY_POS,MODE_TRADES)==true && OrderSelect(buy_latest_from_history,SELECT_BY_POS,MODE_HISTORY)==true)
        {
         OrderSelect(buy_latest_recent,SELECT_BY_POS,MODE_TRADES);
         datetime recent_time=OrderOpenTime();
         OrderSelect(buy_latest_from_history,SELECT_BY_POS,MODE_HISTORY);
         datetime history_time=OrderOpenTime();
         if(history_time>recent_time)
           {
            //Print("Latest Buy from history Order's Time is ==========>>>>",history_time);
            latest_buy_trade_index=buy_latest_from_history;
            flag_latest_buy_history=true;
            latest_buy_Order_time=history_time;
           }
         else
           {
            //    Print("Latest Buy from recent Order's Time is ==========>>>>",recent_time);
            latest_buy_trade_index=buy_latest_recent;
            flag_latest_buy_history=false;
            latest_buy_Order_time=recent_time;
           }
        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else if(flag_recent==true)
     {
      if(OrderSelect(buy_latest_recent,SELECT_BY_POS,MODE_TRADES)==true)
        {
         //  Print("Latest Buy from recent Order's Time is ==========>>>>",OrderOpenTime());
         latest_buy_trade_index=buy_latest_recent;
         latest_buy_Order_time=OrderOpenTime();
         flag_latest_buy_history=false;
        }

     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   else if(flag_history==true)
     {
      if(OrderSelect(buy_latest_from_history,SELECT_BY_POS,MODE_HISTORY)==true)
        {

         //    Print("Latest Buy from history Order's Time is ==========>>>>",OrderOpenTime());
         latest_buy_trade_index=buy_latest_from_history;
         flag_latest_buy_history=true;
         latest_buy_Order_time=OrderOpenTime();
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                       Buy Order Exist                            |
//+------------------------------------------------------------------+

bool BuyOrderExist()
  {
   bool flag_buy_order_exist=false;
   for(int i=0;i<OrdersTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY)
           {
            flag_buy_order_exist=true;
           }

        }

     }
   for(int i=0;i<OrdersHistoryTotal();i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
        {
         if(OrderType()==OP_BUY)
           {
            flag_buy_order_exist=true;
           }
        }

     }
   return flag_buy_order_exist;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                         SELL ORDER FUNCTION                      |
//+------------------------------------------------------------------+

bool SellOrderExist()
  {
   bool flag_sell_order_exist=false;
   for(int i=0;i<OrdersTotal();i++)

     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_SELL)
           {
            flag_sell_order_exist=true;
           }

        }

     }
   for(int i=0;i<OrdersHistoryTotal();i++)

     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
        {
         if(OrderType()==OP_SELL)
           {
            flag_sell_order_exist=true;
           }
        }

     }
   return flag_sell_order_exist;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                      Sell Sequence                                            |
//+------------------------------------------------------------------+
void sell_sequence()
  {
   Print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Sell Sequence Started!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
   if(flag_for_sell_first_step==true)
     {
      latest_OrderType=3;
      Buy_Order_Latest();
      Sell_Order_Latest();
      if(latest_buy_Order_time>latest_sell_Order_time)
        {
         latest_OrderType=0;                               //latest order was of buy
        }
      else
        {
         latest_OrderType=1;                               //latest order was of sell
        }
      //-----------------------------------------------------------------------------------------------------------------------------------
      if(latest_OrderType==1)
        {
         Sell_Order_Latest();
         Print("Latest Order was of sell with the time ",latest_sell_Order_time);
         if(flag_latest_sell_history==false)/////////////////////////////////////////////////////////////////////////////////////(C)
           {
            if(OrderSelect(latest_sell_trade_index,SELECT_BY_POS,MODE_TRADES)==true)
              {
               //  Print("Sell Order is Selected from Recent(C)");
              }
           }
         else if(flag_latest_sell_history==true)
           {
            if(OrderSelect(latest_sell_trade_index,SELECT_BY_POS,MODE_HISTORY)==true)
              {
               //  Print("Sell Order IS Selected from History(C)");
              }
           }
         if(((OrderOpenPrice()-Bid)/Point)>=500)
           {
            //     Print("Sell Order Will be placed here(C)");
            if(OrderSend(Symbol(),OP_SELL,HedgingCriteria(1),Bid,3,0,0,NULL,magic,0,Red)>0)
              {
               n_sell_order++;
               Print("N SELL ORDER",n_sell_order);
               max_hedging_count++;

              }
           }
         else/////////////////////////////////////////////////////////////////////////////////////////////////////////////////(E)
           {
            //////////////////////////////////////Buy ORDER EXIST/////////////////////////
            if(BuyOrderExist()==true)
              {
               Buy_Order_Latest();///////////////////////////////////////////////////////////////////////////////////////////////////////(b)
               if(flag_latest_buy_history==false)
                 {
                  if(OrderSelect(latest_buy_trade_index,SELECT_BY_POS,MODE_TRADES)==true)
                    {

                     // Print("Buy Ordered is Selected from Recent (b)");
                    }
                 }
               else if(flag_latest_buy_history==true)
                 {
                  if(OrderSelect(latest_buy_trade_index,SELECT_BY_POS,MODE_HISTORY)==true)
                    {
                     //       Print("Buy Order is Slected from History (b)");
                    }

                 }
               if(((Ask-OrderOpenPrice())/Point)>=500)
                 {
                  Print("Buy Order Will be places here (B)");
                  if(OrderSend(Symbol(),OP_BUY,HedgingCriteria(0),Ask,3,0,0,NULL,magic,0,Green)>0)
                    {
                     n_buy_order++;
                     //Print("N Buy is",n_buy_order);
                     max_hedging_count++;

                    }
                 }

              }
            else if(BuyOrderExist()==false)/////////////////////////////////////////////////////////////////////////////////////////////(f)
              {

               if(((Ask-first_sell_open_price)/Point)>=1000)
                 {
                  //    Print("Place First Buy order here (F)"); ////////////////////////////////First Buy Order wil be placed here

                  if(OrderSend(Symbol(),OP_BUY,HedgingCriteria(0),Ask,3,0,0,NULL,magic,0,Green)>0)
                    {
                     n_buy_order++;
                     // Print("N Buy is",n_buy_order);
                     max_hedging_count++;

                    }
                 }

              }
           }
        }
      //---
      //---
      //---
      //---
      //---

      else if(latest_OrderType==0)
        {
         Buy_Order_Latest();
         //     Print("Latest Order was buy with the time ",latest_buy_Order_time);
         if(flag_latest_buy_history==true)
           {
            if(OrderSelect(latest_buy_trade_index,SELECT_BY_POS,MODE_HISTORY)==true)////////////////////////////////////////////////////(a)
              {
               //  Print("Order Buy is Selected from Previous Orders (a)");
              }
           }
         else if(flag_latest_buy_history==false)
           {
            if(OrderSelect(latest_buy_trade_index,SELECT_BY_POS,MODE_TRADES)==true)
              {
               Print("Order is Selected from Recent Orders (a)");
              }
           }

         if(((Ask-OrderOpenPrice())/Point)>=500)
           {
            Print("Place Buy Order Here (a)");
            if(OrderSend(Symbol(),OP_BUY,HedgingCriteria(0),Ask,3,0,0,NULL,magic,0,Green)>0)
              {
               n_buy_order++;
               //  Print("N Buy is",n_buy_order);
               max_hedging_count++;

              }
           }
         else
           {
            Sell_Order_Latest();////////////////////////////////////////////////////////////////////////////////////////////////////(D)
            if(flag_latest_sell_history==true)
              {
               if(OrderSelect(latest_sell_trade_index,SELECT_BY_POS,MODE_HISTORY)==true)
                 {
                  // Print("sell Order is selected from History ( D )");
                 }
              }
            else if(flag_latest_sell_history==false)
              {
               if(OrderSelect(latest_sell_trade_index,SELECT_BY_POS,MODE_TRADES)==true)
                 {
                  //  Print("Sell Order is Selected from Recent ( D )");
                 }
              }
            if(((OrderOpenPrice()-Bid)/Point)>=500)
              {
               Print("Sell Order Will be places here ( D )");
               if(OrderSend(Symbol(),OP_SELL,HedgingCriteria(1),Bid,3,0,0,NULL,magic,0,Red)>0)
                 {
                  n_sell_order++;
                  //Print("N SELL ORDER",n_sell_order);
                  max_hedging_count++;

                 }

              }

           }
        }
     }
  }
//+------------------------------------------------------------------+
double HedgingCriteria(int l)
  {
   if(fixed_lot_size==false)
     {
      actual_lot=lot;
     }
   else if(fixed_lot_size==true)
     {
      actual_lot=lot_size;
     }
//////////////////////////////////////////////////////////////FOR BUY//////////////////////////////
   if(l==0)
     {
      if(n_buy_order<=1)
        {
         actual_buy_lot=actual_lot;
        }
      else if(n_buy_order!=1 && n_buy_order<N_Order)
        {
         actual_buy_lot=actual_lot*first_hedge_lot;
        }
      else if(n_buy_order==N_Order)
        {
         actual_buy_lot=actual_lot*next_hedge_lot;
        }
      else if(n_buy_order>N_Order)
        {
         if(flat_lot==false)
           {
            actual_buy_lot=actual_lot*next_hedge_lot;
           }
         else if(flat_lot==true)
           {
            actual_buy_lot=actual_lot;
           }
        }
      Print("latest Buy lot is ",actual_buy_lot);
      return actual_buy_lot;
     }

///////////////////////////////////////////////////FOR SELL////////////////////////////////////////
   if(l==1)
     {
      if(n_sell_order<=1)
        {
         actual_sell_lot=actual_lot;
        }
      else if(n_sell_order!=1 && n_sell_order<N_Order)
        {
         actual_sell_lot=actual_lot*first_hedge_lot;
        }
      else if(n_sell_order==N_Order)
        {
         actual_sell_lot=actual_lot*next_hedge_lot;
        }
      else if(n_sell_order>N_Order)
        {
         if(flat_lot==false)
           {
            actual_sell_lot=actual_lot*next_hedge_lot;
           }
         else if(flat_lot==true)
           {
            actual_sell_lot=actual_lot;
           }
        }
      Print("latest Sell lot is ",actual_sell_lot);
      return actual_sell_lot;
     }
   return actual_lot;

  }
//+------------------------------------------------------------------+
double Target_Profit()
  {
   actual_tp=fixed_profit;
   if(fixed_profit_target==true)
     {
      actual_tp=fixed_profit;
     }
   else if(fixed_profit_target==false)
     {
      actual_tp=percentage_target;
     }
   return actual_tp;
  }
//+------------------------------------------------------------------+
void order_close()
  {
   double current_profit=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      OrderSelect(i,SELECT_BY_POS);
      current_profit=current_profit+OrderProfit();
     }

   if(current_profit>=Target_Profit())
     {
      profit_check=true;
     }
   else
     {
      profit_check=false;

     }
   if(profit_check==true)
     {
      for(int j=OrdersTotal()-1;j>=0;j--)
        {
         if(OrderSelect(j,SELECT_BY_POS)==true)
           {
            Print("Selected Order is ",j,"Of Order Ticker",OrderTicket());
            if(OrderType()==OP_BUY)
              {
               OrderClose(OrderTicket(),OrderLots(),Bid,0,clrOrange);
              }
            else if(OrderType()==OP_SELL)
              {
               OrderClose(OrderTicket(),OrderLots(),Ask,0,clrOrange);
              }

            Print("Order been closed''''''''''''''''''''");
           }
        }

     }
  }
//+------------------------------------------------------------------+
