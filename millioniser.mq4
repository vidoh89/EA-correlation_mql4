//+------------------------------------------------------------------+
//|                                                  millioniser.mq4 |
//|                                                     Vince Dority |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Vince Dority"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//RSI Inputs
input int rsi_ma_period = 14;
input ENUM_TIMEFRAMES rsi_time =PERIOD_CURRENT;
//
input int buyST_static = 300;
input int sellST_static = 300;
input double lot_size = 0.05;
//Fractal inputs
input int fract_count = 3; 
//High/Low candle input for bar count
input int bar_count = 100;
//
//ma input
input int ma_period = 300;
input int ma_period_fast = 10;

//


//
//
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
   double balance = AccountBalance();
  if(correlationPairs()=="corePairs oversold" && OrdersTotal()==0 &&NewBar()=="YES,NEW BAR APPEARED" && Close[1]<=lowest()-100*Point && ma_ind_fast()<ma_ind() /*fract_ind()=="buy"*/){
   double buyTicket = OrderSend(_Symbol,OP_BUY,0.01,Ask,0,Bid -buyST_static*Point,Ask + 250*Point,"Null",0,0,clrGreen);
   }
   buyTrailStop();
   
  if(correlationPairs()=="corePairs overbought" && OrdersTotal()==0 && NewBar()=="YES,NEW BAR APPEARED" && Close[1]>=highest()+100*Point && ma_ind_fast()>ma_ind() /*fract_ind()=="sell"*/){
   double sellTicket = OrderSend(_Symbol,OP_SELL,0.01,Bid,0,Ask +sellST_static*Point,Bid -250*Point,"Null",0,0,clrRed);
  }

   sellTrailStop();
//---
   Comment(correlationPairs(),"\n","Balance",balance);
  }
//+------------------------------------------------------------------+

string correlationPairs(){
 double eur_usd = iRSI("EURUSD",rsi_time,rsi_ma_period ,PRICE_CLOSE,0);
 double gbp_usd = iRSI("GBPUSD",rsi_time,rsi_ma_period ,PRICE_CLOSE,0);
 double aud_usd = iRSI("AUDUSD",rsi_time,rsi_ma_period ,PRICE_CLOSE,0);
 double nzd_usd = iRSI("NZDUSD",rsi_time,rsi_ma_period ,PRICE_CLOSE,0);
  double usd_chf = iRSI("USDCHF",rsi_time,rsi_ma_period ,PRICE_CLOSE,0);



 string signal = "";
 if(eur_usd && gbp_usd /*&& aud_usd&&nzd_usd&&usd_chf*/>70){
  signal = "corePairs overbought";
  }
   else if(eur_usd && gbp_usd /*&& aud_usd && nzd_usd && usd_chf*/ < 30){
   signal ="corePairs oversold";
   
   }
   else{ signal="NoTrade";}
   
   return signal;
 
}

    //NewBar Function
string NewBar()
{
//New bar signal
string signal="";
///

//We create a static counter for the last number of bars
static int LastNumberOfBars;


//We create a string variable for the return value
string NewBarAppeared="no new bar";
///
///

//we check for the a differnece of the bar number
 for (LastNumberOfBars;Bars>LastNumberOfBars;LastNumberOfBars++)
{
if(Bars>LastNumberOfBars)



//We set the return value for new bars
 signal="YES,NEW BAR APPEARED";

//We set the cuttent number for last bars for the next time
LastNumberOfBars=Bars;

}
return signal;
/////////////end of New bar settings
}

string fract_ind(){
   string signal = "";
   
   double UpperFractalsValue = iFractals(_Symbol,_Period,MODE_UPPER,fract_count);
   double LowerFractalsValue = iFractals(_Symbol,_Period,MODE_LOWER,fract_count);
   
   //Bulls momentum
   if(LowerFractalsValue!=0)
   if(LowerFractalsValue<Low[1])
      {
      signal="buy";
      }
      //When it is going down
      if(UpperFractalsValue!=0)
      if(UpperFractalsValue>High[1])
         {
         signal="sell";
         }
         return signal;
}

void buyTrailStop(){
 //count orders
 for(int b = OrdersTotal()-1;b>=0;b--){
 //select one of the orders
   if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
   //Check if order matches current symbol on the chart
   if(OrderSymbol()==Symbol())
   //Check for buy position
   if(OrderType()==OP_BUY)
      {
       //If the stoploss is below x points
         if(OrderStopLoss()<Ask -(buyST_static*_Point))
         //We modify the stop loss
        double buyST = OrderModify(
            OrderTicket(),
            OrderOpenPrice(),
            Ask - (buyST_static* _Point),
            OrderTakeProfit(),
            0,
            clrGreen
         );
      }
 }
   
}

void sellTrailStop(){
   //count orders
   for(int b = OrdersTotal()-1;b>=0;b--){
      //select one of the orders
         if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
         //Check if order matches the current symbol
         if(OrderSymbol()==Symbol())
         //Check for sell position
         if(OrderType() == OP_SELL)
         {
            //If the stoploss is above x points
            if(OrderStopLoss()>Bid +(sellST_static*_Point))
            //We modify the stop loss
            double sellST = OrderModify(
               OrderTicket(),
               OrderOpenPrice(),
               Bid + (sellST_static*_Point),
               OrderTakeProfit(),
               0,
               clrRed
            );
         }
   }
}

double highest(){ 
//find the highest number of the last 100 bars
int HighestCandle = iHighest(_Symbol,_Period,MODE_HIGH,bar_count,0);

//Dele the line if it already exist
ObjectDelete("line");
//create an object
ObjectCreate("line",OBJ_HLINE,0,Time[0],High[HighestCandle]);
//Create a chart output

return HighestCandle;


}
double lowest(){
int LowestCandle = iLowest(_Symbol,_Period,MODE_LOW,bar_count,0);

//Dele the line if it already exist
ObjectDelete("Lline");
//create object
ObjectCreate("Lline",OBJ_HLINE,0,Time[0],Low[LowestCandle]);

return LowestCandle;
}
double ma_ind(){
 double MovingAverageSlow = iMA(_Symbol,PERIOD_CURRENT,ma_period,0,MODE_EMA,PRICE_CLOSE,0);
 
 return MovingAverageSlow;
}
double ma_ind_fast(){
 double MovingAverageFast = iMA(_Symbol,PERIOD_CURRENT,ma_period_fast,0,MODE_EMA,PRICE_CLOSE,0);

 return MovingAverageFast;
}