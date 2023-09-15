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
  if(correlationPairs()=="corePairs oversold" && OrdersTotal()==0 &&NewBar()=="YES,NEW BAR APPEARED"){
   double buyTicket = OrderSend(_Symbol,OP_BUY,0.01,Ask,0,Bid -200*Point,Ask +300*Point,"Null",0,0,clrGreen);
   }
   
  if(correlationPairs()=="corePairs overbought" && OrdersTotal()==0 && NewBar()=="YES,NEW BAR APPEARED"){
   double sellTicket = OrderSend(_Symbol,OP_SELL,0.01,Bid,0,Ask +200*Point,Bid -300*Point,"Null",0,0,clrRed);
  }
//---
   Comment(correlationPairs(),"\n","Balance",balance);
  }
//+------------------------------------------------------------------+

string correlationPairs(){
 double eur_usd = iRSI("EURUSD",_Period,rsi_ma_period ,PRICE_CLOSE,0);
 double gbp_usd = iRSI("GBPUSD",_Period,rsi_ma_period ,PRICE_CLOSE,0);
 double aud_usd = iRSI("AUDUSD",_Period,rsi_ma_period ,PRICE_CLOSE,0);
 double nzd_usd = iRSI("NZDUSD",_Period,rsi_ma_period ,PRICE_CLOSE,0);
  double usd_chf = iRSI("USDCHF",_Period,rsi_ma_period ,PRICE_CLOSE,0);



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
