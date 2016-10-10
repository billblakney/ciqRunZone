//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;using Toybox.System as Sys;using Toybox.Graphics as Gfx;using Toybox.Time as Time;

class DataField1 extends Ui.DataField
{
   const METERS_TO_MILES=0.000621371; // TODO rm, not used
   const MILLISECONDS_TO_SECONDS=0.001;

   var counter;
   // var value_picked = null;

   var heartRate = null;
   var pace = null; // seconds/mile
   var elapsedTime = null; // seconds
   var distance = null;

   var split;

   // Constructor
   function initialize()
   {

      DataField.initialize();

      counter = 0;

      heartRate = null;
      pace = null;
      elapsedTime = 0;
      distance = 0.0;

      if (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC)
      {
         split = 1000.0;
      }
      else
      {
         split = 1609.0;
      }
   }

   // Handle the update event
   function compute(info) {

/*
        //Cycle between Heart Rate (int), Distance (float), and elapsedTime (Duration)
        if(counter == 0) {
            if(info.currentHeartRate != null) {
                value_picked = info.currentHeartRate;
            }
        }
        if(counter == 1) {
            if(info.elapsedDistance != null) {
                value_picked = info.elapsedDistance * METERS_TO_MILES;
            }
        }
        if(counter == 2) {
            if(info.elapsedTime != null) {
                //elapsedTime is in ms.
                var options = { :seconds => info.elapsedTime *  MILLISECONDS_TO_SECONDS};
                value_picked = Time.Gregorian.duration(options);
            }
        }

        counter += 1;
        if(counter > 2) {
            counter = 0;
        }
*/

		elapsedTime = info.timerTime * MILLISECONDS_TO_SECONDS;
// TESTED
//		elapsedTime = 4088; // = 60*60 + 8*60 + 8 -> 1:08:08
//		elapsedTime = 3600; // = 60*60            -> 1:00:00
//		elapsedTime = 728;  // 728 = 12*60 + 8    ->   12:08
//		elapsedTime = 488;  // 484 = 8*60+8       ->    8:08

		distance = toDist(info.elapsedDistance);
// TESTED
//		distance = "9.99";
//		distance = "10.00";

		heartRate = info.currentHeartRate;
// TESTED
//		heartRate = 100;
//		heartRate = 88;

		var speed = info.currentSpeed;
//speed /= 4; // increase speed to get double digit pace
//Sys.println("speed " + speed);
		pace = toPace(speed); // sec/mile
// TESTED
//		pace = 8*60;  //  8:00
//		pace = 10*60; // 10:00


//        return value_picked;
    }

   function onLayout(dc) {
	}

   function onShow()
   {
   }

   function onHide() {
	}

   function onUpdate(dc) {

		var width = dc.getWidth();
		var height = dc.getHeight();
		
		var halfHeight = height/2.0;
	
    	var xTopLine = 85;
    	var xBottomLine = 105;

    	var yLine2 = halfHeight;

		// compute yRow1Number and yRow1Label
		var fontHeightNum = Gfx.getFontHeight(Gfx.FONT_NUMBER_HOT);
		var fontHeightTxt = Gfx.getFontHeight(Gfx.FONT_XTINY);

		var yRow1Number = yLine2;
		yRow1Number = yRow1Number - fontHeightNum/2 - 3;

		var yRow1Label = yRow1Number - fontHeightNum/2;
		yRow1Label = yRow1Label - fontHeightTxt/2 + 7;

		// compute yRow2Number and yRow2Label
		var yRow2Label = yLine2 + fontHeightTxt/2 + 0;

		var yRow2Number = yRow2Label;
		yRow2Number = yRow2Number + fontHeightNum/2 + 0;
		
		// set black font color
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		var font;

		// heart rate
		textR(dc, xTopLine-14, yRow1Label, Gfx.FONT_XTINY,  "Heart");
		if (heartRate != null && heartRate > 100)
		{
			font = Gfx.FONT_NUMBER_HOT;
		}
		else
		{
			font = Gfx.FONT_NUMBER_HOT;
		}
		textR(dc, xTopLine-5, yRow1Number, font,  toStr(heartRate));

		// pace
		textR(dc, xBottomLine-30, yRow2Label, Gfx.FONT_XTINY,  "Pace");

		if (pace != null && pace < 10*60) {
			font = Gfx.FONT_NUMBER_HOT;
		}
		else {
			font = Gfx.FONT_NUMBER_MEDIUM;
		}
		textR(dc, xBottomLine-5, yRow2Number, font, fmtSecs(pace));

		// timer
		textL(dc, xTopLine+35, yRow1Label, Gfx.FONT_XTINY,  "Timer");
		
		// TODO offset for 10:00 vs 1:00
		if (elapsedTime >= 3600)
		{
			font = Gfx.FONT_NUMBER_MEDIUM;
		}
		else
		{
			font = Gfx.FONT_NUMBER_HOT;
		}
		textL(dc, xTopLine+8, yRow1Number, font,  fmtSecs(elapsedTime));

		// distance
		textL(dc, xBottomLine+28, yRow2Label, Gfx.FONT_XTINY, "Distance");

		if (distance.toFloat() < 10) {
			font = Gfx.FONT_NUMBER_HOT;
		}
		else {
			font = Gfx.FONT_NUMBER_MEDIUM;
		}
		textL(dc, xBottomLine+7, yRow2Number, font, distance);

		// DRAW LINES

		dc.setPenWidth(2);
		dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT);

		// horizontal lines
		dc.drawLine(0, halfHeight, 215, halfHeight);
		dc.drawLine(0, halfHeight, 215, halfHeight);

		// vertical lines
		dc.drawLine(xTopLine,   0, xTopLine,   90);

		dc.drawLine(xBottomLine,   90, xBottomLine,   180);

		return true;
	}

   function toPace(speed) {
		if (speed == null || speed == 0) {
		return null;
		}

		return split / speed; // cvt meter/sec to km or mi/sec
	}

   function textL(dc, x, y, font, s) {
		if (s != null) {
			dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
		}
	}

   function textR(dc, x, y, font, s) {
		if (s != null) {
			dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
		}
	}

   function textC(dc, x, y, font, s) {
		if (s != null) {
			dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
		}
	}

   function toStr(o) {
		if (o != null && o > 0) {
			return "" + o;
		} else {
			return "---";
		}
	}

   function fmtTime(clock) {

		var h = clock.hour;
		timeFieldOffset = 0;

		if (!Sys.getDeviceSettings().is24Hour) {
			if (h > 12) {
				h -= 12;
			} else if (h == 0) {
				h += 12;
			}
		}

		if (h >= 10) {
			timeFieldOffset = 2;
		}

		return "" + h + ":" + clock.min.format("%02d");
	}

   function fmtSecs(secs) {

		if (secs == null) {
			return "---";
		}

		var s = secs.toLong();
		var hours = s / 3600;
		s -= hours * 3600;
		var minutes = s / 60;
		s -= minutes * 60;

		var fmt;
		if (hours > 0) {
			fmt = "" + hours + ":" + minutes.format("%02d") + ":" + s.format("%02d");
		} else {
			fmt = "" + minutes + ":" + s.format("%02d");
		}

		return fmt;

		return "x";
	}

   function toDist(dist) {
		if (dist == null) {
			return "0.00";
		}

		dist = dist / split;
		return dist.format("%.2f", dist);
	}

}