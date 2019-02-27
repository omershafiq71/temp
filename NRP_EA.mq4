//+------------------------------------------------------------------+
//|                                                       NRP_EA.mq4 |
//|                        Copyright 2018, Kenny Technologies Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, KENNY TECHNOLOGIES Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                EA Inputs                                                  |
//+------------------------------------------------------------------+
enum generalsettings
  {
   gnsettings,//--- General Settings --
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum break_Even
  {
   breakE,//--- Break Even Point Settings --

  };
input generalsettings general_settings=gnsettings; //--- NRP ---

input double lot_size=0.1;//Loat Size
input int stop_lost=200;//Stop Loss
input int take_profit=100;//Take profit
//+------------------------------------------------------------------+
//|                  BreakEven Point Input                                              |
//+------------------------------------------------------------------+

input break_Even bk=breakE; // Break Even Point
input int break_even_point_check=1;//Break Even Point Check
input int distance=50;//Distance To apply Break Even
input int lock_in_points=10; //Lock Points
input int magic=12345; //Magic Number
//+------------------------------------------------------------------+
//|                 Code Variables                                                 |
//+------------------------------------------------------------------+
bool flag=false; //To skip Orders on first tick
datetime current;
//string obj_name1;
int obj_total;
int new_arrow_count=0;
int old_arrow_count=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//input
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//--- create timer
   EventSetTimer(60);
   obj_total=ObjectsTotal(0,-1,-1);
   for(int i=0;i<ObjectsTotal();i++)
     {
      if(ObjectGetInteger(0,ObjectName(0,i),OBJPROP_ARROWCODE)==233 || ObjectGetInteger(0,ObjectName(0,i),OBJPROP_ARROWCODE)==234)
        {
         old_arrow_count++;
        }

     }
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
   NRP_func();
   break_even();
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
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
//|             ####  BREAK EVEN FUNCTION #####                                                     |
//+------------------------------------------------------------------+

void break_even()
  {
   if(break_even_point_check==1)
     {
      for(int i=0;i<OrdersTotal();i++)
        {
         OrderSelect(i,SELECT_BY_POS);
         if(OrderMagicNumber()==magic)
           {
            if(OrderType()==OP_BUY && (Ask-OrderOpenPrice())>Point*lock_in_points) //ahsan
              {
               if(OrderType()==OP_BUY)
                 {
                  if(((Ask-OrderOpenPrice())/Point>=distance) && OrderStopLoss()<OrderOpenPrice())
                    {
                     double num=OrderOpenPrice()+(lock_in_points*Point);
                     Print("-------------------Value of Srtop loss AT BUY IS "+num);
                     if(OrderModify(OrderTicket(),OrderOpenPrice(),num,OrderTakeProfit(),0,clrBlack)>0)
                       {
                        Print("**************************BUY Order Sucessfully Modified");
                       }
                    }
                 }
              }
            else if(OrderType()==OP_SELL && (OrderOpenPrice()-Bid)>(Point*lock_in_points))
              {
               if(((OrderOpenPrice()-Bid)/Point)>=distance && OrderStopLoss()>OrderOpenPrice())
                 {
                  double num=OrderOpenPrice()-(lock_in_points*Point);
                  Print("-------------------Value of Srtop loss AT SELL IS "+num);

                  if(OrderModify(OrderTicket(),OrderOpenPrice(),num,OrderTakeProfit(),0,clrBlack)>0)
                    {
                     Print("**************************************sell Order Sucessfully Modified");
                    }
                 }
              }

           }
        }
     }

  }

//+------------------------------------------------------------------+
//|              ########## NRP FUNCTION ###########                                                    |
//+------------------------------------------------------------------+
void NRP_func()
  {
   new_arrow_count=0;
   for(int i=0;i<ObjectsTotal();i++)
     {
      if(ObjectGetInteger(0,ObjectName(0,i),OBJPROP_ARROWCODE)==233 || ObjectGetInteger(0,ObjectName(0,i),OBJPROP_ARROWCODE)==234)
        {
         Print("Arrow code is ::::::::::::::::;"+ObjectGetInteger(0,ObjectName(0,i),OBJPROP_ARROWCODE));
         new_arrow_count++;
        }

     }
   Print("Total new arrow count----"+new_arrow_count);
   Print("Total OLD arrow count----"+old_arrow_count);
   if(new_arrow_count!=old_arrow_count)
     {
      if(obj_total!=ObjectsTotal(0,-1,-1))
        {
         old_arrow_count=new_arrow_count;
         Print("OLD Object Total   "+obj_total);
         obj_total=ObjectsTotal(0,-1,-1);
         Print("New Object Total   "+ObjectsTotal(0,-1,-1));

         string obj_name=ObjectName(ObjectsTotal(0,-1,-1)-1);
         int arrow_code=ObjectGetInteger(0,ObjectName(ObjectsTotal(0,-1,-1)-1),OBJPROP_ARROWCODE,0);
         Print("Arrow Code of New Objec"+obj_name+"  is  "+arrow_code);
         if(flag==true)
           {

            if(arrow_code==234)
              {

               if(OrderSend(Symbol(),OP_SELL,lot_size,Bid,5,Bid+(stop_lost*Point),Bid-(take_profit*Point),NULL,magic,0,Red)>0)
                 {
                  printf("sell has been done");
                 }
               else
                 {
                  Print("Sell could not be done ",GetLastError());
                 }
              }
            else if(arrow_code==233)
              {

               if(OrderSend(Symbol(),OP_BUY,lot_size,Ask,5,Ask-(stop_lost*Point),Ask+(take_profit*Point),NULL,magic,0,Green)>0)
                 {
                  printf(" Buy Order has been placed");
                 }
               else
                 {
                  Print("Buy could not be done ",GetLastError());
                 }
              }
           }
         flag=true;
        }
     }

  }
//+------------------------------------------------------------------+
