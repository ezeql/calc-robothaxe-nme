package ;


import com.ezeql.calc.CalcContext;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author EzeQL
 */

class Main 
{
	static var context:CalcContext;
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		context = new CalcContext(Lib.current);
		
		
	}
	

	
}