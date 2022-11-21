//+------------------------------------------------------------------+
//|                                                      MultiLine   |
//|                                      Copyright 2022, Serenityz0  |
//|                                    https://github.com/Serenityz0 |
//+------------------------------------------------------------------+
#property copyright "Serenityz0"
#property link "https://github.com/Serenityz0"
#property version   "1.00"
#property description "Easily create trendlines and other objects\nTip: Hold down the Ctrl button to create objects continuously"
#property strict
#property indicator_chart_window
#property indicator_plots 0
#property script_show_inputs

#resource "\\Images\\line.bmp"
#resource "\\Images\\line2.bmp"
#resource "\\Images\\line3.bmp"
#resource "\\Images\\line4.bmp"
#resource "\\Images\\hLine.bmp"
#resource "\\Images\\hLine2.bmp"
#resource "\\Images\\hLine3.bmp"
#resource "\\Images\\hLine4.bmp"
#resource "\\Images\\line_s.bmp"
#resource "\\Images\\line_s2.bmp"
#resource "\\Images\\line_s3.bmp"
#resource "\\Images\\line_s4.bmp"
#resource "\\Images\\hLine_s.bmp"
#resource "\\Images\\hLine_s2.bmp"
#resource "\\Images\\hLine_s3.bmp"
#resource "\\Images\\hLine_s4.bmp"
#resource "\\Images\\vLine.bmp"
#resource "\\Images\\vLine2.bmp"
#resource "\\Images\\vLine3.bmp"
#resource "\\Images\\vLine4.bmp"
#resource "\\Images\\vLine_s.bmp"
#resource "\\Images\\vLine_s2.bmp"
#resource "\\Images\\vLine_s3.bmp"
#resource "\\Images\\vLine_s4.bmp"
#resource "\\Images\\box.bmp"
#resource "\\Images\\box_s.bmp"
#resource "\\Images\\boxF.bmp"
#resource "\\Images\\boxF_s.bmp"

enum HlineType {
   Full,
   Trend, //Drawing point to market live + Length
   TrendLenght //Length
};

enum LineType {
   Solid = STYLE_SOLID,
   Dash = STYLE_DASH,
   Dot = STYLE_DOT,
   DashDotDot = STYLE_DASHDOTDOT
};

//--- input parameters
input int LinesWidth = 1; //Lines Width
input LineType LinesType = Solid; //Lines Type
input HlineType HorizontalLineType = Trend; //Horizontal Line Type
input int HorizontalLineLength = 100; //Horizontal Line Lenght
input bool oneTimer = false; //Single timeframe objects
input bool LinesBack = false; //Draw objects on background
input group "Colors"
input color Color_0 = clrBlack;
input color Color_1 = clrBlue;
input color Color_2 = clrRed;
input color Color_3 = clrGreen;
input color Color_4 = clrGold;
input color Color_5 = clrNONE;
input color Color_6 = clrNONE;
input color Color_7 = clrNONE;
input color Color_8 = clrNONE;
input color Color_9 = clrNONE;

//Variables
string PREFIX = "MLINE";
int prefLen;
string imgs[10];
string imgs2[24];
string names[5];
int defX = 32;
int defY = 27;
int x = 5;
int btnWidth = 24;
color selectedClr = Color_0;
string Action = NULL;
int lastMouseState;
bool isDrawing = false;
string DrawingObjName;
int  DrawingMode;
int DrawnObjsCount = 0;

//+------------------------------------------------------------------+
int OnInit()
{
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   prefLen = StringLen(PREFIX);
   imgs[0] = "::Images\\line_s.bmp";
   imgs[1] = "::Images\\line.bmp";
   imgs[2] = "::Images\\hLine_s.bmp";
   imgs[3] = "::Images\\hLine.bmp";
   imgs[4] = "::Images\\vLine_s.bmp";
   imgs[5] = "::Images\\vLine.bmp";
   imgs[6] = "::Images\\box_s.bmp";
   imgs[7] = "::Images\\box.bmp";
   imgs[8] = "::Images\\boxF_s.bmp";
   imgs[9] = "::Images\\boxF.bmp";
   imgs2[0] = "::Images\\line_s.bmp";
   imgs2[1] = "::Images\\line.bmp";
   imgs2[2] = "::Images\\line_s2.bmp";
   imgs2[3] = "::Images\\line2.bmp";
   imgs2[4] = "::Images\\line_s3.bmp";
   imgs2[5] = "::Images\\line3.bmp";
   imgs2[6] = "::Images\\line_s4.bmp";
   imgs2[7] = "::Images\\line4.bmp";
   imgs2[8] = "::Images\\hLine_s.bmp";
   imgs2[9] = "::Images\\hLine.bmp";
   imgs2[10] = "::Images\\hLine_s2.bmp";
   imgs2[11] = "::Images\\hLine2.bmp";
   imgs2[12] = "::Images\\hLine_s3.bmp";
   imgs2[13] = "::Images\\hLine3.bmp";
   imgs2[14] = "::Images\\hLine_s4.bmp";
   imgs2[15] = "::Images\\hLine4.bmp";
   imgs2[16] = "::Images\\vLine_s.bmp";
   imgs2[17] = "::Images\\vLine.bmp";
   imgs2[18] = "::Images\\vLine_s2.bmp";
   imgs2[19] = "::Images\\vLine2.bmp";
   imgs2[20] = "::Images\\vLine_s3.bmp";
   imgs2[21] = "::Images\\vLine3.bmp";
   imgs2[22] = "::Images\\vLine_s4.bmp";
   imgs2[23] = "::Images\\vLine4.bmp";
   int counter = 0;
   for(int i=0; i<ArraySize(imgs)-1; i++) {
      string splitedName[];
      StringSplit(imgs[i], StringGetCharacter("\\", 0), splitedName);
      StringSplit(splitedName[1], StringGetCharacter(".", 0), splitedName);
      string name = PREFIX + "-" + splitedName[0];
      names[i/2] = name;
      ObjectCreate(0, name, OBJ_BITMAP_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, defY);
      if(i<6) {
         for(int a=1; a<=4; a++) {
            ObjectCreate(0, name+"|"+IntegerToString(a), OBJ_BITMAP_LABEL, 0, 0, 0);
            ObjectSetInteger(0, name+"|"+IntegerToString(a), OBJPROP_CORNER, CORNER_LEFT_LOWER);
            ObjectSetInteger(0, name+"|"+IntegerToString(a), OBJPROP_XDISTANCE, x);
            ObjectSetInteger(0, name+"|"+IntegerToString(a), OBJPROP_YDISTANCE, defY+(defY*a));
            ObjectSetInteger(0, name+"|"+IntegerToString(a), OBJPROP_ZORDER, 0);
            ObjectSetString(0, name+"|"+IntegerToString(a), OBJPROP_BMPFILE, 0, imgs2[counter]);
            ObjectSetString(0, name+"|"+IntegerToString(a), OBJPROP_BMPFILE, 1, imgs2[counter+1]);
            ObjectSetInteger(0, name+"|"+IntegerToString(a), OBJPROP_XSIZE, 1);
            counter += 2;
         }
      }
      ObjectSetInteger(0, name, OBJPROP_ZORDER, 1);
      x += defY;
      ObjectSetString(0, name, OBJPROP_BMPFILE, 0, imgs[i]);
      i++;
      ObjectSetString(0, name, OBJPROP_BMPFILE, 1, imgs[i]);
   }
   CreateBtn(Color_0);
   CreateBtn(Color_1);
   CreateBtn(Color_2);
   CreateBtn(Color_3);
   CreateBtn(Color_4);
   CreateBtn(Color_5);
   CreateBtn(Color_6);
   CreateBtn(Color_7);
   CreateBtn(Color_8);
   CreateBtn(Color_9);
   x += 10;
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
void CreateBtn(color cr)
{
   if(cr == clrNONE)
      return;
   string name = PREFIX + "-" + ColorToString(cr);
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, defY);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, btnWidth);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, btnWidth);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, cr);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 1);
   if(x == 86) {
      selectedClr = cr;
      ObjectSetInteger(0, name, OBJPROP_STATE, true);
   }
   x += defY;
}
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   return(rates_total);
}
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(id == CHARTEVENT_KEYDOWN) {
      if(sparam == "44") { //z
         Action = "box_s";
      }
      if(sparam == "45") { //x
         Action = "boxF_s";
      }
   }
   if(id == CHARTEVENT_OBJECT_CLICK) {
      //if object is created by this script          if the object is a bitmap label                            or              the object is a button
      if(StringSubstr(sparam, 0, prefLen) == PREFIX && (ObjectGetInteger(0, sparam, OBJPROP_TYPE) == OBJ_BITMAP_LABEL || ObjectGetInteger(0, sparam, OBJPROP_TYPE) == OBJ_BUTTON)) {
         string placeHolder[];
         StringSplit(sparam, StringGetCharacter("-", 0), placeHolder);
         string name = placeHolder[1];
         // if the objects name included "ine" as for "line" or "box" - this is to separate clicking on colors
         if(StringFind(name, "ine") != -1) {
            StringSplit(name, StringGetCharacter("|", 0), placeHolder);
            if(Action == NULL) {
               Action = name;
               for(int a=1; a<=4; a++)
                  ObjectSetInteger(0, PREFIX+"-"+name+"|"+IntegerToString(a), OBJPROP_XSIZE, 0);
               DrawingMode = 0;
            } else {
               if(ArraySize(placeHolder) > 1) {
                  if(DrawingMode != 0)
                     ObjectSetInteger(0, PREFIX + "-" + Action + "|" + IntegerToString(DrawingMode), OBJPROP_STATE, false);
                  DrawingMode = (int)placeHolder[1];
               } else {
                  if(DrawingMode != 0)
                     ObjectSetInteger(0, PREFIX + "-" + Action + "|" + IntegerToString(DrawingMode), OBJPROP_STATE, false);
                  DrawingMode = 0;
                  ChartSetInteger(0, CHART_MOUSE_SCROLL, true);
                  ObjectSetInteger(0, PREFIX + "-" + Action, OBJPROP_STATE, false);
                  for(int a=1; a<=4; a++)
                     ObjectSetInteger(0, PREFIX+"-"+name+"|"+IntegerToString(a), OBJPROP_XSIZE, 0);
                  if(Action != name) {
                     for(int a=1; a<=4; a++)
                        ObjectSetInteger(0, PREFIX+"-"+name+"|"+IntegerToString(a), OBJPROP_XSIZE, 0);
                     for(int a=1; a<=4; a++)
                        ObjectSetInteger(0, PREFIX+"-"+Action+"|"+IntegerToString(a), OBJPROP_XSIZE, 1);
                     Action = name;
                  } else {
                     Action = NULL;
                     for(int a=1; a<=4; a++)
                        ObjectSetInteger(0, PREFIX+"-"+name+"|"+IntegerToString(a), OBJPROP_XSIZE, 1);
                  }
               }
            }
         } else if(StringFind(name, "box") != -1) {
            if(Action == NULL)
               Action = name;
            else {
               ChartSetInteger(0, CHART_MOUSE_SCROLL, true);
               ObjectSetInteger(0, PREFIX + "-" + Action, OBJPROP_STATE, false);
               if(Action != name) {
                  if(StringFind(Action, "ine") != -1) {
                     for(int a=1; a<=4; a++)
                        ObjectSetInteger(0, PREFIX+"-"+Action+"|"+IntegerToString(a), OBJPROP_XSIZE, 1);
                  }
                  Action = name;
               } else
                  Action = NULL;
            }
         } else {
            color newClr = (color)ObjectGetInteger(0, sparam, OBJPROP_BGCOLOR);
            if(newClr != selectedClr) {
               ObjectSetInteger(0, PREFIX + "-" + ColorToString(selectedClr), OBJPROP_STATE, false);
               selectedClr = newClr;
               ObjectSetInteger(0, PREFIX + "-" + ColorToString(selectedClr), OBJPROP_STATE, true);
            }
         }
      }
      ChartRedraw();
   } else if(Action != NULL && id == CHARTEVENT_MOUSE_MOVE) {
      int mouseState = (int)sparam;
      if(lastMouseState == 8 && mouseState == 0) {
         ChartSetInteger(0, CHART_MOUSE_SCROLL, true);
         ObjectSetInteger(0, PREFIX + "-" + Action, OBJPROP_STATE, false);
         if(StringFind(Action, "ine") != -1) {
            ObjectSetInteger(0, PREFIX + "-" + Action + "|" + IntegerToString(DrawingMode), OBJPROP_STATE, false);
            for(int a=1; a<=4; a++)
               ObjectSetInteger(0, PREFIX+"-"+Action+"|"+IntegerToString(a), OBJPROP_XSIZE, 1);
         }
         Action = NULL;
         ChartRedraw();
      }
      if(isDrawing) {
         if(mouseState == 1 || mouseState == 9 || mouseState == 5) {
            datetime time;
            double price;
            int var = 0;
            ChartXYToTimePrice(0, (int) lparam, (int) dparam, var, time, price);
            if(Action == "hLine_s") {
               ObjectMove(0, DrawingObjName, 0, time, price);
               if(HorizontalLineType == Trend) {
                  //if(mouseState == 5)
                  //   ObjectMove(0, DrawingObjName, 1, time + PeriodSeconds() *  (HorizontalLineLength * 5), price);
                  //else
                  ObjectMove(0, DrawingObjName, 1, TimeCurrent() + PeriodSeconds() * HorizontalLineLength, price);
               } else if(HorizontalLineType == TrendLenght) {
                  ObjectMove(0, DrawingObjName, 1, time + PeriodSeconds() * HorizontalLineLength, price);
               }
            } else
               ObjectMove(0, DrawingObjName, Action == "line_s" ? 1 : 0, time, price);
         } else {
            if(mouseState != 8) {
               ChartSetInteger(0, CHART_MOUSE_SCROLL, true);
               ObjectSetInteger(0, PREFIX + "-" + Action, OBJPROP_STATE, false);
               if(StringFind(Action, "ine") != -1) {
                  ObjectSetInteger(0, PREFIX + "-" + Action + "|" + IntegerToString(DrawingMode), OBJPROP_STATE, false);
                  for(int a=1; a<=4; a++)
                     ObjectSetInteger(0, PREFIX+"-"+Action+"|"+IntegerToString(a), OBJPROP_XSIZE, 1);
               }
               Action = NULL;
            }
            isDrawing = false;
            DrawnObjsCount++;
         }
         ChartRedraw();
      } else {
         if(((lastMouseState == 0 && mouseState == 1) || (lastMouseState == 8 && mouseState == 9) || (lastMouseState == 4 && mouseState == 5)) && (lparam > x || ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS) - dparam > 160) ) {
            DrawingObjName  = PREFIX + "-" + Action + "-" + IntegerToString(DrawnObjsCount) + "-" + string(Period());
            while(ObjectFind(0, DrawingObjName) >= 0) {
               DrawnObjsCount += 1000;
               DrawingObjName  = PREFIX + "-" + Action + "-" + IntegerToString(DrawnObjsCount) + "-" + string(Period());
            }
            datetime time;
            double price;
            int subWindow = 0;
            ChartXYToTimePrice(0, (int) lparam, (int) dparam, subWindow, time, price);
            if(Action == "vLine_s")
               ObjectCreate(0, DrawingObjName, OBJ_VLINE, subWindow, 0, 0);
            else if(Action == "hLine_s" && HorizontalLineType == Full)
               ObjectCreate(0, DrawingObjName, OBJ_HLINE, subWindow, 0, 0);
            else if(Action == "box_s" || Action == "boxF_s") {
               ObjectCreate(0, DrawingObjName, OBJ_RECTANGLE, subWindow, 0, 0);
               if(Action == "boxF_s")
                  ObjectSetInteger(0, DrawingObjName, OBJPROP_FILL, true);
            } else
               ObjectCreate(0, DrawingObjName, OBJ_TREND, subWindow, 0, 0);
            ObjectSetInteger(0, DrawingObjName, OBJPROP_RAY_RIGHT, false);
            int LW  = LinesWidth;
            LineType LT = LinesType;
            if(StringFind(Action, "ine") != -1) {
               switch(DrawingMode) {
               case 1:
                  LT = Solid;
                  LW = 1;
                  break;
               case 2:
                  LT = Solid;
                  LW = 2;
                  break;
               case 3:
                  LT = Dash;
                  LW = 1;
                  break;
               case 4:
                  LT = Dash;
                  LW = 2;
                  break;
               }
            }
            ObjectSetInteger(0, DrawingObjName, OBJPROP_WIDTH, LW);
            ObjectSetInteger(0, DrawingObjName, OBJPROP_STYLE, LT);
            if(Action == "hLine_s") {
               ObjectMove(0, DrawingObjName, 0, time, price);
               if(HorizontalLineType == Trend)
                  ObjectMove(0, DrawingObjName, 1, TimeCurrent() + PeriodSeconds() * HorizontalLineLength, price);
               else if(HorizontalLineType == TrendLenght)
                  ObjectMove(0, DrawingObjName, 1, time + PeriodSeconds() * HorizontalLineLength, price);
            } else if(Action == "line_s" || Action == "box_s" || Action == "boxF_s") {
               ObjectMove(0, DrawingObjName, 0, time, price);
               ObjectMove(0, DrawingObjName, 1, time, price);
            } else
               ObjectMove(0, DrawingObjName, 0, time, price);
            ObjectSetInteger(0, DrawingObjName, OBJPROP_COLOR, selectedClr);
            ObjectSetInteger(0, DrawingObjName, OBJPROP_HIDDEN, false);
            ObjectSetInteger(0, DrawingObjName, OBJPROP_SELECTABLE, true);
            if(oneTimer) {
               uint timeframeToDrawOn = PERIOD_CURRENT;
               if(Period() == PERIOD_M1)
                  timeframeToDrawOn = OBJ_PERIOD_M1;
               else if(Period() == PERIOD_M2)
                  timeframeToDrawOn = OBJ_PERIOD_M2;
               else if(Period() == PERIOD_M3)
                  timeframeToDrawOn = OBJ_PERIOD_M3;
               else if(Period() == PERIOD_M4)
                  timeframeToDrawOn = OBJ_PERIOD_M4;
               else if(Period() == PERIOD_M5)
                  timeframeToDrawOn = OBJ_PERIOD_M5;
               else if(Period() == PERIOD_M6)
                  timeframeToDrawOn = OBJ_PERIOD_M6;
               else if(Period() == PERIOD_M10)
                  timeframeToDrawOn = OBJ_PERIOD_M10;
               else if(Period() == PERIOD_M12)
                  timeframeToDrawOn = OBJ_PERIOD_M12;
               else if(Period() == PERIOD_M15)
                  timeframeToDrawOn = OBJ_PERIOD_M15;
               else if(Period() == PERIOD_M20)
                  timeframeToDrawOn = OBJ_PERIOD_M20;
               else if(Period() == PERIOD_M30)
                  timeframeToDrawOn = OBJ_PERIOD_M30;
               else if(Period() == PERIOD_H1)
                  timeframeToDrawOn = OBJ_PERIOD_H1;
               else if(Period() == PERIOD_H2)
                  timeframeToDrawOn = OBJ_PERIOD_H2;
               else if(Period() == PERIOD_H3)
                  timeframeToDrawOn = OBJ_PERIOD_H3;
               else if(Period() == PERIOD_H4)
                  timeframeToDrawOn = OBJ_PERIOD_H4;
               else if(Period() == PERIOD_H6)
                  timeframeToDrawOn = OBJ_PERIOD_H6;
               else if(Period() == PERIOD_H8)
                  timeframeToDrawOn = OBJ_PERIOD_H8;
               else if(Period() == PERIOD_H12)
                  timeframeToDrawOn = OBJ_PERIOD_H12;
               else if(Period() == PERIOD_D1)
                  timeframeToDrawOn = OBJ_PERIOD_D1;
               else if(Period() == PERIOD_W1)
                  timeframeToDrawOn = OBJ_PERIOD_W1;
               else if(Period() == PERIOD_MN1)
                  timeframeToDrawOn = OBJ_PERIOD_MN1;
               ObjectSetInteger(0, DrawingObjName, OBJPROP_TIMEFRAMES, timeframeToDrawOn);
            }
            isDrawing = true;
            ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
         }
      }
      lastMouseState = mouseState;
      ChartRedraw();
   }
}
//+------------------------------------------------------------------+
string tf(ENUM_TIMEFRAMES t)
{
   switch(t) {
   case PERIOD_M1:
      return("M1");
   case PERIOD_M2:
      return("M2");
   case PERIOD_M3:
      return("M3");
   case PERIOD_M4:
      return("M4");
   case PERIOD_M5:
      return("M5");
   case PERIOD_M6:
      return("M6");
   case PERIOD_M10:
      return("M10");
   case PERIOD_M12:
      return("M12");
   case PERIOD_M15:
      return("M15");
   case PERIOD_M20:
      return("M20");
   case PERIOD_M30:
      return("M30");
   case PERIOD_H1:
      return("H1");
   case PERIOD_H2:
      return("H2");
   case PERIOD_H3:
      return("H3");
   case PERIOD_H4:
      return("H4");
   case PERIOD_H8:
      return("H8");
   case PERIOD_H12:
      return("H(2");
   case PERIOD_D1:
      return("D1");
   case PERIOD_W1:
      return("W1");
   case PERIOD_MN1:
      return("MN1");
   default:
      return("Unknown timeframe");
   }
}
//+------------------------------------------------------------------+
