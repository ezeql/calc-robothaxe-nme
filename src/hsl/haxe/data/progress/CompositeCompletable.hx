package hsl.haxe.data.progress;
import hsl.haxe.data.progress.Completable;
import hsl.haxe.direct.DirectSignaler;
import hsl.haxe.Signaler;

class CompositeCompletable implements Completable {
	public var completedSignaler(default, null):Signaler<Void>;
	private var numberOfCompletables:Int;
	public function new(completables:List<Completable>):Void {
		completedSignaler = new DirectSignaler(this);
		
		for (completable in completables) {
			numberOfCompletables++;
			completable.completedSignaler.bindVoid(decrementNumberOfLoaders);
		}
	}
	private function decrementNumberOfLoaders():Void {
		if (--numberOfCompletables == 0) {
			completedSignaler.dispatch();
		}
	}
}