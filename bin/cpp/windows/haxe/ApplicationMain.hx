class ApplicationMain
{
   #if waxe
   static public var frame : wx.Frame;
   static public var autoShowFrame : Bool = true;
   #if nme
   static public var nmeStage : wx.NMEStage;
   #end
   #end

   public static function main()
   {
      #if waxe
      wx.App.boot( function()
      {
         
         frame = wx.Frame.create(null,null,"Robothaxe nme",null,{width: 800, height: 480 });
         
         #if nme
         var stage = wx.NMEStage.create(frame,null,null,{width:800,height:480});
         #end

         Main.main();
         if (autoShowFrame)
         {
            wx.App.setTopWindow(frame);
            frame.shown = true;
         }
      } );
      #else
      nme.Lib.create(
           function(){ Main.main(); },
           800, 480,
           60,
           0xFFFFFF,
             ( true   ? nme.Lib.HARDWARE  : 0) |
             ( true ? nme.Lib.RESIZABLE : 0) |
             ( false ? nme.Lib.BORDERLESS : 0) |
             ( false ? nme.Lib.FULLSCREEN : 0) |
			 ( 1 == 4 ? nme.Lib.HW_AA_HIRES : 0) |
			 ( 1 == 2 ? nme.Lib.HW_AA : 0),
          "Robothaxe nme", 
          "com.ezeql.haxe.calc"
          
             , getAsset("icon.png")
          
          );
       #end
   }

   public static function getAsset(inName:String):Dynamic
   {
      
      if (inName=="icon.png")
      {
         
            return nme.installer.Assets.getBitmapData ("icon.png");
         
      }
      
      return null;
   }
}

