//+------------------------------------------------------------------+
//|                                                         dumy.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Script creates the button on the chart."
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                 Partial Close Order Setting                                               
//+------------------------------------------------------------------+

bool flag_close_check;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string text="ON";
//+------------------------------------------------------------------+
//|                           Init Function                          |
//+------------------------------------------------------------------+

int OnInit()
  {
   Print("Start");
   if(Button_Create())
     {
      Print("Button Created Succussfully");

     }
   else
     {
      Print("Button NOT Created Succussfully");

     }
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
   ObjectSetString(Symbol(),"button",OBJPROP_TEXT,text);
   button_press();
   Print("Flag Close Check is ",flag_close_check);

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
bool Button_Create()
  {
   if(!ObjectCreate(Symbol(),"button",OBJ_BUTTON,0,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create the button! Error code = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(Symbol(),"button",OBJPROP_XDISTANCE,200);
   ObjectSetInteger(Symbol(),"button",OBJPROP_YDISTANCE,100);
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
void button_press()
  {
   string clickedChartObject="button";
//--- If you click on the object with the name buttonID
   if(clickedChartObject=="button")
     {
      //--- State of the button - pressed or not
      bool selected=ObjectGetInteger(0,"button",OBJPROP_STATE);
      //--- log a debug message
      //  Print("Button pressed = ",selected);
      int customEventID; // Number of the custom event to send
      string message;    // Message to be sent in the event
      //--- If the button is pressed
      if(selected)
        {
         text="OFF";
         flag_close_check=true;
        }
      else // Button is not pressed
        {
         text="ON";
         flag_close_check=false;
        }
      //--- Send a custom event "our" chart
      //      EventChartCustom(0,customEventID-CHARTEVENT_CUSTOM,0,0,message);
      //    Print("Sent an event with ID = ",customEventID);
     }
  // ChartRedraw();// Forced redraw all chart objects

  }
//+------------------------------------------------------------------+
