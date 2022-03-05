/*
   ScaleIn.mqh

   Copyright 2013-2022, Orchard Forex
   https://www.orchardforex.com

   Functions to support the Scale In tutorial

*/

/**=
 *
 * Disclaimer and Licence
 *
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * All trading involves risk. You should have received the risk warnings
 * and terms of use in the README.MD file distributed with this software.
 * See the README.MD file for more information and before using this software.
 *
 **/

//	Has a new bar been opened
bool NewBar( string symbol = NULL, int timeframe = 0, bool initToNow = false ) {

   datetime        currentBarTime  = iTime( symbol, ( ENUM_TIMEFRAMES )timeframe, 0 );
   static datetime previousBarTime = initToNow ? currentBarTime : 0;
   if ( previousBarTime == currentBarTime ) return ( false );
   previousBarTime = currentBarTime;
   return ( true );
}

//	Are all trades for the symbol/magic/type in profit by minimum amount
#ifdef __MQL4__
bool IsPositionInMinimumProfit( string symbol, int magic, ENUM_ORDER_TYPE type, double minProfit ) {

   for ( int i = OrdersTotal() - 1; i >= 0; i-- ) {

      //	If any trade cannot be selected it is possible that this
      //		trade means no scaling, catch it next time
      if ( !OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) return ( false );

      if ( OrderSymbol() == symbol && OrderMagicNumber() == magic && OrderType() == type ) {
         if ( OrderProfit() < minProfit ) return ( false );
      }
   }

   return ( true );
}
#endif

#ifdef __MQL5__
bool IsPositionInMinimumProfit( string symbol, int magic, ENUM_ORDER_TYPE type, double minProfit ) {

   for ( int i = PositionsTotal() - 1; i >= 0; i-- ) {

      //	If any position cannot be selected it is possible that this
      //		trade means no scaling, catch it next time
      if ( !PositionInfo.SelectByIndex( i ) ) return ( false );

      if ( PositionInfo.Symbol() == symbol && PositionInfo.Magic() == magic &&
           PositionInfo.Type() == type ) {
         if ( PositionInfo.Profit() < minProfit ) return ( false );
      }
   }

   return ( true );
}
#endif