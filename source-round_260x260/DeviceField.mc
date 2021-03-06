using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Attention as Attn;
using Toybox.UserProfile as Profile;

/*
 * DeviceField
 */
class DeviceField extends RunZoneField
{
   /*
    * Constructor.
    */
   function initialize()
   {
      RunZoneField.initialize();
   }

   /*
    * Sets the layout.
    */
   function onLayout(dc)
   {
      RunZoneField.onLayout(dc);

      yRow0Label = 20;   // zone area
      yTopLine = 40;     // ----------
      yRow1Label = 58;   // timer/BPM label
      yRow1Number = 96;  // timer/BPM value
      yMiddleLine = 130; // ----------
      yRow2Number = 160; // dist/pace value
      yRow2Label = 193;  // dist/pace label
      yBottomLine = 209; // ----------
      yRow3Label = 232;  // time

      xTopLine = 147;
      xBottomLine = 130;

      xRow0Label = 133;
      xRow1Col1Label = 80;
      xRow1Col1Num = 74;
      xRow1Col2Label = 185;
      xRow1Col2Num = 192;
      xRow2Col1Label = 77;
      xRow2Col1Num = 70;
      xRow2Col2Label = 168;
      xRow2Col2Num = 187;
      xRow3Label = 132;
   }

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      if (duration < 3600) {
         return Gfx.FONT_NUMBER_MEDIUM;
      } else {
         return Gfx.FONT_NUMBER_MILD;
      }
   }

   /*
    * Gets the heartRate font.
    */
   function getHeartRateFont(heartRate)
   {
      return Gfx.FONT_NUMBER_MEDIUM;
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      if (dist.toFloat() < 10) {
         return Gfx.FONT_SYSTEM_NUMBER_MEDIUM;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      return Gfx.FONT_NUMBER_MEDIUM;
   }

   /*
    * Gets the time-of-day font.
    */
   function getTimeOfDayFont()
   {
      return Gfx.FONT_MEDIUM;
   }
}
